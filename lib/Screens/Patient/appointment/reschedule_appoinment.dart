
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RescheduleBottomSheet extends StatefulWidget {
  final Map<String, dynamic> appointment;

  const RescheduleBottomSheet({super.key, required this.appointment});

  @override
  State<RescheduleBottomSheet> createState() => _RescheduleBottomSheetState();
}

class _RescheduleBottomSheetState extends State<RescheduleBottomSheet> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // State
  bool _isLoadingDoctor = true;
  bool _isRescheduling = false;
  Map<String, dynamic>? _doctorData;
  
  // Selection State
  int _selectedDateIndex = 0;
  String? _selectedTimeSlot;
  
  // Slot Data
  List<String> _bookedSlotsForDate = [];
  List<String> _morningSlots = [];
  List<String> _afternoonSlots = [];
  bool _isDayActive = true;

  // Generate next 7 days
  final List<DateTime> _dates = List.generate(7, (i) => DateTime.now().add(Duration(days: i)));

  @override
  void initState() {
    super.initState();
    _fetchDoctorAndSlots();
  }

  // ---------------------------------------------------------------------------
  // HELPER METHODS (Replacing Intl)
  // ---------------------------------------------------------------------------

  // Replaces: DateFormat('yyyy-MM-dd')
  String _formatDateForDB(DateTime date) {
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    return "${date.year}-$month-$day";
  }

  // Replaces: DateFormat('EEEE') -> "Monday", "Tuesday"
  String _getFullDayName(DateTime date) {
    const List<String> days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    // DateTime.weekday returns 1 for Mon, 7 for Sun. We need 0-6 index.
    return days[date.weekday - 1];
  }

  // Replaces: DateFormat('EEE') -> "Mon", "Tue"
  String _getAbbreviatedDayName(DateTime date) {
    const List<String> days = [
      'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
    ];
    return days[date.weekday - 1];
  }
  // ---------------------------------------------------------------------------

  // --- 1. Fetch Doctor Data ---
  Future<void> _fetchDoctorAndSlots() async {
    final String doctorId = widget.appointment['doctorId'];
    
    try {
      final snapshot = await _dbRef.child("healthcare/users/providers/$doctorId").get();
      if (snapshot.exists) {
        if (mounted) {
          setState(() {
            _doctorData = Map<String, dynamic>.from(snapshot.value as Map);
            _isLoadingDoctor = false;
          });
          // After fetching doctor, generate slots for the default selected date (Today)
          _fetchBookedSlotsForDate();
        }
      }
    } catch (e) {
      debugPrint("Error fetching doctor: $e");
      if (mounted) setState(() => _isLoadingDoctor = false);
    }
  }

  // --- 2. Fetch Booked Slots (from booked_slots node) ---
  void _fetchBookedSlotsForDate() {
    // Reset slots while loading
    setState(() {
      _bookedSlotsForDate.clear();
      _selectedTimeSlot = null;
    });

    final String doctorId = widget.appointment['doctorId'];
    
    // UPDATED: Use manual helper instead of Intl
    final String dateKey = _formatDateForDB(_dates[_selectedDateIndex]);

    _dbRef.child("healthcare/booked_slots/$doctorId/$dateKey").onValue.listen((event) {
      final List<String> booked = [];
      if (event.snapshot.exists && event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, _) => booked.add(key.toString()));
      }
      
      if (mounted) {
        setState(() {
          _bookedSlotsForDate = booked;
        });
        // Now that we know what's booked, generate the available list
        _generateTimeSlots();
      }
    });
  }

  // --- 3. Slot Generation Logic (With 1-Hour Buffer) ---
  void _generateTimeSlots() {
    if (_doctorData == null) return;

    _morningSlots.clear();
    _afternoonSlots.clear();
    
    final DateTime selectedDate = _dates[_selectedDateIndex];
    
    // UPDATED: Use manual helper instead of Intl
    final String dayName = _getFullDayName(selectedDate); // e.g., "Monday"
    
    // Access Availability Node
    final availability = _doctorData!['availability'];
    if (availability == null || availability[dayName] == null) {
      setState(() => _isDayActive = false);
      return;
    }

    final dayData = availability[dayName];
    if (dayData['active'] != true) {
      setState(() => _isDayActive = false);
      return;
    }

    setState(() => _isDayActive = true);

    if (dayData['slots'] != null) {
      final List<dynamic> ranges = dayData['slots'];
      for (var range in ranges) {
        _processTimeRange(range, selectedDate);
      }
    }
  }

  void _processTimeRange(dynamic range, DateTime selectedDate) {
    final String startStr = range['start'] ?? "09:00";
    final String endStr = range['end'] ?? "17:00";
    final slotDurationValue = range['slotDuration'];
    final int duration = (slotDurationValue is int) 
        ? slotDurationValue 
        : (int.tryParse(slotDurationValue?.toString() ?? "30") ?? 30);

    int currentMins = _timeToMinutes(startStr);
    int endMins = _timeToMinutes(endStr);

    // Get "Now" details
    final now = DateTime.now();
    final bool isToday = selectedDate.year == now.year && 
                         selectedDate.month == now.month && 
                         selectedDate.day == now.day;
    final int nowMins = (now.hour * 60) + now.minute;

    // RULE: Buffer time (e.g., cannot book within 60 mins of now)
    const int bufferMins = 60;

    while (currentMins + duration <= endMins) {
      // 1. Check if time has passed (plus buffer)
      if (isToday && currentMins < (nowMins + bufferMins)) {
        currentMins += duration;
        continue; 
      }

      // 2. Format Time String (e.g., "09:30 AM")
      final String timeStr = _minutesToTimeStr(currentMins);

      // 3. Check if already booked (exclude current booking if checking same day)
      // Note: In reschedule, the user's *current* slot is technically "booked", 
      // but usually we want to allow them to pick a *different* slot.
      if (!_bookedSlotsForDate.contains(timeStr)) {
         if (currentMins < 720) { // Before 12:00 PM
           _morningSlots.add(timeStr);
         } else {
           _afternoonSlots.add(timeStr);
         }
      }

      currentMins += duration;
    }
  }

  // --- 4. Handle Reschedule Action ---
  Future<void> _confirmReschedule() async {
    if (_selectedTimeSlot == null) return;
    
    setState(() => _isRescheduling = true);

    final String apptId = widget.appointment['appointmentId'] ?? widget.appointment['id'] ?? '';
    final String doctorId = widget.appointment['doctorId'] ?? '';
    
    if (apptId.isEmpty || doctorId.isEmpty) {
      if (mounted) {
        setState(() => _isRescheduling = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Missing appointment information"), backgroundColor: Colors.red),
        );
      }
      return;
    }
    
    // Old Data - parse the date from ISO string if needed
    String oldDate = widget.appointment['date'] ?? '';
    if (oldDate.contains('T')) {
      // If it's an ISO string, extract just the date part
      oldDate = oldDate.split('T')[0];
    }
    final String oldTime = widget.appointment['time'] ?? '';
    
    // New Data
    final String newDate = _formatDateForDB(_dates[_selectedDateIndex]);
    final String newTime = _selectedTimeSlot!;

    try {
      // 1. Remove Old Slot from booked_slots (if old date/time exists)
      if (oldDate.isNotEmpty && oldTime.isNotEmpty) {
        await _dbRef.child("healthcare/booked_slots/$doctorId/$oldDate/$oldTime").remove();
      }

      // 2. Add New Slot to booked_slots
      await _dbRef.child("healthcare/booked_slots/$doctorId/$newDate/$newTime").set(true);

      // 3. Update Master Appointment Record
      await _dbRef.child("healthcare/all_appointments/$apptId").update({
        "date": DateTime.parse(newDate).toIso8601String(), // Store as ISO string for consistency
        "time": newTime,
        "updatedAt": DateTime.now().toIso8601String(),
      });

      if (mounted) {
        Navigator.pop(context); // Close Sheet
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Rescheduled Successfully!"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isRescheduling = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  // --- Helpers ---
  int _timeToMinutes(String time) {
    final parts = time.split(":");
    return (int.parse(parts[0]) * 60) + int.parse(parts[1]);
  }

  String _minutesToTimeStr(int totalMinutes) {
    int h = totalMinutes ~/ 60;
    int m = totalMinutes % 60;
    String period = h >= 12 ? "PM" : "AM";
    int displayH = h > 12 ? h - 12 : h;
    if (displayH == 0) displayH = 12;
    return "$displayH:${m.toString().padLeft(2, '0')} $period";
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingDoctor) {
      return const SizedBox(height: 300, child: Center(child: CircularProgressIndicator()));
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Center(
            child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
          ),
          const SizedBox(height: 20),
          Text("Reschedule Appointment", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text("Select a new date and time for Dr. ${_doctorData?['lastName'] ?? ''}", style: TextStyle(color: Colors.grey.shade600)),
          
          const SizedBox(height: 20),

          // Date Selector
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _dates.length,
              itemBuilder: (ctx, i) {
                final date = _dates[i];
                final isSelected = i == _selectedDateIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDateIndex = i;
                      _fetchBookedSlotsForDate(); // Refresh slots for new date
                    });
                  },
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade200),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // UPDATED: Use manual helper instead of Intl
                        Text(_getAbbreviatedDayName(date), style: TextStyle(fontSize: 12, color: isSelected ? Colors.white70 : Colors.grey)),
                        const SizedBox(height: 4),
                        Text(date.day.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Time Slots
          Expanded(
            child: SingleChildScrollView(
              child: !_isDayActive 
              ? Center(child: Padding(padding: const EdgeInsets.all(20), child: Text("Doctor is not available on this day.", style: TextStyle(color: Colors.grey.shade500))))
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_morningSlots.isNotEmpty) ...[
                    const Text("Morning", style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    _buildGrid(_morningSlots),
                    const SizedBox(height: 20),
                  ],
                  if (_afternoonSlots.isNotEmpty) ...[
                    const Text("Afternoon", style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    _buildGrid(_afternoonSlots),
                  ],
                  if (_morningSlots.isEmpty && _afternoonSlots.isEmpty)
                     Center(child: Padding(padding: const EdgeInsets.all(20), child: Text("No slots available.", style: TextStyle(color: Colors.grey.shade500)))),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Confirm Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_selectedTimeSlot == null || _isRescheduling) ? null : _confirmReschedule,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isRescheduling 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text("Confirm Reschedule"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<String> slots) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: slots.map((time) {
        final isSelected = _selectedTimeSlot == time;
        return InkWell(
          onTap: () => setState(() => _selectedTimeSlot = time),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.white,
              border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              time, 
              style: TextStyle(
                fontSize: 13, 
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87
              )
            ),
          ),
        );
      }).toList(),
    );
  }
}