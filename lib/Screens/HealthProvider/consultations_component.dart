import 'package:flutter/material.dart';
import '../../widgets/custom_tab.dart'; // TabToggle
import 'consultationscomponents/active_consultations_tab.dart';
import 'consultationscomponents/completed_consultations_tab.dart';
import 'consultationscomponents/all_consultations_tab.dart';
import '../../utils/app_responsive.dart';
import '../../widgets/custom_header.dart';   // ⭐ IMPORT PAGE HEADER

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

  final List<int> tabCounts = [
    0,
    0,
    0,
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppResponsive.pagePadding(context),
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
          // Search Bar
          // -------------------------------------------------------------
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
                      hintText: "Search consultations...",
                      border: InputBorder.none,
                    ),
                  ),
                )
              ],
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
