import 'package:flutter/material.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';
import 'package:healthcare_plus/widgets/custom_quickstats_card.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // UPDATED: Stats list matching the provided image
    final List<StatItem> stats = [
      const StatItem(
        title: "Total Users",
        count: "6",
        // Icon: User outline
        icon: Icons.person_outline_rounded, 
        // Color: Blue
        themeColor: Color(0xFF2962FF), 
      ),
      const StatItem(
        title: "Active",
        count: "4",
        // Icon: User with checkmark
        icon: Icons.how_to_reg_outlined, 
        // Color: Green
        themeColor: Color(0xFF00C853), 
      ),
      const StatItem(
        title: "Inactive",
        count: "1",
        // Icon: User with 'x' / crossed out
        icon: Icons.person_off_outlined, 
        // Color: Grey / BlueGrey
        themeColor: Color(0xFF546E7A), 
      ),
      const StatItem(
        title: "Suspended",
        count: "1",
        // Icon: Shield
        icon: Icons.security_outlined, 
        // Color: Red
        themeColor: Color(0xFFD32F2F), 
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