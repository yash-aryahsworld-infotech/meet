import 'package:flutter/material.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';

import '../../widgets/header_section.dart';
import '../../widgets/stats_section.dart';
import '../../widgets/schedule_section.dart';
import '../../widgets/earnings_section.dart';
import '../../widgets/quick_actions_section.dart';
import '../../widgets/patient_overview_section.dart';

class HealthProviderDashboard extends StatelessWidget {
  const HealthProviderDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = AppResponsive.isMobile(context);
    final bool isTablet = AppResponsive.isTablet(context);
    final bool isDesktop = AppResponsive.isDesktop(context);

    return MaxWidthContainer(
      child: Padding(
        padding: AppResponsive.pagePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ----------------------------------------
            /// HEADER
            /// ----------------------------------------
            const HeaderSection(
              doctorName: "Dr. Priya",
              appointmentsToday: 12,
              isOnline: true,
            ),

            const SizedBox(height: 20),

            /// ----------------------------------------
            /// STATS SECTION
            /// ----------------------------------------
            const StatsSection(),

            const SizedBox(height: 20),

            /// ----------------------------------------
            /// MAIN SCHEDULE + EARNINGS RESPONSIVE
            /// ----------------------------------------
            if (isMobile) ...[
              const ScheduleSection(),
              const SizedBox(height: 20),
              const EarningsSection(),
              const SizedBox(height: 20),
              const QuickActionsSection(),
              const SizedBox(height: 20),
              const PatientOverviewSection(),
            ]

            else if (isTablet) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(child: ScheduleSection()),
                  SizedBox(width: 20),
                  Expanded(child: EarningsSection()),
                ],
              ),
              const SizedBox(height: 20),
              const QuickActionsSection(),
              const SizedBox(height: 20),
              const PatientOverviewSection(),
            ]

            else if (isDesktop) ...[
              /// DESKTOP — WIDE SCHEDULE + EARNINGS
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(flex: 7, child: ScheduleSection()),
                  SizedBox(width: 20),
                  Expanded(flex: 5, child: EarningsSection()),
                ],
              ),

              const SizedBox(height: 30),

              /// QUICK ACTIONS — on the right side
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Spacer(flex: 7),
                  Expanded(flex: 5, child: QuickActionsSection()),
                ],
              ),

              const SizedBox(height: 20),

              /// PATIENT OVERVIEW — full width below quick actions
              const PatientOverviewSection(),
            ],
          ],
        ),
      ),
    );
  }
}
