import 'package:flutter/material.dart';
import 'package:healthcare_plus/widgets/custom_statscard.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // ⭐ Matches your NEW screenshot exactly
    final List<Map<String, dynamic>> statsData = [
      {
        "title": "Total Employees",
        "value": "195",
        "icon": Icons.people_outline,
        "iconColor": const Color(0xFF2563EB), // Blue
        "bottom": "+5% from last month",
        "bottomColor": const Color(0xFF10B981), // Green
      },
      {
        "title": "Avg Health Score",
        "value": "82",
        "icon": Icons.favorite_border,
        "iconColor": const Color(0xFFDC2626), // Red Heart
        "bottom": "+8 points",
        "bottomColor": const Color(0xFF10B981), // Green
      },
      {
        "title": "Cost Savings",
        "value": "₹3.0L",
        "icon": Icons.attach_money,
        "iconColor": const Color(0xFF10B981), // Green Dollar
        "bottom": "+25% vs traditional",
        "bottomColor": const Color(0xFF10B981), // Green
      },
      {
        "title": "Program Engagement",
        "value": "78%",
        "icon": Icons.show_chart, // Pulse icon
        "iconColor": const Color(0xFF8B5CF6), // Purple
        "bottom": "+12% engagement",
        "bottomColor": const Color(0xFF10B981), // Green
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // 📱 Mobile/Tablet → 2 Columns
        // 🖥 Web/Large Desktop → 4 Columns
        int columns = constraints.maxWidth > 900 ? 4 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: statsData.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 110,
          ),
          itemBuilder: (context, i) {
            final item = statsData[i];
            return StatsCard(
              title: item['title'],
              value: item['value'],
              icon: item['icon'],
              iconColor: item['iconColor'],
              bottomDesc: item['bottom'],
              bottomDescColor: item['bottomColor'],
            );
          },
        );
      },
    );
  }
}