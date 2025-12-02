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
        title: "Total Employees",
        count: total.toString(),
        icon: Icons.people_outline,
        themeColor: const Color(0xFF2962FF), // Blue
      ),
      StatItem(
        title: "Active",
        count: active.toString(),
        icon: Icons.ssid_chart,
        themeColor: const Color(0xFF00C853), // Green
      ),
      StatItem(
        title: "Avg Health Score",
        count: avgScore,
        icon: Icons.favorite_border,
        themeColor: const Color(0xFFD50000), // Red/Heart color
      ),
      StatItem(
        title: "Program Enrollments",
        count: programs.toString(),
        icon: Icons.insights,
        themeColor: const Color(0xFF6200EA), // Purple
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