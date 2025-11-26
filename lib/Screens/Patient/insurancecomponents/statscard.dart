import 'package:flutter/material.dart';
import 'package:healthcare_plus/widgets/custom_quickstats_card.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Define your dynamic data here
    final List<StatItem> stats = [
      const StatItem(
        title: "Active",
        count: "0",
        icon: Icons.medication_outlined, // Pill icon
        themeColor: Color(0xFF00C853),   // Green
      ),
      const StatItem(
        title: "Completed",
        count: "0",
        icon: Icons.check_circle_outline_rounded,
        themeColor: Color(0xFF2962FF),   // Blue
      ),
      const StatItem(
        title: "Expired",
        count: "0",
        icon: Icons.warning_amber_rounded,
        themeColor: Color(0xFFD50000),   // Red
      ),
      const StatItem(
        title: "Reminders",
        count: "3",
        icon: Icons.notifications_none_rounded,
        themeColor: Color(0xFFFF6D00),   // Orange
      ),
    ];

    // LayoutBuilder allows us to be responsive.
    // The image shows a single row, but on mobile, we might want 2 per row.
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate width for cards to fill available space evenly
        // We subtract spacing (gap) from total width.
        // On wide screens (>= 800px), we show 4 in a row.
        // On smaller screens, we show 2 per row.
        
        int crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;
        if (constraints.maxWidth < 400) crossAxisCount = 1; // Very small screens

        double gap = 16.0;
        double itemWidth = (constraints.maxWidth - ((crossAxisCount - 1) * gap)) / crossAxisCount;

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