
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

  // --- State Variables ---
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

  // Generate next 7 days starting from today
  final List<DateTime> _dates = List.generate(7, (i) => DateTime.now().add(Duration(days: i)));

  @override
  void initState() {
    super.initState();
    _fetchDoctorAndSlots();
  }

  // ---------------------------------------------------------------------------
  // HELPER METHODS (Manual Date/Time formatting without Intl package)
  // ---------------------------------------------------------------------------

  // Returns "YYYY-MM-DD"
  String _formatDateForDB(DateTime date) {
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    return "${date.year}-$month-$day";
  }

  // Returns "Monday", "Tuesday"
  String _getFullDayName(DateTime date) {
    const List<String> days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    return days[date.weekday - 1];
  }

  // Returns "Mon", "Tue"
  String _getAbbreviatedDayName(DateTime date) {
    const List<String> days = [
      'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
    ];
    return days[date.weekday - 1];
  }

  // Converts "09:30" to minutes (e.g., 570)
  int _timeToMinutes(String time) {
    final parts = time.split(":");
    return (int.parse(parts[0]) * 60) + int.parse(parts[1]);
  }

  // Converts 570 to "09:30 AM"
  String _minutesToTimeStr(int totalMinutes) {
    int h = totalMinutes ~/ 60;
    int m = totalMinutes % 60;
    String period = h >= 12 ? "PM" : "AM";
    int displayH = h > 12 ? h - 12 : h;
    if (displayH == 0) displayH = 12;
    return "$displayH:${m.toString().padLeft(2, '0')} $period";
  }

  // ---------------------------------------------------------------------------
  // DATA FETCHING
  // ---------------------------------------------------------------------------

  // 1. Fetch Basic Doctor Info
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
          // Once we have doctor info, fetch bookings for the default date (Today)
          _fetchBookedSlotsForDate();
        }
      }
    } catch (e) {
      debugPrint("Error fetching doctor: $e");
      if (mounted) setState(() => _isLoadingDoctor = false);
    }
  }

  // 2. Listen to Booked Slots for the selected date
  void _fetchBookedSlotsForDate() {
    // Reset selection when date changes
    setState(() {
      _bookedSlotsForDate.clear();
      _selectedTimeSlot = null;
    });

    final String doctorId = widget.appointment['doctorId'];
    final String dateKey = _formatDateForDB(_dates[_selectedDateIndex]);

    // Listen to realtime changes in booked slots
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
        // Now calculate available slots based on doctor settings + booked slots + current time
        _generateTimeSlots();
      }
    });
  }

  // ---------------------------------------------------------------------------
  // SLOT LOGIC (Core "Next Slot" Logic)
  // ---------------------------------------------------------------------------

  void _generateTimeSlots() {
    if (_doctorData == null) return;

    setState(() {
      _morningSlots.clear();
      _afternoonSlots.clear();
    });
    
    final DateTime selectedDate = _dates[_selectedDateIndex];
    final String dayName = _getFullDayName(selectedDate); // e.g., "Monday"
    
    // Check if availability exists for this day
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

    // Process all time ranges (e.g., Morning Shift, Evening Shift)
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

  int currentSlotMins = _timeToMinutes(startStr);
  int endMins = _timeToMinutes(endStr);

  final now = DateTime.now();
  final bool isToday =
      selectedDate.year == now.year &&
      selectedDate.month == now.month &&
      selectedDate.day == now.day;

  final int nowMins = (now.hour * 60) + now.minute;

  // Cannot reschedule within next 60 minutes
  const int bufferMins = 60;
  final int earliestValidMins = nowMins + bufferMins;

  while (currentSlotMins + duration <= endMins) {
    final String dbFormatted = _minutesToTimeStr(currentSlotMins); 

    // --- RULE 1: Skip past time slots today ---
    if (isToday && currentSlotMins < earliestValidMins) {
      currentSlotMins += duration;
      continue;
    }

    // --- RULE 2: Skip already booked slots ---
    if (_bookedSlotsForDate.contains(dbFormatted)) {
      currentSlotMins += duration;
      continue;
    }

    // --- Add slot ---
    if (currentSlotMins < 720) {
      _morningSlots.add(dbFormatted);
    } else {
      _afternoonSlots.add(dbFormatted);
    }

    currentSlotMins += duration;
  }
}

  // ---------------------------------------------------------------------------
  // RESCHEDULE ACTION
  // ---------------------------------------------------------------------------

  Future<void> _confirmReschedule() async {
    if (_selectedTimeSlot == null) return;
    
    setState(() => _isRescheduling = true);

    // Get IDs
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
    
    // Handle Old Date/Time cleanup
    String oldDate = widget.appointment['date'] ?? '';
    // If stored as ISO "2023-10-10T14:30...", split it
    if (oldDate.contains('T')) {
      oldDate = oldDate.split('T')[0];
    }
    final String oldTime = widget.appointment['time'] ?? '';
    
    // New Data
    final String newDate = _formatDateForDB(_dates[_selectedDateIndex]);
    final String newTime = _selectedTimeSlot!;

    try {
      // 1. Remove Old Slot from booked_slots
      if (oldDate.isNotEmpty && oldTime.isNotEmpty) {
        await _dbRef.child("healthcare/booked_slots/$doctorId/$oldDate/$oldTime").remove();
      }

      // 2. Add New Slot to booked_slots
      await _dbRef.child("healthcare/booked_slots/$doctorId/$newDate/$newTime").set(true);

      // 3. Update Master Appointment Record
      await _dbRef.child("healthcare/all_appointments/$apptId").update({
        "date": DateTime.parse(newDate).toIso8601String(), // Store standard ISO
        "time": newTime,
        "status": "Rescheduled", // Optional status update
        "updatedAt": DateTime.now().toIso8601String(),
      });

      if (mounted) {
        Navigator.pop(context); // Close Bottom Sheet
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

  // ---------------------------------------------------------------------------
  // UI BUILD
  // ---------------------------------------------------------------------------

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
      // Padding handles Safe Area manually at bottom
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
          ),
          const SizedBox(height: 20),
          
          // Title
          Text("Reschedule Appointment", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text("Select a new date and time for Dr. ${_doctorData?['lastName'] ?? ''}", style: TextStyle(color: Colors.grey.shade600)),
          
          const SizedBox(height: 20),

          // Date Selector (Horizontal Scroll)
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
                      _fetchBookedSlotsForDate(); // Logic reruns when date changes
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

          // Time Slots Area
          Expanded(
            child: SingleChildScrollView(
              child: !_isDayActive 
              ? Center(child: Padding(padding: const EdgeInsets.all(20), child: Text("Doctor is not available on this day.", style: TextStyle(color: Colors.grey.shade500))))
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Morning Section
                  if (_morningSlots.isNotEmpty) ...[
                    const Text("Morning", style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    _buildGrid(_morningSlots),
                    const SizedBox(height: 20),
                  ],
                  // Afternoon Section
                  if (_afternoonSlots.isNotEmpty) ...[
                    const Text("Afternoon", style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    _buildGrid(_afternoonSlots),
                  ],
                  // Empty State
                  if (_morningSlots.isEmpty && _afternoonSlots.isEmpty)
                      Center(child: Padding(padding: const EdgeInsets.all(20), child: Text("No available slots for this date.", style: TextStyle(color: Colors.grey.shade500)))),
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

  // Grid Builder for Time Chips
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
