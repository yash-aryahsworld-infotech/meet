import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthcare_plus/Screens/Patient/appointment/appointment_card.dart'; // Ensure this points to your file
import 'package:healthcare_plus/widgets/custom_header.dart'; // Ensure this points to your file
import 'package:healthcare_plus/widgets/custom_tab.dart'; // Ensure this points to your file

class Appointments extends StatefulWidget {
  const Appointments({super.key});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  int _selectedTab = 0;
  bool _isLoading = true;
  String? _patientId;

  final List<String> _tabs = [
    "Upcoming",
    "Past",
    "Calendar View",
  ];

  List<Map<String, dynamic>> _upcomingAppointments = [];
  List<Map<String, dynamic>> _pastAppointments = [];
  
  DatabaseReference? _appointmentsRef;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  @override
  void dispose() {
    _appointmentsRef?.onValue.drain();
    super.dispose();
  }

  Future<void> _loadAppointments() async {
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    _patientId = prefs.getString("userKey");

    if (_patientId == null || _patientId!.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    _setupRealtimeListener();
  }

  void _setupRealtimeListener() {
    _appointmentsRef = FirebaseDatabase.instance.ref("healthcare/all_appointments");
    
    _appointmentsRef!.onValue.listen((event) {
      if (!mounted) return;
      
      if (!event.snapshot.exists) {
        setState(() {
          _upcomingAppointments = [];
          _pastAppointments = [];
          _isLoading = false;
        });
        return;
      }

      _processAppointments(event.snapshot);
    });
  }

  Future<void> _processAppointments(DataSnapshot snapshot) async {
    try {
      final appointmentsData = snapshot.value as Map<dynamic, dynamic>;
      final tempAppointments = <Map<String, dynamic>>[];
      
      // 1. Collect appointments for this patient
      for (var entry in appointmentsData.entries) {
        final appointmentData = entry.value as Map<dynamic, dynamic>;
        final patientId = appointmentData['patientId']?.toString() ?? "";
        
        if (patientId == _patientId) {
          tempAppointments.add({
            ...Map<String, dynamic>.from(appointmentData),
            'appointmentId': entry.key.toString(),
          });
        }
      }

      // 2. Extract Unique Doctor IDs (FIXED LINE)
      final uniqueDoctorIds = tempAppointments
          .map((a) => a['doctorId']?.toString())
          .where((id) => id != null && id.isNotEmpty)
          .cast<String>() // <--- THIS FIXES THE ERROR
          .toSet();

      // 3. Fetch Doctor Data (Name, Image, Specialty)
      final Map<String, Map<String, String>> doctorsCache = {};
      
      for (String docId in uniqueDoctorIds) {
        final docSnapshot = await FirebaseDatabase.instance
            .ref("healthcare/users/providers/$docId")
            .get();

        if (docSnapshot.exists) {
          final docData = docSnapshot.value as Map<dynamic, dynamic>;
          final firstName = docData['firstName']?.toString() ?? "";
          final lastName = docData['lastName']?.toString() ?? "";
          
          doctorsCache[docId] = {
            "name": "Dr. $firstName $lastName".trim(),
            "image": docData['image']?.toString() ?? "",
            "specialty": docData['specialty']?.toString() ?? "Specialist",
          };
        }
      }

      // 4. Process and categorize appointments
      final upcoming = <Map<String, dynamic>>[];
      final past = <Map<String, dynamic>>[];
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      for (var appt in tempAppointments) {
        final doctorId = appt['doctorId']?.toString() ?? "";
        
        // Fill in Doctor Details from Cache
        if (doctorsCache.containsKey(doctorId)) {
          appt['doctorName'] = doctorsCache[doctorId]!['name'];
          appt['specialty'] = doctorsCache[doctorId]!['specialty'];
          appt['image'] = doctorsCache[doctorId]!['image'];
        } else {
          appt['doctorName'] = "Unknown Doctor";
        }

        // Format Date & Status Logic
        final dateStr = appt['date']?.toString() ?? "";
        DateTime? appointmentDate;
        
        if (dateStr.isNotEmpty) {
           try {
             appointmentDate = DateTime.parse(dateStr);
           } catch (e) {
             // Fallback for timestamp if needed
           }
        }

        if (appointmentDate == null) continue;

        // Strip time for date comparison
        final appointmentDay = DateTime(appointmentDate.year, appointmentDate.month, appointmentDate.day);
        
        final status = appt['status']?.toString() ?? "";
        final isCancelled = status == 'cancelled';
        final isUpcoming = !isCancelled && (appointmentDay.isAtSameMomentAs(today) || appointmentDay.isAfter(today));

        // Format the object for UI
        final finalAppointment = {
          "appointmentId": appt['appointmentId'],
          "name": appt['doctorName'],
          "specialty": appt['specialty'],
          "image": appt['image'],
          "type": appt['type']?.toString().capitalize() ?? "Clinic",
          "date": _formatDate(appointmentDate),
          "time": appt['time']?.toString() ?? "",
          "duration": appt['duration'] ?? 30,
          "isUpcoming": isUpcoming,
          "patientId": _patientId,
          "doctorId": doctorId,
          "status": status,
          "cancellationReason": appt['cancellationReason'],
          "cancelledBy": appt['cancelledBy'],
        };

        if (isCancelled) {
          past.add(finalAppointment);
        } else if (isUpcoming) {
          upcoming.add(finalAppointment);
        } else {
          past.add(finalAppointment);
        }
      }

      // Sort
      upcoming.sort((a, b) => _compareDates(a["date"], b["date"])); 
      past.sort((a, b) => _compareDates(b["date"], a["date"]));

      if (mounted) {
        setState(() {
          _upcomingAppointments = upcoming;
          _pastAppointments = past;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      debugPrint("Error processing appointments: $e");
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final appointmentDay = DateTime(date.year, date.month, date.day);

    if (appointmentDay == today) {
      return "Today";
    } else if (appointmentDay == tomorrow) {
      return "Tomorrow";
    } else if (appointmentDay == today.subtract(const Duration(days: 1))) {
      return "Yesterday";
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return "${months[date.month - 1]} ${date.day}, ${date.year}";
    }
  }

  int _compareDates(String date1, String date2) {
    return date1.compareTo(date2);
  }

  @override
  Widget build(BuildContext context) {
    const double pageMaxWidth = 1200;

    if (_isLoading) {
      return Material(
        color: Colors.grey.shade50,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Material(
      color: Colors.grey.shade50,
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: pageMaxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------- HEADER ----------------
                PageHeader(
                  title: "My Appointments",
                  subtitle: "Manage your healthcare appointments",
                  button1Icon: Icons.add,
                  button1Text: "Book Appointment",
                  button1OnPressed: () {},
                  padding: const EdgeInsets.only(bottom: 20),
                ),

                const SizedBox(height: 10),

                // ---------------- TABS ----------------
                TabToggle(
                  options: _tabs,
                  counts: [
                    _upcomingAppointments.length,
                    _pastAppointments.length,
                    0
                  ],
                  selectedIndex: _selectedTab,
                  onSelected: (i) => setState(() => _selectedTab = i),
                ),

                const SizedBox(height: 30),

                // ---------------- TAB CONTENT ----------------
                _buildTabContent(),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return AppointmentList(
          appointments: _upcomingAppointments,
          emptyMsg: "No upcoming appointments.",
        );
      case 1:
        return AppointmentList(
          appointments: _pastAppointments,
          emptyMsg: "No past appointments.",
        );
      case 2:
        return _buildCalendarView();
      default:
        return const SizedBox();
    }
  }

  Widget _buildCalendarView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Center(child: Text("Calendar View Coming Soon")),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}