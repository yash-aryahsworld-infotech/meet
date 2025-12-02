import 'package:flutter/material.dart';
import 'package:healthcare_plus/widgets/custom_quickstats_card.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<StatItem> stats = [
      const StatItem(
        title: "Active Policies",
        count: "0",
        icon: Icons.security_outlined,
        themeColor: Color(0xFF1665D8),
      ),
      const StatItem(
        title: "Total Claims",
        count: "0",
        icon: Icons.description_outlined,
        themeColor: Color(0xFF00C853),
      ),
      const StatItem(
        title: "Pending Claims",
        count: "0",
        icon: Icons.attach_money,
        themeColor: Color(0xFFFF6D00),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        int crossAxisCount;

        if (maxWidth < 800) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 3;
        }

        double gap = 16.0;
        double itemWidth =
            (maxWidth - ((crossAxisCount - 1) * gap)) / crossAxisCount;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: stats.map((stat) {
            return SizedBox(
              width: itemWidth,
              child: QuickStatCard(item: stat),
            );
          }).toList(),
        );
      },
    );
  }
}
