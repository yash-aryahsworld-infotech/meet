import 'package:flutter/material.dart';
import '../utils/app_responsive.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  Widget statCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.radiusMD),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Icon(icon, color: Colors.blue),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = AppResponsive.isMobile(context);
    final bool isTablet = AppResponsive.isTablet(context);

    int colCount = isMobile ? 2 : isTablet ? 3 : 4;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: colCount,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        statCard("Today's Patients", "12", Icons.people_alt),
        statCard("This Week", "67", Icons.calendar_today),
        statCard("Rating", "4.8", Icons.star),
        statCard("Response Time", "< 2 min", Icons.access_time),
      ],
    );
  }
}
