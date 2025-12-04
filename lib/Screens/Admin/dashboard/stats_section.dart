import 'package:flutter/material.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';
import 'package:healthcare_plus/widgets/custom_quickstats_card.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Updated list with 5 items based on your design
    final List<StatItem> stats = [
      const StatItem(
        title: "Total Users",
        count: "26",
        icon: Icons.people_outline_rounded,
        themeColor: Color(0xFF2962FF), // Blue
      ),
      const StatItem(
        title: "Providers",
        count: "1",
        icon: Icons.business_outlined, // or domain
        themeColor: Color(0xFF00C853), // Green
      ),
      const StatItem(
        title: "Appointments",
        count: "0",
        icon: Icons.monitor_heart_outlined, // Pulse icon
        themeColor: Color(0xFF6200EA), // Purple
      ),
      const StatItem(
        title: "Active Users",
        count: "15",
        icon: Icons.language, // Globe icon
        themeColor: Color(0xFFFF6D00), // Orange
      ),
      const StatItem(
        title: "System Health",
        count: "Healthy", // Text instead of number
        icon: Icons.dns_outlined, // Server icon
        themeColor: Color(0xFFD50000), // Red
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;

        int crossAxis;

        if (AppResponsive.isMobile(context)) {
           crossAxis = 2; // Mobile: 2 per row (2 rows of 2, 1 row of 1)
        } else if (AppResponsive.isTablet(context)) {
           crossAxis = 3; // Tablet: 3 per row looks better than 2
        } else {
           crossAxis = 5; // Desktop: All 5 in one row
        }

        double gap = 16;
        // Calculate width so they fill the available space evenly
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