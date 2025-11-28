import 'package:flutter/material.dart';
import '../../../widgets/custom_statscard.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // ⭐ Matches your screenshot exactly
    final List<Map<String, dynamic>> statsData = [
      {
        "title": "Enrolled",
        "value": "238",
        "icon": Icons.people_alt_outlined,
        "iconColor": const Color(0xFF2563EB), // blue
        "bottom": "95% of workforce",
        "bottomColor": Colors.green,
      },
      {
        "title": "Cost Savings",
        "value": "₹4.2L",
        "icon": Icons.attach_money_rounded,
        "iconColor": const Color(0xFF10B981), // green
        "bottom": "vs last quarter",
        "bottomColor": const Color(0xFF10B981),
      },
      {
        "title": "Active Programs",
        "value": "8",
        "icon": Icons.monitor_heart_outlined,
        "iconColor": const Color(0xFF06B6D4), // cyan
        "bottom": "2 launching soon",
        "bottomColor": const Color(0xFF06B6D4),
      },
      {
        "title": "Engagement",
        "value": "78%",
        "icon": Icons.track_changes_rounded,
        "iconColor": const Color(0xFF8B5CF6), // purple
        "bottom": "monthly average",
        "bottomColor": const Color(0xFF8B5CF6),
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
            mainAxisExtent: 110, // PERFECT size like your screenshot
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
