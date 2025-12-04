import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_plus/widgets/custom_header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './appointment/appointment_card.dart';
import '../../widgets/custom_tab.dart';

class Appointments extends StatefulWidget {
  const Appointments({super.key});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  String? _currentUserKey;
  int _selectedTab = 0;

  final List<String> _tabs = [
    "Upcoming",
    "Past",
    "Calendar View",
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _currentUserKey = prefs.getString("userKey");
      });
    }
  }

  // --- Backend: Date Helper ---
  DateTime _parseDate(String dateStr) {
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      return DateTime.now();
    }
  }

  // --- Backend: Cancel Appointment (UPDATED for Flat Structure) ---
  Future<void> _handleCancel(Map<String, dynamic> appointment) async {
    if (_currentUserKey == null) return;

    // Extract necessary IDs
    final String bookingId = appointment['id']; // This is the ID in all_appointments
    final String doctorId = appointment['doctorId'] ?? ""; 
    final String date = appointment['date'];
    final String time = appointment['time'];

    try {
      // 1. Remove from Master List (all_appointments)
      await _dbRef.child("healthcare/all_appointments/$bookingId").remove();

      // 2. Free up the slot in the Availability Checker
      if (doctorId.isNotEmpty && date.isNotEmpty && time.isNotEmpty) {
        await _dbRef.child("healthcare/booked_slots/$doctorId/$date/$time").remove();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Appointment cancelled"), backgroundColor: Colors.redAccent),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  // --- UI: Confirmation Dialog ---
  void _showCancelDialog(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Cancel Appointment?"),
        content: const Text("This slot will be freed up for other patients."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Keep")),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _handleCancel(appointment);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Confirm Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double pageMaxWidth = 1200;

    if (_currentUserKey == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Material(
      color: Colors.grey.shade50,
      child: StreamBuilder(
        // UPDATED QUERY: Fetch all_appointments where patientId matches current user
        stream: _dbRef
            .child("healthcare/all_appointments")
            .orderByChild("patientId")
            .equalTo(_currentUserKey)
            .onValue,
        builder: (context, snapshot) {
          // --- 1. Loading ---
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // --- 2. Data Parsing ---
          List<Map<String, dynamic>> upcomingList = [];
          List<Map<String, dynamic>> pastList = [];

          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            final dataMap = Map<dynamic, dynamic>.from(snapshot.data!.snapshot.value as Map);
            
            dataMap.forEach((key, value) {
              final raw = Map<String, dynamic>.from(value);
              
              // Normalize Data Keys for the UI
              final booking = {
                "id": key, // The appointmentId
                "doctorId": raw['doctorId'],
                "name": raw['doctorName'] ?? "Doctor",
                "specialty": raw['specialty'] ?? "Specialist",
                "image": null, 
                "type": raw['type'] ?? "Consultation",
                "date": raw['date'], // Using new flat key 'date'
                "time": raw['time'], // Using new flat key 'time'
                "isUpcoming": false, 
              };

              // Safely parse date
              final DateTime apptDate = _parseDate(booking['date']);
              final DateTime now = DateTime.now().subtract(const Duration(days: 1)); // Include today

              if (apptDate.isAfter(now)) {
                booking['isUpcoming'] = true;
                upcomingList.add(booking);
              } else {
                booking['isUpcoming'] = false;
                pastList.add(booking);
              }
            });

            // Sort
            upcomingList.sort((a, b) => a['date'].compareTo(b['date']));
            pastList.sort((a, b) => b['date'].compareTo(a['date']));
          }

          // --- 3. Build UI ---
          return SingleChildScrollView(
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
                      button1OnPressed: () {
                        // Navigate to booking page or show sheet
                      },
                      padding: const EdgeInsets.only(bottom: 20, top: 20, left: 16, right: 16),
                    ),

                    const SizedBox(height: 10),

                    // ---------------- TABS ----------------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TabToggle(
                        options: _tabs,
                        counts: [
                          upcomingList.length,
                          pastList.length,
                          0
                        ],
                        selectedIndex: _selectedTab,
                        onSelected: (i) => setState(() => _selectedTab = i),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ---------------- TAB CONTENT ----------------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildTabContent(upcomingList, pastList),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabContent(List<Map<String, dynamic>> upcoming, List<Map<String, dynamic>> past) {
    switch (_selectedTab) {
      case 0:
        return AppointmentList(
          appointments: upcoming,
          emptyMsg: "No upcoming appointments.",
          onCancel: _showCancelDialog, 
        );
      case 1:
        return AppointmentList(
          appointments: past,
          emptyMsg: "No past appointments.",
          // No cancel for past items
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
      height: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_month, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 10),
            Text("Calendar View", style: TextStyle(color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// REUSABLE WIDGETS
// ---------------------------------------------------------

class AppointmentList extends StatelessWidget {
  final List<Map<String, dynamic>> appointments;
  final String emptyMsg;
  final Function(Map<String, dynamic>)? onCancel; 

  const AppointmentList({
    super.key,
    required this.appointments,
    required this.emptyMsg,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Column(
            children: [
              Icon(Icons.event_busy, size: 48, color: Colors.grey.shade300),
              const SizedBox(height: 16),
              Text(emptyMsg, style: TextStyle(fontSize: 16, color: Colors.grey.shade500)),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return AppointmentCard(
          appointment: appointments[index],
          onCancel: onCancel != null ? () => onCancel!(appointments[index]) : null,
        );
      },
    );
  }
}