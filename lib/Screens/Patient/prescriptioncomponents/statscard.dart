import 'package:flutter/material.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';
import 'package:healthcare_plus/widgets/custom_quickstats_card.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<StatItem> stats = [
      const StatItem(
        title: "Active",
        count: "12",
        icon: Icons.medication_outlined,
        themeColor: Color(0xFF00C853),
      ),
      const StatItem(
        title: "Completed",
        count: "45",
        icon: Icons.check_circle_outline_rounded,
        themeColor: Color(0xFF2962FF),
      ),
      const StatItem(
        title: "Expired",
        count: "2",
        icon: Icons.warning_amber_rounded,
        themeColor: Color(0xFFD50000),
      ),
      const StatItem(
        title: "Reminders",
        count: "3",
        icon: Icons.notifications_none_rounded,
        themeColor: Color(0xFFFF6D00),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;

        int crossAxis;


        if (AppResponsive.isMobile(context) || AppResponsive.isTablet(context)) {
          crossAxis = 2; // medium mobiles & tablets
        } 
        else {
          crossAxis = 4; // desktop
        }

        double gap = 16;
        double itemWidth = (width - (gap * (crossAxis - 1))) / crossAxis;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: stats
              .map(
                (item) => SizedBox(
                  width: itemWidth,
                  child: QuickStatCard(item: item),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
