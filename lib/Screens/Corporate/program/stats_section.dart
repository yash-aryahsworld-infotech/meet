import 'package:flutter/material.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';
import 'package:healthcare_plus/widgets/custom_quickstats_card.dart';

class StatsSection extends StatelessWidget {
  final int total;
  final int active;
  final String avgScore;
  final int programs;

  const StatsSection({
    super.key,
    required this.total,
    required this.active,
    required this.avgScore,
    required this.programs,
  });

  @override
  Widget build(BuildContext context) {
    // Labels matched to your screenshot
    final List<StatItem> stats = [
      StatItem(
        title: "Total Programs",
        count: total.toString(),
        icon: Icons.gps_fixed, // Matches the blue target icon
        themeColor: const Color(0xFF2962FF), // Blue
      ),
      StatItem(
        title: "Active Programs",
        count: active.toString(),
        icon: Icons.show_chart, // Matches the green pulse/activity line
        themeColor: const Color(0xFF00C853), // Green
      ),
      StatItem(
        title: "Total Enrollments",
        count: programs.toString(),
        icon: Icons.groups_outlined, // Matches the purple people icon
        themeColor: const Color(0xFF6200EA), // Purple
      ),
      StatItem(
        title: "Avg Completion",
        count: avgScore,
        icon: Icons.trending_up, // Matches the orange rising arrow
        themeColor: const Color(0xFFFF6D00), // Orange
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        int crossAxis;

        if (AppResponsive.isMobile(context) || AppResponsive.isTablet(context)) {
          crossAxis = 2; 
        } else {
          crossAxis = 4;
        }

        double gap = 16;
        double itemWidth = (width - (gap * (crossAxis - 1))) / crossAxis;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: stats
              .map((item) => SizedBox(
                    width: itemWidth,
                    child: QuickStatCard(item: item),
                  ))
              .toList(),
        );
      },
    );
  }
}