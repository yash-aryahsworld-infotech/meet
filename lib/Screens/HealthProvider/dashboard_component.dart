import 'package:flutter/material.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';

import "../../widgets/header_section.dart";
import "../../widgets/stats_section.dart";
import "../../widgets/schedule_section.dart";
import "../../widgets/earnings_section.dart";

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

            /// HEADER — always full width
            const HeaderSection(
              doctorName: "Dr. Priya",
              appointmentsToday: 12,
              isOnline: true,
            ),

            const SizedBox(height: 20),

            /// Stats section — responsive inside
            const StatsSection(),

            const SizedBox(height: 20),

            /// MAIN SCHEDULE + EARNINGS RESPONSIVE LAYOUT
            if (isMobile) ...[
              /// MOBILE (one column)
              const ScheduleSection(),
              const SizedBox(height: 20),
              const EarningsSection(),
            ]
            else if (isTablet) ...[
              /// TABLET (two equal columns)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(flex: 1, child: ScheduleSection()),
                  SizedBox(width: 20),
                  Expanded(flex: 1, child: EarningsSection()),
                ],
              )
            ]
            else if (isDesktop) ...[
                /// DESKTOP (wide schedule, smaller earnings)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(flex: 7, child: ScheduleSection()),
                    SizedBox(width: 20),
                    Expanded(flex: 5, child: EarningsSection()),
                  ],
                )
              ],
          ],
        ),
      ),
    );
  }
}
