import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingBottomSheet extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const BookingBottomSheet({super.key, required this.doctor});

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
  bool _loadingAvailability = true;

  // Generate next 7 days dynamically
  final List<DateTime> _dates = List.generate(
    7, 
    (index) => DateTime.now().add(Duration(days: index))
  );

  // Real availability data
  Map<String, dynamic> _availability = {};
  List<String> _availableTimeSlots = [];

  @override
  void initState() {
    super.initState();
    _loadProfiles();
    _loadDoctorAvailability();
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

  Future<void> _loadDoctorAvailability() async {
    try {
      final doctorId = widget.doctor['userKey'] ?? widget.doctor['id'];
      if (doctorId == null) {
        setState(() => _loadingAvailability = false);
        return;
      }

      final snapshot = await FirebaseDatabase.instance
          .ref("healthcare/users/providers/$doctorId/availability")
          .get();

      if (snapshot.exists) {
        setState(() {
          _availability = Map<String, dynamic>.from(snapshot.value as Map);
          _loadingAvailability = false;
          _generateTimeSlotsForSelectedDate();
        });
      } else {
        setState(() => _loadingAvailability = false);
      }
    } catch (e) {
      setState(() => _loadingAvailability = false);
    }
  }

  void _generateTimeSlotsForSelectedDate() {
    final selectedDate = _dates[_selectedDateIndex];
    final dayName = _getDayNameFull(selectedDate.weekday);
    
    final slots = <String>[];
    
    if (_availability.containsKey(dayName)) {
      final dayData = _availability[dayName];
      final isActive = dayData['active'] ?? false;
      
      if (isActive && dayData['slots'] != null) {
        final daySlots = dayData['slots'] as List;
        
        for (var slot in daySlots) {
          final startTime = slot['start'] ?? '09:00';
          final endTime = slot['end'] ?? '17:00';
          final slotDuration = (slot['slotDuration'] ?? 30) as int;
          
          // Generate time slots based on duration
          final startParts = startTime.split(':');
          final endParts = endTime.split(':');
          
          int startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
          final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);
          
          while (startMinutes < endMinutes) {
            final hour = startMinutes ~/ 60;
            final minute = startMinutes % 60;
            final timeStr = _formatTime(hour, minute);
            slots.add(timeStr);
            startMinutes += slotDuration;
          }
        }
      }
    }
    
    setState(() {
      _availableTimeSlots = slots;
      _selectedTimeIndex = -1; // Reset selection
    });
  }

  String _getDayNameFull(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday - 1];
  }

  String _formatTime(int hour, int minute) {
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
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
      if (_selectedTimeIndex < 0 || _selectedTimeIndex >= _availableTimeSlots.length) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please select a time slot"), backgroundColor: Colors.red),
          );
        }
        return;
      }
      String selectedTime = _availableTimeSlots[_selectedTimeIndex];

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 600,
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

          // 1. DATE SELECTOR
          const Text("Select Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_dates.length, (index) {
                final date = _dates[index];
                final isSelected = _selectedDateIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDateIndex = index;
                      _selectedTimeIndex = -1; // Reset time
                    });
                    _generateTimeSlotsForSelectedDate();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _getDayName(date.weekday),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${date.day}",
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),

          // 2. TIME SLOT SELECTOR
          const Text("Select Time Slot", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Expanded(
            child: _loadingAvailability
                ? const Center(child: CircularProgressIndicator())
                : _availableTimeSlots.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_busy, size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            Text(
                              "No slots available for this day",
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Please select another date",
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(_availableTimeSlots.length, (index) {
                            return _buildTimeChip(index, _availableTimeSlots[index]);
                          }),
                        ),
                      ),
          ),

          // 3. PAY BUTTON
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
              child: Text(
                "Pay ₹${widget.doctor['price']}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeChip(int index, String time) {
    final isSelected = _selectedTimeIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedTimeIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : Colors.white,
          border: Border.all(color: isSelected ? Colors.green : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isSelected ? Colors.green : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}