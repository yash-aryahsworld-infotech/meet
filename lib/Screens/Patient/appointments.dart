import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthcare_plus/Screens/Patient/appointment/appointment_card.dart';
import 'package:healthcare_plus/widgets/custom_header.dart';
import 'package:healthcare_plus/widgets/custom_tab.dart';

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
      final upcoming = <Map<String, dynamic>>[];
      final past = <Map<String, dynamic>>[];
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      for (var entry in appointmentsData.entries) {
        final appointmentData = entry.value as Map<dynamic, dynamic>;
        final patientId = appointmentData['patientId']?.toString() ?? "";
        
        if (patientId != _patientId) continue;
        
        // Get status
        final status = appointmentData['status']?.toString() ?? "";

        // Get doctor details
        final doctorId = appointmentData['doctorId']?.toString() ?? "";
        String doctorName = appointmentData['doctorName']?.toString() ?? "Unknown Doctor";
        String specialty = appointmentData['specialty']?.toString() ?? "Specialist";
        
        // Parse appointment date
        final dateStr = appointmentData['date']?.toString() ?? "";
        DateTime? appointmentDate;
        
        if (dateStr.isNotEmpty) {
          try {
            appointmentDate = DateTime.parse(dateStr);
          } catch (e) {
            // Try timestamp if date parsing fails
            if (appointmentData['timestamp'] != null) {
              final timestamp = appointmentData['timestamp'];
              appointmentDate = DateTime.fromMillisecondsSinceEpoch(
                timestamp is int ? timestamp : int.parse(timestamp.toString())
              );
            }
          }
        }

        if (appointmentDate == null) continue;

        final appointmentDay = DateTime(
          appointmentDate.year,
          appointmentDate.month,
          appointmentDate.day,
        );

        final isCancelled = status == 'cancelled';
        final isUpcoming = !isCancelled && (appointmentDay.isAtSameMomentAs(today) || appointmentDay.isAfter(today));

        final appointment = {
          "appointmentId": appointmentData['appointmentId']?.toString() ?? entry.key,
          "name": doctorName,
          "specialty": specialty,
          "image": "",
          "type": appointmentData['type']?.toString().capitalize() ?? "Clinic",
          "date": _formatDate(appointmentDate),
          "time": appointmentData['time']?.toString() ?? "",
          "isUpcoming": isUpcoming,
          "patientId": _patientId,
          "patientName": appointmentData['patientName']?.toString() ?? "",
          "doctorId": doctorId,
          "status": status,
          "cancellationReason": appointmentData['cancellationReason']?.toString() ?? "",
          "cancelledBy": appointmentData['cancelledBy']?.toString() ?? "",
          "cancelledAt": appointmentData['cancelledAt']?.toString() ?? "",
        };

        // Cancelled appointments always go to past
        if (isCancelled) {
          past.add(appointment);
        } else if (isUpcoming) {
          upcoming.add(appointment);
        } else {
          past.add(appointment);
        }
      }

      // Sort by date
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
    // Simple comparison, can be enhanced
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
        // ⭐ Use the new Widget
        return AppointmentList(
          appointments: _upcomingAppointments,
          emptyMsg: "No upcoming appointments.",
        );
      case 1:
        // ⭐ Reuse the new Widget
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
      child: const Center(child: Text("Calendar Widget Placeholder")),
    );
  }
}



extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}