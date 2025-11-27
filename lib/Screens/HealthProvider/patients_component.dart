import 'package:flutter/material.dart';

import './patientscomponents/all_patients_tab.dart';
import './patientscomponents/recent_visits_tab.dart';
import './patientscomponents/upcoming_patients_tab.dart';

import '../../widgets/custom_tab.dart'; // TabToggle
import '../../widgets/custom_header.dart'; // ⭐ IMPORT PAGE HEADER

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
    134,
    18,
    12,
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          // Search Bar (Corrected)
          // -------------------------------------------------------------
          TextField(
            decoration: InputDecoration(
              hintText: "Search patients...",
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              // Controls height and internal spacing
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              
              // Default Border
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              
              // Border when not focused
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              
              // Border when clicked/focused
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue, width: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // -------------------------------------------------------------
          // Tabs (Responsive TabToggle)
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
          // Tab Content
          // -------------------------------------------------------------
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