import 'package:flutter/material.dart';
import '../../widgets/custom_tab.dart'; // TabToggle
import 'consultationscomponents/active_consultations_tab.dart';
import 'consultationscomponents/completed_consultations_tab.dart';
import 'consultationscomponents/all_consultations_tab.dart';
import '../../widgets/custom_header.dart';

class ConsultationsComponent extends StatefulWidget {
  const ConsultationsComponent({super.key});

  @override
  State<ConsultationsComponent> createState() => _ConsultationsComponentState();
}

class _ConsultationsComponentState extends State<ConsultationsComponent> {
  int selectedTab = 0;

  final List<String> tabTitles = [
    "Active Consultations",
    "Completed Consultations",
    "All Consultations",
  ];

  final List<int> tabCounts = [0, 0, 0];

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
            title: "Consultation Management",
            subtitle: "Manage patient consultations and medical notes",
          ),
          

          // -------------------------------------------------------------
          // Search Bar (Corrected)
          // -------------------------------------------------------------
          TextField(
            decoration: InputDecoration(
              hintText: "Search consultations...",
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              // contentPadding controls the height effectively
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
        return const ActiveConsultationsTab();
      case 1:
        return const CompletedConsultationsTab();
      case 2:
        return const AllConsultationsTab();
      default:
        return const ActiveConsultationsTab();
    }
  }
}