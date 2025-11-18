import 'package:flutter/material.dart';
import './patientscomponents/all_patients_tab.dart';
import './patientscomponents/recent_visits_tab.dart';
import './patientscomponents/upcoming_patients_tab.dart';
import '../../widgets/custom_tab.dart'; // TabToggle

class PatientsComponent extends StatefulWidget {
  const PatientsComponent({super.key});

  @override
  State<PatientsComponent> createState() => _PatientsComponentState();
}

class _PatientsComponentState extends State<PatientsComponent> {
  int selectedTab = 0;

  final List<String> tabTitles = [
    "All Patients",
    "Recent Visits",
    "Upcoming",
  ];

  final List<int> tabCounts = [
    134, // All Patients
    18,  // Recent Visits
    12,  // Upcoming
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Title ----
          const Text(
            "Patient Management",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Manage your patients and view their information",
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
          const SizedBox(height: 30),

          // ---- Search bar ----
          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search patients...",
                      border: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 30),

          // ---- Decorative Background Container with TabToggle ----
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

          // ---- Tab Content ----
          _buildTabContent(),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTab) {
      case 0:
        return const AllPatientsTab();
      case 1:
        return const RecentVisitsTab();
      case 2:
        return const UpcomingPatientsTab();
      default:
        return const AllPatientsTab();
    }
  }
}
