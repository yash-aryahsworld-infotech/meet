import 'package:flutter/material.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';
import '../../../widgets/custom_statscard.dart';

class HealthSummarySection extends StatelessWidget {
  const HealthSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> summaryData = [
      {
        "title": "Risk Level",
        "value": "Low",
        "icon": Icons.monitor_heart_outlined,
        "color": Colors.green,
      },
      {
        "title": "Appointments",
        "value": "0",
        "icon": Icons.calendar_month_outlined,
        "color": Colors.blue,
      },
      {
        "title": "Medications",
        "value": "0",
        "icon": Icons.medication_outlined,
        "color": Colors.green,
      },
      {
        "title": "Coverage",
        "value": "₹500,000",
        "icon": Icons.shield_outlined,
        "color": Colors.teal,
      },
    ];

    int crossAxisCount;

    // MODIFIED: Set to 2 for both Mobile and Tablet
    if (AppResponsive.isMobile(context)) {
      crossAxisCount = 2; 
    } else if (AppResponsive.isTablet(context)) {
      crossAxisCount = 2;
    } else if (AppResponsive.isDesktop(context) &&
        !AppResponsive.isLargeDesktop(context)) {
      crossAxisCount = 4;
    } else {
      crossAxisCount = 4;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: summaryData.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppResponsive.spaceMD,
        mainAxisSpacing: AppResponsive.spaceMD,
        mainAxisExtent: 85, 
      ),
      itemBuilder: (context, index) {
        final item = summaryData[index];

        return StatsCard(
          title: item["title"],
          value: item["value"],
          icon: item["icon"],
          color: item["color"],
        );
      },
    );
  }
}