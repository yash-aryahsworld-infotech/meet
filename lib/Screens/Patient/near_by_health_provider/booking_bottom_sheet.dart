import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// Ensure these imports match your actual file structure
import 'package:healthcare_plus/Screens/Patient/near_by_health_provider/date_selector.dart';
import 'package:healthcare_plus/Screens/Patient/near_by_health_provider/doctor_header.dart';
import 'package:healthcare_plus/Screens/Patient/near_by_health_provider/successbookingdialog.dart';
import 'package:healthcare_plus/Screens/Patient/near_by_health_provider/time_grid.dart';

class BookingBottomSheet extends StatefulWidget {
  final Map<String, dynamic> doctor;
  final String patientKey;

  const BookingBottomSheet({
    super.key, 
    required this.doctor, 
    required this.patientKey
  });

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // State
  int _selectedDateIndex = 0; // Default 0 is Today
  int _selectedTimeIndex = -1; 
  bool _isProcessing = false;
  bool _isLoadingSlots = false;
  bool _isDayActive = true;

  // Data
  List<String> _bookedSlotsForSelectedDate = [];
  List<String> _currentMorningSlots = [];
  List<String> _currentAfternoonSlots = [];
  
  // Generate next 7 days starting from NOW
  final List<DateTime> _dates = List.generate(7, (index) => DateTime.now().add(Duration(days: index)));

  @override
  void initState() {
    super.initState();
    _generateSlotsForSelectedDate();
    _fetchBookedSlots();
  }

