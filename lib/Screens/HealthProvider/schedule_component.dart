import 'package:flutter/material.dart';
import '../../widgets/custom_tab.dart';
import '../../widgets/custom_button.dart';
import './schedulecomponent/today_tab.dart';
import './schedulecomponent/upcoming_tab.dart';
import './schedulecomponent/all_appointments_tab.dart';
import './schedulecomponent/calendar_panel.dart';
import './schedulecomponent/quick_stats.dart';
class ScheduleComponent extends StatefulWidget {
  const ScheduleComponent({super.key});

  @override
  State<ScheduleComponent> createState() => _ScheduleComponentState();
}

class _ScheduleComponentState extends State<ScheduleComponent> {
  int selectedTab = 0;

  final List<String> tabTitles = ["Today", "Upcoming", "All Appointments"];
  final List<int> tabCounts = [0, 12, 38];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    bool isMobile = width < 600;
    bool isTablet = width >= 600 && width < 1200;
    bool isDesktop = width >= 1200;

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isMobile),

          const SizedBox(height: 30),

          if (isDesktop) _buildDesktopLayout(),
          if (isTablet) _buildTabletLayout(),
          if (isMobile) _buildMobileLayout(),
        ],
      );
  }

  // ---------------------------------------------------------
  // TOP HEADER (Responsive) — Add button moves in MOBILE
  // ---------------------------------------------------------
  Widget _buildHeader(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Schedule Management",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Manage your appointments and availability",
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Schedule Management",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              "Manage your appointments and availability",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ],
        ),

        // Add Time Slot button for DESKTOP/TABLET
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 140,
            maxWidth: 200,
            minHeight: 45,
            maxHeight: 45,
          ),
          child: CustomButton(
            text: "Add Time Slot",
            icon: Icons.add,
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // DESKTOP (Tabs Left + Calendar Right)
  // ---------------------------------------------------------
  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildLeftSection(autoWidth: false)),
        const SizedBox(width: 30),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              const CalendarPanel(),
              const SizedBox(height: 20),
              QuickStats(
                // ❌ remove const
                stats: [
                  QuickStatItem("Today's appointments", "0"),
                  QuickStatItem("This week", "0"),
                  QuickStatItem("Completed", "0"),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // TABLET (Stacked)
  // ---------------------------------------------------------
  Widget _buildTabletLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLeftSection(autoWidth: true),
        const SizedBox(height: 25),
        const CalendarPanel(),
        const SizedBox(height: 20),
        QuickStats(
          stats: [
            QuickStatItem("Today's appointments", "0"),
            QuickStatItem("This week", "0"),
            QuickStatItem("Completed", "0"),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // MOBILE (Stacked + Add Button Moves Below Tabs)
  // ---------------------------------------------------------
  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add Time Slot button ONLY in Mobile here
        CustomButton(text: "Add Time Slot", icon: Icons.add, onPressed: () {}),

        const SizedBox(height: 25),
        _buildLeftSection(autoWidth: true),
        const SizedBox(height: 20),
        const CalendarPanel(),
        const SizedBox(height: 20),
        QuickStats(
          // remove const
          stats: [
            QuickStatItem("Today's appointments", "0"),
            QuickStatItem("This week", "0"),
            QuickStatItem("Completed", "0"),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // LEFT SECTION — Tabs + Content (Tabs auto-width now)
  // ---------------------------------------------------------
  Widget _buildLeftSection({required bool autoWidth}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tabs adjust automatically based on width
        Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: autoWidth
                ? const BoxConstraints(maxWidth: double.infinity)
                : const BoxConstraints(maxWidth: 600),
            child: TabToggle(
              options: tabTitles,
              counts: tabCounts,
              selectedIndex: selectedTab,
              onSelected: (index) {
                setState(() => selectedTab = index);
              },
            ),
          ),
        ),

        const SizedBox(height: 20),

        _buildTabContent(),
      ],
    );
  }

  // ---------------------------------------------------------
  // TAB CONTENT
  // ---------------------------------------------------------
  Widget _buildTabContent() {
    switch (selectedTab) {
      case 0:
        return const TodayTab();
      case 1:
        return const UpcomingTab();
      case 2:
        return const AllAppointmentsTab();
      default:
        return const TodayTab();
    }
  }
}
