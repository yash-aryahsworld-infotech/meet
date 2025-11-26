import 'package:flutter/material.dart';
import 'package:healthcare_plus/widgets/custom_quickstats_card.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // UPDATED DATA: Matching the 3 cards in your image
    final List<StatItem> stats = [
      const StatItem(
        title: "Active Policies",
        count: "0",
        icon: Icons.security_outlined, // Shield icon
        themeColor: Color(0xFF1665D8), // Blue
      ),
      const StatItem(
        title: "Total Claims",
        count: "0",
        icon: Icons.description_outlined, // Document icon
        themeColor: Color(0xFF00C853), // Green
      ),
      const StatItem(
        title: "Pending Claims",
        count: "0",
        icon: Icons.attach_money, // Dollar/Currency icon
        themeColor: Color(0xFFFF6D00), // Orange
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // RESPONSIVE LOGIC:
        // Desktop (> 800px): Show 3 per row (to match the image)
        // Tablet/Mobile: Show 1 per row (stacked) for better readability
        int crossAxisCount = constraints.maxWidth > 800 ? 3 : 1;
        
        // Use a standard gap
        double gap = 16.0;
        
        // Calculate width dynamically
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