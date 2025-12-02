import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/Patient/appointment/appointment_card.dart';
import 'package:healthcare_plus/widgets/custom_header.dart';
import 'package:healthcare_plus/widgets/custom_tab.dart';
// ⭐ Import the new file


class Appointments extends StatefulWidget {
  const Appointments({super.key});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  int _selectedTab = 0;

  final List<String> _tabs = [
    "Upcoming",
    "Past",
    "Calendar View",
  ];

  // ---------------------------------------------------------
  // ⭐ MOCK DATA
  // ---------------------------------------------------------
  final List<Map<String, dynamic>> _upcomingAppointments = [
    {
      "name": "Dr. Sarah Wilson",
      "specialty": "General Physician",
      "image": "images/female_doc.jpg",
      "type": "Online",
      "date": "Tomorrow, Oct 26",
      "time": "10:00 AM",
      "isUpcoming": true,
    },
    {
      "name": "Dr. Raj Patel",
      "specialty": "Cardiologist",
      "image": "images/male_doc.jpg",
      "type": "Clinic",
      "date": "Oct 29, 2023",
      "time": "02:30 PM",
      "isUpcoming": true,
    },
  ];

  final List<Map<String, dynamic>> _pastAppointments = [
    {
      "name": "Dr. Emily Chen",
      "specialty": "Dermatologist",
      "image": "images/female_doc_2.jpg",
      "type": "Clinic",
      "date": "Aug 15, 2023",
      "time": "11:15 AM",
      "isUpcoming": false,
    },
    {
      "name": "Dr. Raj Patel",
      "specialty": "Cardiologist",
      "image": "images/male_doc.jpg",
      "type": "Online",
      "date": "Sep 10, 2023",
      "time": "09:00 AM",
      "isUpcoming": false,
    },
  ];

  // ---------------------------------------------------------
  // ⭐ BUILD METHOD
  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    const double pageMaxWidth = 1200;

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



class AppointmentList extends StatelessWidget {
  final List<Map<String, dynamic>> appointments;
  final String emptyMsg;

  const AppointmentList({
    super.key,
    required this.appointments,
    required this.emptyMsg,
  });

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Text(
            emptyMsg,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return AppointmentCard(appointment: appointments[index]);
      },
    );
  }
}