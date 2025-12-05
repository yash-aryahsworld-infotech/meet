import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = -1;
  
  // Profile selection
  String? _selectedProfileKey;
  String? _selectedProfileName;
  List<Map<String, dynamic>> _profiles = [];
  bool _loadingProfiles = true;

  // Generate next 7 days dynamically
  final List<DateTime> _dates = List.generate(
    7, 
    (index) => DateTime.now().add(Duration(days: index))
  );

  // Mock Time Slots
  final List<String> _morningSlots = ["09:00 AM", "09:30 AM", "10:00 AM", "11:15 AM"];
  final List<String> _afternoonSlots = ["02:00 PM", "03:45 PM", "04:30 PM", "06:00 PM"];

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userKey = prefs.getString("userKey");
      
      if (userKey == null) {
        setState(() => _loadingProfiles = false);
        return;
      }

      final snapshot = await FirebaseDatabase.instance
          .ref("healthcare/users/patients/$userKey")
          .get();

      if (!snapshot.exists) {
        setState(() => _loadingProfiles = false);
        return;
      }

      final userData = Map<String, dynamic>.from(snapshot.value as Map);
      final profiles = <Map<String, dynamic>>[];

      // Add main user profile
      profiles.add({
        'key': userKey,
        'name': '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'.trim(),
        'relation': 'Self',
        'isMain': true,
      });

      // Add family members
      if (userData['family'] != null) {
        final familyMap = Map<String, dynamic>.from(userData['family'] as Map);
        familyMap.forEach((key, value) {
          final member = Map<String, dynamic>.from(value as Map);
          profiles.add({
            'key': key,
            'name': member['name'] ?? 'Unknown',
            'relation': member['relation'] ?? 'Family',
            'isMain': false,
          });
        });
      }

      // Set default selection to main user
      setState(() {
        _profiles = profiles;
        if (profiles.isNotEmpty) {
          _selectedProfileKey = profiles[0]['key'];
          _selectedProfileName = profiles[0]['name'];
        }
        _loadingProfiles = false;
      });
    } catch (e) {
      setState(() => _loadingProfiles = false);
    }
  }

  Future<void> _bookAppointment() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final patientId = prefs.getString("userKey");
      
      if (patientId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please login first"), backgroundColor: Colors.red),
          );
        }
        return;
      }

      // Fetch patient data from Firebase
      final patientSnapshot = await FirebaseDatabase.instance
          .ref('healthcare/users/patients/$patientId')
          .get();
      
      String patientName = "Unknown Patient";
      String bookedByName = "Unknown";
      String? bookingForName;
      String? bookingForRelation;
      
      if (patientSnapshot.exists) {
        final patientData = Map<String, dynamic>.from(patientSnapshot.value as Map);
        final firstName = patientData['firstName']?.toString() ?? '';
        final lastName = patientData['lastName']?.toString() ?? '';
        bookedByName = '$firstName $lastName'.trim();
        if (bookedByName.isEmpty) {
          bookedByName = patientData['name']?.toString() ?? "Unknown";
        }
        
        // Check if booking for family member or self
        if (_selectedProfileKey == patientId) {
          // Booking for self - show main user name
          patientName = bookedByName;
        } else {
          // Booking for family member - show "Booked by X for Y (Relation)"
          if (patientData['family'] != null) {
            final familyMap = Map<String, dynamic>.from(patientData['family'] as Map);
            if (familyMap.containsKey(_selectedProfileKey)) {
              final memberData = Map<String, dynamic>.from(familyMap[_selectedProfileKey] as Map);
              bookingForName = memberData['name']?.toString() ?? '';
              bookingForRelation = memberData['relation']?.toString() ?? '';
              
              // Format: "Booked by Sahil Test for SA (Sibling)"
              if (bookingForName.isNotEmpty && bookingForRelation.isNotEmpty) {
                patientName = 'Booked by $bookedByName for $bookingForName ($bookingForRelation)';
              } else if (bookingForName.isNotEmpty) {
                patientName = 'Booked by $bookedByName for $bookingForName';
              } else {
                patientName = '$bookedByName (Family Member)';
              }
            }
          }
        }
      }

      // Get selected time
      String selectedTime = "";
      if (_selectedTimeIndex < _morningSlots.length) {
        selectedTime = _morningSlots[_selectedTimeIndex];
      } else {
        selectedTime = _afternoonSlots[_selectedTimeIndex - _morningSlots.length];
      }

      // Get selected date
      final selectedDate = _dates[_selectedDateIndex];

      // Create appointment data
      final appointmentRef = FirebaseDatabase.instance.ref('healthcare/all_appointments').push();
      final appointmentId = appointmentRef.key!;

      final appointmentData = {
        'appointmentId': appointmentId,
        'patientId': patientId,
        'patientName': patientName,
        'bookedBy': bookedByName, // Main user who booked
        'bookingForName': bookingForName, // Family member name (if applicable)
        'bookingForRelation': bookingForRelation, // Family member relation (if applicable)
        'doctorId': widget.doctor['userKey'] ?? widget.doctor['id'] ?? '',
        'doctorName': widget.doctor['name'] ?? 'Unknown Doctor',
        'specialty': widget.doctor['specialty'] ?? 'Specialist',
        'type': widget.doctor['type'] ?? 'Clinic',
        'date': selectedDate.toIso8601String(),
        'time': selectedTime,
        'selectedProfileKey': _selectedProfileKey,
        'status': 'scheduled',
        'reason': 'General Consultation',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'createdAt': DateTime.now().toIso8601String(),
      };

      await appointmentRef.set(appointmentData);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Booking Successful for $_selectedProfileName!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Booking failed: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Helper for Date Name (Mon, Tue)
  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
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
          // Header
          Row(
            children: [
               CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.doctor['image']),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Booking: ${widget.doctor['name']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(widget.doctor['specialty'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),

          // 0. PROFILE SELECTOR
          const Text("Booking For", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          _loadingProfiles
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedProfileKey,
                      hint: const Text("Select Profile"),
                      icon: const Icon(Icons.arrow_drop_down),
                      items: _profiles.map((profile) {
                        return DropdownMenuItem<String>(
                          value: profile['key'],
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: profile['isMain'] ? Colors.blue.shade100 : Colors.orange.shade100,
                                child: Text(
                                  profile['name'][0].toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: profile['isMain'] ? Colors.blue.shade900 : Colors.orange.shade900,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      profile['name'],
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                    ),
                                    Text(
                                      profile['relation'],
                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedProfileKey = value;
                          _selectedProfileName = _profiles.firstWhere((p) => p['key'] == value)['name'];
                        });
                      },
                    ),
                  ),
                ),
          const SizedBox(height: 20),

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
              onPressed: (_selectedTimeIndex == -1 || _selectedProfileKey == null) 
                ? null 
                : () => _bookAppointment(),
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