  // --- HELPER: Day Name for Availability Key (Monday, Tuesday...) ---
  String _getFullDayName(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday - 1];
  }

  // --- HELPER: Date Format for Database (YYYY-MM-DD) ---
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // --- HELPER: Check if a specific date is Today ---
  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  // --- LOGIC: GENERATE SLOTS ---
  void _generateSlotsForSelectedDate() {
    // 1. Get the actual date object for the selected tab
    final DateTime selectedDateObj = _dates[_selectedDateIndex];
    final String dayName = _getFullDayName(selectedDateObj.weekday);

    _currentMorningSlots = [];
    _currentAfternoonSlots = [];
    _isDayActive = false;

    // 2. Check Doctor Availability Structure
    if (widget.doctor['availability'] == null || widget.doctor['availability'][dayName] == null) {
      if (mounted) setState(() {});
      return;
    }

    final dayData = widget.doctor['availability'][dayName];

    // 3. Check if Doctor is active that day
    if (dayData['active'] != true) {
      if (mounted) setState(() { _isDayActive = false; });
      return;
    }

    _isDayActive = true;

    // 4. Process Slots
    if (dayData['slots'] != null) {
      final List<dynamic> ranges = dayData['slots'];
      for (var range in ranges) {
        // IMPORTANT: Pass the selectedDateObj to check against current time
        _processTimeRange(range, selectedDateObj); 
      }
    }
    if (mounted) setState(() {});
  }

  void _processTimeRange(Map<dynamic, dynamic> range, DateTime dateForValidation) {
    final String startStr = range['start'] ?? "09:00";
    final String endStr = range['end'] ?? "17:00";
    final int durationMinutes = int.tryParse(range['slotDuration']?.toString() ?? "30") ?? 30;

    int currentMinutes = (int.parse(startStr.split(":")[0]) * 60) + int.parse(startStr.split(":")[1]);
    int endTotalMinutes = (int.parse(endStr.split(":")[0]) * 60) + int.parse(endStr.split(":")[1]);

    // --- CRITICAL: Calculate "Now" in minutes only if date is Today ---
    int nowInMinutes = -1;
    if (_isToday(dateForValidation)) {
      final now = DateTime.now();
      nowInMinutes = (now.hour * 60) + now.minute;
    }

    while (currentMinutes + durationMinutes <= endTotalMinutes) {
      
      // --- FILTER: Skip this slot if it has already passed today ---
      // If today is active AND current slot start time is <= right now
      if (nowInMinutes != -1 && currentMinutes <= nowInMinutes) {
        currentMinutes += durationMinutes;
        continue; // Skip adding this slot to the list
      }

      final int hour = currentMinutes ~/ 60;
      final int minute = currentMinutes % 60;
      
      // Format Time String (e.g., 09:30 AM)
      final String period = hour >= 12 ? "PM" : "AM";
      int displayHour = hour > 12 ? hour - 12 : hour;
      if (displayHour == 0) displayHour = 12;
      
      final String timeString = "$displayHour:${minute.toString().padLeft(2, '0')} $period";

      if (hour < 12) {
        _currentMorningSlots.add(timeString);
      } else {
        _currentAfternoonSlots.add(timeString);
      }
      currentMinutes += durationMinutes;
    }
  }

  // --- LOGIC: FETCH BOOKED SLOTS ---
  void _fetchBookedSlots() {
    setState(() {
      _isLoadingSlots = true;
      _bookedSlotsForSelectedDate.clear();
      _selectedTimeIndex = -1; // Reset selection on date change
    });

    final dateStr = _formatDate(_dates[_selectedDateIndex]);
    final doctorKey = widget.doctor['key'] ?? widget.doctor['userKey'];

    if (doctorKey == null) {
      if (mounted) setState(() => _isLoadingSlots = false);
      return;
    }

    _dbRef.child("healthcare/booked_slots/$doctorKey/$dateStr").onValue.listen((event) {
      final List<String> booked = [];
      if (event.snapshot.exists && event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((time, _) => booked.add(time.toString()));
      }
      if (mounted) {
        setState(() {
          _bookedSlotsForSelectedDate = booked;
          _isLoadingSlots = false;
        });
      }
    });
  }

  // --- LOGIC: PROCESS BOOKING ---
  Future<void> _processBooking() async {
    setState(() => _isProcessing = true);

    try {
      final selectedDateObj = _dates[_selectedDateIndex];
      final formattedDate = _formatDate(selectedDateObj);
      
      // 1. Identify Selected Time String
      String selectedTimeStr = "";
      if (_selectedTimeIndex < _currentMorningSlots.length) {
        selectedTimeStr = _currentMorningSlots[_selectedTimeIndex];
      } else {
        selectedTimeStr = _currentAfternoonSlots[_selectedTimeIndex - _currentMorningSlots.length];
      }

      // 2. SAFETY CHECK: Check time again (in case user stayed on screen too long)
      if (_isToday(selectedDateObj)) {
        if (_hasTimePassed(selectedTimeStr)) {
          throw "This time slot has passed. Please select a future time.";
        }
      }

      // 3. SAFETY CHECK: Check availability
      if (_bookedSlotsForSelectedDate.contains(selectedTimeStr)) {
        throw "Slot already taken.";
      }

      final doctorKey = widget.doctor['key'] ?? widget.doctor['userKey'];

      // 4. Fetch Patient Data
      final patientSnapshot = await _dbRef.child("healthcare/users/patients/${widget.patientKey}").get();
      String selectedProfileKey = "";
      String patientName = "Patient";

      if (patientSnapshot.exists) {
        final pData = patientSnapshot.value as Map<dynamic, dynamic>;
        selectedProfileKey = pData['selectedProfileKey']?.toString() ?? "";
        patientName = "${pData['firstName']} ${pData['lastName']}";
      }

      final newBookingRef = _dbRef.child("healthcare/all_appointments").push();
      
      final appointmentData = {
        "appointmentId": newBookingRef.key,
        "doctorId": doctorKey,
        "patientId": widget.patientKey,
        "selectedProfileKey": selectedProfileKey,
        "doctorName": widget.doctor['name'] ?? "Dr. ${widget.doctor['firstName']} ${widget.doctor['lastName']}",
        "patientName": patientName,
        "specialty": widget.doctor['specialty'] ?? widget.doctor['displaySpecialty'] ?? "General",
        "fee": widget.doctor['price'] ?? widget.doctor['consultationFee'] ?? "0",
        "date": formattedDate,
        "time": selectedTimeStr,
        "type": "online",
        "status": "upcoming",
        "timestamp": ServerValue.timestamp,
      };

      await newBookingRef.set(appointmentData);
      await _dbRef.child("healthcare/booked_slots/$doctorKey/$formattedDate/$selectedTimeStr").set(true);

      if (mounted) {
        // Show Success Dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => SuccessBookingDialog(
            onOkPressed: () {
              Navigator.of(context).pop(); // Close Dialog
              Navigator.of(context).pop(); // Close BottomSheet
            },
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  // --- HELPER: Validate Time String ---
  bool _hasTimePassed(String timeStr) {
    try {
      final parts = timeStr.split(" "); 
      final timeParts = parts[0].split(":");
      final period = parts[1];

      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      if (period == "PM" && hour != 12) hour += 12;
      if (period == "AM" && hour == 12) hour = 0;

      final now = DateTime.now();
      final slotTimeInMinutes = (hour * 60) + minute;
      final nowInMinutes = (now.hour * 60) + now.minute;

      return slotTimeInMinutes <= nowInMinutes;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = widget.doctor['price'] ?? widget.doctor['consultationFee'] ?? "0";

    return Container(
      padding: const EdgeInsets.all(20),
      height: 700,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header
          DoctorHeader(doctor: widget.doctor),
          
          const Divider(height: 30),

          // 2. Date Selector
          const Text("Select Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          DateSelector(
            dates: _dates,
            selectedIndex: _selectedDateIndex,
            onDateSelected: (index) {
              setState(() => _selectedDateIndex = index);
              _generateSlotsForSelectedDate();
              _fetchBookedSlots();
            },
          ),
          
          const SizedBox(height: 20),

          // 3. Time Slots
          Expanded(
            child: TimeSlotGrid(
              isLoading: _isLoadingSlots,
              isDayActive: _isDayActive,
              dayName: _getFullDayName(_dates[_selectedDateIndex].weekday),
              morningSlots: _currentMorningSlots,
              afternoonSlots: _currentAfternoonSlots,
              bookedSlots: _bookedSlotsForSelectedDate,
              selectedTimeIndex: _selectedTimeIndex,
              onSlotSelected: (index) => setState(() => _selectedTimeIndex = index),
            ),
          ),

          // 4. Pay & Book Button
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: (_selectedTimeIndex == -1 || _isProcessing) ? null : _processBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child: _isProcessing 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text("Pay ₹$price & Book", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}