import 'package:flutter/material.dart';
import 'package:healthcare_plus/widgets/custom_header.dart';
import 'package:healthcare_plus/widgets/custom_tab.dart';
import '../../utils/app_responsive.dart';
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



  @override
  Widget build(BuildContext context) {
    const double pageMaxWidth = 1200;

    return Material(
      child: SingleChildScrollView(
        padding: AppResponsive.pagePadding(context),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Book Appointment tapped")),
                    );
                  },
                  padding: const EdgeInsets.only(bottom: 20),
                ),

                const SizedBox(height: 10),

                // ---------------- TABS ----------------
                TabToggle(
                  options: _tabs,
                  counts: [0, 0, 0],
                  selectedIndex: _selectedTab,
                  onSelected: (i) => setState(() => _selectedTab = i),
                  height: 40,
                  fontSize: 12,
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

  // ---------------- CONTENT HANDLER ----------------
  Widget _buildTabContent() {
    if (_selectedTab == 0) {
      return Center(
        child: Text(
          "No upcoming appointments.",
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      );
    }

    if (_selectedTab == 1) {
      return Center(
        child: Text(
          "No past appointments.",
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      );
    }

    // ---------------- CALENDAR VIEW ----------------
    return _buildCalendarView();
  }

  // ---------------- CALENDAR VIEW WIDGET ----------------
  Widget _buildCalendarView() {
  return Container(
    width: double.infinity, // <<< FULL WIDTH WHITE CARD
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: [
        BoxShadow(
          color: Colors.black12.withOpacity(0.05),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, // <<< LEFT ALIGN
      children: [
        const Text(
          "Appointment Calendar",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "View your appointments in calendar format",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),

        const SizedBox(height: 20),

        // >>> SMALL CALENDAR BOX
        Container(
          width: 380, // <<< SMALL CALENDAR
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          
        ),
      ],
    ),
  );
}
}