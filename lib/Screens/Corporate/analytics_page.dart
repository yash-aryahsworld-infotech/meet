import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/Corporate/analytics/department_tab.dart';
import 'package:healthcare_plus/Screens/Corporate/analytics/finance_tab.dart';
import 'package:healthcare_plus/Screens/Corporate/analytics/overview_tab.dart';
import 'package:healthcare_plus/Screens/Corporate/analytics/programs_tab.dart';

import 'package:healthcare_plus/widgets/custom_support_tab_toggle.dart';

import '../HealthProvider/stats_section.dart';

class CorporateAnalyticsPage extends StatefulWidget {
  const CorporateAnalyticsPage({super.key});

  @override
  State<CorporateAnalyticsPage> createState() => _CorporateAnalyticsPageState();
}

class _CorporateAnalyticsPageState extends State<CorporateAnalyticsPage> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = [
    "Overview",
    "Programs",
    "Departments",
    "Financial",
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      // Light grey background
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER
            LayoutBuilder(
              builder: (context, constraints) {
                final bool isMobile = constraints.maxWidth < 600;
                final titleWidget = const Text(
                  "Corporate Analytics",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B2138),
                  ),
                );

                final badgeWidget = Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Text(
                    "Last Updated: 28/11/2025",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                );

                if (isMobile) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      titleWidget,
                      const SizedBox(height: 12),
                      badgeWidget,
                    ],
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [titleWidget, badgeWidget],
                  );
                }
              },
            ),

            const SizedBox(height: 24),

            // 2. STATS CARDS (Your Provided Code)
            const StatsSection(),

            const SizedBox(height: 24),

            // 3. TABS (Your Provided Code)
            SupportTabsToggle(
              tabs: _tabs,
              selectedIndex: _selectedTabIndex,
              onSelected: (index) => setState(() => _selectedTabIndex = index),
            ),

            const SizedBox(height: 24),

            // // 4. CHARTS SECTION (Health Trends & Risk Distribution)
            // const _ChartsSection(),
            _buildTabContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return const OverviewTab();
      case 1:
        return const ProgramsTab();
      case 2:
        return const DepartmentsTab();
      case 3:
        return const FinancialTab();
      default:
        return const OverviewTab();
    }
  }
}
