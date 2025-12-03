import 'package:flutter/material.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';
import 'package:healthcare_plus/widgets/custom_quickstats_card.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // UPDATED: Stats list matching the provided image (Total Providers, Verified, Pending, Avg Fee)
    final List<StatItem> stats = [
      const StatItem(
        title: "Total Providers",
        count: "5",
        // Icon: Group of people
        icon: Icons.groups_outlined, 
        // Color: Blue
        themeColor: Color(0xFF2962FF), 
      ),
      const StatItem(
        title: "Verified",
        count: "3",
        // Icon: Check circle
        icon: Icons.check_circle_outline, 
        // Color: Green
        themeColor: Color(0xFF00C853), 
      ),
      const StatItem(
        title: "Pending Review",
        count: "1",
        // Icon: Clock / Timer
        icon: Icons.access_time_rounded, 
        // Color: Orange/Amber
        themeColor: Color(0xFFFFA000), 
      ),
      const StatItem(
        title: "Avg. Fee",
        count: "₹850",
        // Icon: Currency symbol
        icon: Icons.currency_rupee, // Or Icons.attach_money if you prefer generic
        // Color: Blue (same as first card)
        themeColor: Color(0xFF2962FF), 
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;

        int crossAxis;

        // Responsive Logic
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