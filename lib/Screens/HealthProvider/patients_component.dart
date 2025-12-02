import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/HealthProvider/patientscomponents/patient_appointment_list.dart';

// Assuming these exist in your project structure
import '../../widgets/custom_tab.dart'; 
import '../../widgets/custom_header.dart'; 

class PatientsComponent extends StatefulWidget {
  const PatientsComponent({super.key});

  @override
  State<PatientsComponent> createState() => _PatientsComponentState();
}

class _PatientsComponentState extends State<PatientsComponent> {
  int selectedTab = 0;

  final List<String> tabTitles = ["All Patients", "Recent Visits", "Upcoming"];
  
  // Dynamic counts based on our data
  List<int> get tabCounts => [
    _allAppointments.length,
    _recentAppointments.length,
    _upcomingAppointments.length,
  ];

  // ---------------------------------------------------------------------------
  // ⭐ MOCK DATA: In a real app, this comes from an API
  // ---------------------------------------------------------------------------
  final List<AppointmentModel> _allAppointments = [
    AppointmentModel(
      name: "Sarah Jenkins",
      image: "assets/images/p1.jpg", // Replace with actual path or network image
      history: "Chronic Migraine Diagnosis",
      time: "Today, 10:30 AM",
      gender: "Female",
      age: 28,
      status: "Scheduled",
    ),
    AppointmentModel(
      name: "Michael Ross",
      image: "assets/images/p2.jpg",
      history: "Post-surgery checkup (ACL)",
      time: "Today, 02:15 PM",
      gender: "Male",
      age: 45,
      status: "Waiting",
    ),
    AppointmentModel(
      name: "Emily Clark",
      image: "assets/images/p3.jpg",
      history: "General Consultation - Flu",
      time: "Yesterday, 09:00 AM",
      gender: "Female",
      age: 32,
      status: "Completed",
    ),
  ];

  late final List<AppointmentModel> _recentAppointments;
  late final List<AppointmentModel> _upcomingAppointments;

  @override
  void initState() {
    super.initState();
    // Filtering mock data for the tabs
    _recentAppointments = _allAppointments.where((e) => e.time.contains("Yesterday")).toList();
    _upcomingAppointments = _allAppointments.where((e) => e.time.contains("Today") || e.time.contains("Tomorrow")).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 40), // Bottom padding for scroll
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -------------------------------------------------------------
          // ⭐ CUSTOM PAGE HEADER
          // -------------------------------------------------------------
          const PageHeader(
            title: "Patient Management",
            subtitle: "Manage your patients and view their information",
          ),

          // -------------------------------------------------------------
          // Search Bar
          // -------------------------------------------------------------
          TextField(
            decoration: InputDecoration(
              hintText: "Search patients...",
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue, width: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // -------------------------------------------------------------
          // Tabs
          // -------------------------------------------------------------
          Align(
            alignment: Alignment.centerLeft,
            child: TabToggle(
              options: tabTitles,
              counts: tabCounts,
              selectedIndex: selectedTab,
              onSelected: (index) {
                setState(() => selectedTab = index);
              },
            ),
          ),

          const SizedBox(height: 20),

          // -------------------------------------------------------------
          // Unified Content Area
          // -------------------------------------------------------------
          _buildCurrentTabList(),
        ],
      ),
    );
  }

  Widget _buildCurrentTabList() {
    // We reuse the SAME component, just pass different data
    switch (selectedTab) {
      case 0:
        return PatientAppointmentList(appointments: _allAppointments);
      case 1:
        return PatientAppointmentList(appointments: _recentAppointments);
      case 2:
        return PatientAppointmentList(appointments: _upcomingAppointments);
      default:
        return PatientAppointmentList(appointments: _allAppointments);
    }
  }
}
