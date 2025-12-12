import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RescheduleBottomSheet extends StatefulWidget {
  final Map<String, dynamic> appointment;

  const RescheduleBottomSheet({super.key, required this.appointment});

  @override
  State<RescheduleBottomSheet> createState() => _RescheduleBottomSheetState();
}

class _RescheduleBottomSheetState extends State<RescheduleBottomSheet> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  bool _isLoadingDoctor = true;
  bool _isRescheduling = false;
  Map<String, dynamic>? _doctorData;
  
  int _selectedDateIndex = 0;
  String? _selectedTimeSlot;
  int _selectedDuration = 30;

  List<String> _bookedSlotsForDate = [];
  final List<Map<String, dynamic>> _morningSlots = [];
  final List<Map<String, dynamic>> _afternoonSlots = [];
  
  bool _isDayActive = true;

  final List<DateTime> _dates = List.generate(7, (i) => DateTime.now().add(Duration(days: i)));

  @override
  void initState() {
    super.initState();
    _fetchDoctorAndSlots();
  }

  // --- Helpers ---
  String _formatDateForDB(DateTime date) {
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    return "${date.year}-$month-$day";
  }

  String _getAbbreviatedDayName(DateTime date) {
    const List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  String _getFullDayName(DateTime date) {
    const List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[date.weekday - 1];
  }

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

  // --- Fetching ---
  Future<void> _fetchDoctorAndSlots() async {
    final String doctorId = widget.appointment['doctorId'] ?? widget.appointment['id'];
    try {
      final snapshot = await _dbRef.child("healthcare/users/providers/$doctorId").get();
      if (snapshot.exists) {
        if (mounted) {
          setState(() {
            _doctorData = Map<String, dynamic>.from(snapshot.value as Map);
            _isLoadingDoctor = false;
          });
          _fetchBookedSlotsForDate();
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingDoctor = false);
    }
  }

  void _fetchBookedSlotsForDate() {
    setState(() {
      _bookedSlotsForDate.clear();
      _selectedTimeSlot = null;
    });

    final String doctorId = widget.appointment['doctorId'] ?? widget.appointment['id'];
    final String dateKey = _formatDateForDB(_dates[_selectedDateIndex]);

    _dbRef.child("healthcare/booked_slots/$doctorId/$dateKey").onValue.listen((event) {
      final List<String> booked = [];
      if (event.snapshot.exists && event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        // Get keys (time strings) regardless of value (duration)
        data.forEach((key, _) => booked.add(key.toString()));
      }
      
      if (mounted) {
        setState(() {
          _bookedSlotsForDate = booked;
        });
        _generateTimeSlots();
      }
    });
  }

  // --- Slot Generation ---
  void _generateTimeSlots() {
    if (_doctorData == null) return;

    setState(() {
      _morningSlots.clear();
      _afternoonSlots.clear();
    });
    
    final DateTime selectedDate = _dates[_selectedDateIndex];
    final String dayName = _getFullDayName(selectedDate);
    
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

    int currentSlotMins = _timeToMinutes(startStr);
    int endMins = _timeToMinutes(endStr);

    final now = DateTime.now();
    final bool isToday = selectedDate.year == now.year && selectedDate.month == now.month && selectedDate.day == now.day;
    final int nowMins = (now.hour * 60) + now.minute;
    const int bufferMins = 60;

    // --- LOGIC TO HIDE CURRENT APPOINTMENT SLOT ---
    String currentApptDate = widget.appointment['date'] ?? '';
    if (currentApptDate.contains('T')) currentApptDate = currentApptDate.split('T')[0];
    String currentApptTime = widget.appointment['time'] ?? '';
    String selectedDateStr = _formatDateForDB(selectedDate);
    
    bool isSameDateAsCurrent = currentApptDate == selectedDateStr;

    while (currentSlotMins + duration <= endMins) {
      final String timeStr = _minutesToTimeStr(currentSlotMins);

      // 1. Skip Past Time if Today
      if (isToday && currentSlotMins < (nowMins + bufferMins)) {
        currentSlotMins += duration;
        continue;
      }

      // 2. Hide Current Appointment Slot (Requirement Fix)
      // If the generated slot matches the current booking, DO NOT add it to the list.
      if (isSameDateAsCurrent && timeStr == currentApptTime) {
        currentSlotMins += duration;
        continue; // Skip this iteration entirely
      }

      // 3. Mark Booked Slots (Show but Disabled)
      bool isBooked = _bookedSlotsForDate.contains(timeStr);

      final slotMap = {
        'time': timeStr,
        'duration': duration,
        'isBooked': isBooked,
      };

      if (currentSlotMins < 720) {
        _morningSlots.add(slotMap);
      } else {
        _afternoonSlots.add(slotMap);
      }

      currentSlotMins += duration;
    }
  }

  Future<void> _confirmReschedule() async {
    if (_selectedTimeSlot == null) return;
    setState(() => _isRescheduling = true);

    final String apptId = widget.appointment['appointmentId'] ?? widget.appointment['id'] ?? '';
    final String doctorId = widget.appointment['doctorId'] ?? widget.appointment['id'] ?? '';

    String oldDate = widget.appointment['date'] ?? '';
    if (oldDate.contains('T')) oldDate = oldDate.split('T')[0];
    final String oldTime = widget.appointment['time'] ?? '';
    
    final String newDate = _formatDateForDB(_dates[_selectedDateIndex]);
    final String newTime = _selectedTimeSlot!;

    try {
      // 1. Remove Old Booking
      if (oldDate.isNotEmpty && oldTime.isNotEmpty) {
        await _dbRef.child("healthcare/booked_slots/$doctorId/$oldDate/$oldTime").remove();
      }

      // 2. Add New Booking (Save Duration)
      await _dbRef.child("healthcare/booked_slots/$doctorId/$newDate/$newTime").set(_selectedDuration);

      // 3. Update Appointment
      await _dbRef.child("healthcare/all_appointments/$apptId").update({
        "date": newDate,
        "time": newTime,
        "duration": _selectedDuration,
        "status": "Rescheduled",
        "updatedAt": DateTime.now().toIso8601String(),
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Rescheduled Successfully!"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isRescheduling = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingDoctor) {
      return const SizedBox(height: 300, child: Center(child: CircularProgressIndicator()));
    }

    final String docName = _doctorData?['firstName'] != null 
        ? "Dr. ${_doctorData!['firstName']} ${_doctorData!['lastName']}" 
        : "Doctor";

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      height: 600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
          ),
          const SizedBox(height: 20),
          
          Text("Reschedule Appointment", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text("Select a new slot for $docName", style: TextStyle(color: Colors.grey.shade600)),
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
                    });
                    _fetchBookedSlotsForDate();
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
                      Center(child: Padding(padding: const EdgeInsets.all(20), child: Text("No available slots for this date.", style: TextStyle(color: Colors.grey.shade500)))),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

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

  Widget _buildGrid(List<Map<String, dynamic>> slots) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: slots.map((slotData) {
        final String time = slotData['time'];
        final int duration = slotData['duration'];
        final bool isBooked = slotData['isBooked'];
        
        final isSelected = _selectedTimeSlot == time;

        return InkWell(
          onTap: isBooked ? null : () {
            setState(() {
              _selectedTimeSlot = time;
              _selectedDuration = duration;
            });
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 90,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isBooked 
                  ? Colors.grey.shade100 // Grey background if booked
                  : (isSelected ? Colors.blue : Colors.white),
              border: Border.all(
                  color: isBooked 
                      ? Colors.transparent 
                      : (isSelected ? Colors.blue : Colors.grey.shade300)
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  time, 
                  style: TextStyle(
                    fontSize: 13, 
                    fontWeight: FontWeight.w500,
                    color: isBooked 
                        ? Colors.grey.shade400 // Grey text if booked
                        : (isSelected ? Colors.white : Colors.black87),
                    decoration: isBooked ? TextDecoration.lineThrough : null,
                  )
                ),
                const SizedBox(height: 2),
                Text(
                  "$duration min",
                  style: TextStyle(
                    fontSize: 10,
                    color: isBooked 
                        ? Colors.grey.shade400 // Grey text if booked
                        : (isSelected ? Colors.white70 : Colors.grey.shade500)
                  ),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}