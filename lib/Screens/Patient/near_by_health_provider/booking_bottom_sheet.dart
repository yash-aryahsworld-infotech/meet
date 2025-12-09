import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './profileselector.dart';
import './date_selector.dart';
import './time_grid.dart';

class BookingBottomSheet extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const BookingBottomSheet({super.key, required this.doctor});

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  // State
  int _selectedDateIndex = 0;
  String? _selectedTime;
  
  // Profile Data
  String? _selectedProfileKey;
  String? _selectedProfileName;
  List<Map<String, dynamic>> _profiles = [];
  bool _loadingProfiles = true;

  // Availability & Booking Data
  bool _loadingAvailability = true;
  Map<String, dynamic> _availability = {}; 
  
  // CHANGED: List of Maps to hold time AND duration
  List<Map<String, dynamic>> _generatedSlots = []; 
  
  Set<String> _bookedSlots = {}; 

  // Dates
  final List<DateTime> _dates = List.generate(
    7, (index) => DateTime.now().add(Duration(days: index))
  );

  @override
  void initState() {
    super.initState();
    _loadProfiles();
    _loadDoctorAvailability();
  }

  // --- 1. DATA LOADING ---

  Future<void> _loadProfiles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userKey = prefs.getString("userKey");
      if (userKey == null) { setState(() => _loadingProfiles = false); return; }

      final snapshot = await FirebaseDatabase.instance.ref("healthcare/users/patients/$userKey").get();
      if (!snapshot.exists) { setState(() => _loadingProfiles = false); return; }

      final userData = Map<String, dynamic>.from(snapshot.value as Map);
      final profiles = <Map<String, dynamic>>[];
      
      profiles.add({
        'key': userKey,
        'name': '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'.trim(),
        'relation': 'Self',
        'isMain': true,
      });

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
    final doctorId = widget.doctor['userKey'] ?? widget.doctor['id'];
    if (doctorId == null) return;

    final snapshot = await FirebaseDatabase.instance
        .ref("healthcare/users/providers/$doctorId/availability")
        .get();

    if (snapshot.exists) {
      setState(() {
        _availability = Map<String, dynamic>.from(snapshot.value as Map);
        _loadingAvailability = false;
      });
      _calculateSlotsForCurrentDate();
    } else {
      setState(() => _loadingAvailability = false);
    }
  }

  // --- 2. SLOT CALCULATION ---

  void _calculateSlotsForCurrentDate() {
    final selectedDate = _dates[_selectedDateIndex];
    final rawSlots = _generateRawSlots(selectedDate);
    _fetchBookedSlots(selectedDate, rawSlots);
  }

  // CHANGED: Accepts List<Map>
  Future<void> _fetchBookedSlots(DateTime date, List<Map<String, dynamic>> rawSlots) async {
    final doctorId = widget.doctor['userKey'] ?? widget.doctor['id'];
    final dateKey = _formatDateKey(date); 

    final snapshot = await FirebaseDatabase.instance
        .ref("healthcare/booked_slots/$doctorId/$dateKey")
        .get();

    Set<String> booked = {};
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      booked = data.keys.toSet();
    }

    setState(() {
      _generatedSlots = rawSlots;
      _bookedSlots = booked;
      _selectedTime = null; 
    });
  }

  // CHANGED: Returns List<Map> with duration
  List<Map<String, dynamic>> _generateRawSlots(DateTime date) {
    final dayName = _getDayName(date);
    final slots = <Map<String, dynamic>>[];
    
    final now = DateTime.now();
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
    final currentMinutes = isToday ? (now.hour * 60 + now.minute) : 0;
    
    if (_availability.containsKey(dayName)) {
      final dayData = _availability[dayName];
      
      if (dayData['active'] == true && dayData['slots'] != null) {
        final ranges = dayData['slots'] as List<dynamic>;

        for (var range in ranges) {
          // Dynamic Duration from Firebase
          int duration = int.tryParse(range['slotDuration'].toString()) ?? 30;
          
          int startMinutes = _timeToMinutes(range['start'] ?? '09:00');
          int endMinutes = _timeToMinutes(range['end'] ?? '17:00');

          while (startMinutes < endMinutes) {
            if (!isToday || startMinutes > currentMinutes) {
               // CHANGED: Add Object instead of just String
               slots.add({
                 'time': _minutesToTime(startMinutes),
                 'duration': duration,
                 'minutes': startMinutes // for sorting
               });
            }
            startMinutes += duration;
          }
        }
      }
    }
    
    // Sort by time
    slots.sort((a, b) => (a['minutes'] as int).compareTo(b['minutes'] as int));
    
    return slots;
  }

  // --- 3. ACTIONS ---

  Future<void> _bookAppointment() async {
    if (_selectedTime == null || _selectedProfileKey == null) return;
    
    try {
      final selectedSlotObj = _generatedSlots.firstWhere(
        (slot) => slot['time'] == _selectedTime,
        orElse: () => {'duration': 30}, // Fallback default
      );
      final int slotDuration = selectedSlotObj['duration'];
      final doctorId = widget.doctor['userKey'] ?? widget.doctor['id'];
      final dateKey = _formatDateKey(_dates[_selectedDateIndex]);
      final prefs = await SharedPreferences.getInstance();
      final patientId = prefs.getString("userKey");
      
      final appointmentRef = FirebaseDatabase.instance.ref('healthcare/all_appointments').push();
      
      final appointmentData = {
        'appointmentId': appointmentRef.key,
        'patientId': patientId,
        'doctorId': doctorId,
        'date': dateKey,
        'time': _selectedTime,
        'duration': slotDuration, 
        'status': 'Online',
        'selectedProfileKey': _selectedProfileKey,
        'timestamp': ServerValue.timestamp,
      };

      final updates = <String, dynamic>{
        'healthcare/all_appointments/${appointmentRef.key}': appointmentData,
        'healthcare/booked_slots/$doctorId/$dateKey/$_selectedTime': slotDuration,
      };

      await FirebaseDatabase.instance.ref().update(updates);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Booking Confirmed!"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
    }
  }

  // --- HELPER UTILS ---

  String _formatDateKey(DateTime date) {
    String y = date.year.toString();
    String m = date.month.toString().padLeft(2, '0');
    String d = date.day.toString().padLeft(2, '0');
    return "$y-$m-$d";
  }

  String _getDayName(DateTime date) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[date.weekday - 1];
  }

  int _timeToMinutes(String time) {
    if (time.contains(" ")) {
       final parts = time.split(' ');
       final hm = parts[0].split(':');
       int h = int.parse(hm[0]);
       int m = int.parse(hm[1]);
       if (parts[1] == "PM" && h != 12) h += 12;
       if (parts[1] == "AM" && h == 12) h = 0;
       return h * 60 + m;
    } else {
       final parts = time.split(':');
       return int.parse(parts[0]) * 60 + int.parse(parts[1]);
    }
  }

  String _minutesToTime(int totalMinutes) {
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    final period = h >= 12 ? 'PM' : 'AM';
    final displayH = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '${displayH.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 650,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const Divider(),
          
          const Text("Booking For", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          _loadingProfiles 
            ? const LinearProgressIndicator()
            : ProfileSelector(
                profiles: _profiles,
                selectedKey: _selectedProfileKey,
                onChanged: (key) {
                  setState(() {
                    _selectedProfileKey = key;
                    _selectedProfileName = _profiles.firstWhere((p) => p['key'] == key)['name'];
                  });
                },
              ),
          const SizedBox(height: 20),

          const Text("Select Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          DateSelector(
            dates: _dates,
            selectedIndex: _selectedDateIndex,
            onDateSelected: (index) {
              setState(() => _selectedDateIndex = index);
              _calculateSlotsForCurrentDate();
            },
          ),
          const SizedBox(height: 20),

          const Text("Select Time Slot", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Expanded(
            child: _loadingAvailability 
              ? const Center(child: CircularProgressIndicator())
              : TimeSlotGrid(
                  slots: _generatedSlots, // Passing List<Map> now
                  bookedSlots: _bookedSlots,
                  selectedTime: _selectedTime,
                  onTimeSelected: (time) => setState(() => _selectedTime = time),
                ),
          ),

          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: (_selectedTime != null && _selectedProfileKey != null) 
                  ? _bookAppointment 
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                "Pay ₹${widget.doctor['price'] ?? '0'}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(widget.doctor['image'] ?? 'https://via.placeholder.com/150'),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Booking: ${widget.doctor['name']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(widget.doctor['specialty'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        const Spacer(),
        IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
      ],
    );
  }
}