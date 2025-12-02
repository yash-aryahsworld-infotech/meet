import 'package:flutter/material.dart';
import '../../widgets/custom_statscard.dart'; // Keep your existing import

// -------------------------------------------------------
// 1. THE PARENT SECTION (Handles Data & Responsive Grid)
// -------------------------------------------------------
class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Data updated to match your uploaded image
    final List<Map<String, dynamic>> statsData = [
      {
        "title": "Today's Patients",
        "value": "12",
        "icon": Icons.group_outlined,
        "color": const Color(0xFF2563EB), // Blue
      },
      {
        "title": "This Week",
        "value": "67",
        "icon": Icons.calendar_today_outlined,
        "color": const Color(0xFF10B981), // Green
      },
      {
        "title": "Rating",
        "value": "4.8",
        "icon": Icons.star_border_rounded,
        "color": const Color(0xFFF59E0B), // Orange/Yellow
      },
      {
        "title": "Response Time",
        "value": "< 2min",
        "icon": Icons.access_time,
        "color": const Color(0xFF06B6D4), // Cyan
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive Logic:
        // Width > 900 (Web) -> 4 Columns
        // Width <= 900 (Mobile/Tablet) -> 2 Columns
        int crossAxisCount = constraints.maxWidth > 900 ? 4 : 2;

        return GridView.builder(
          shrinkWrap: true, 
          physics: const NeverScrollableScrollPhysics(),
          itemCount: statsData.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16, 
            mainAxisSpacing: 16,  
            mainAxisExtent: 85,   // Adjusted height for better fit
          ),
          itemBuilder: (context, index) {
            final data = statsData[index];
            return StatsCard(
              title: data['title'],
              value: data['value'],
              icon: data['icon'],
              iconColor: data['color'],
            );
          },
        );
      },
    );
  }
}