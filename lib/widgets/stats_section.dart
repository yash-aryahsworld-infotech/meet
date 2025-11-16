import 'package:flutter/material.dart';
import '../utils/app_responsive.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  // Compact stat card
  Widget statCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // smaller card height
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.radiusMD),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // shrink height
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13, // smaller title text
            ),
          ),

          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20, // smaller value number
                  fontWeight: FontWeight.bold,
                ),
              ),

              Icon(
                icon,
                color: Colors.blue,
                size: 22, // smaller icon
              ),
            ],
          ),
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
        statCard("Response Time", "< 2min", Icons.access_time),
      ],
    );
  }
}
