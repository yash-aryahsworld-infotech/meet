import 'package:flutter/material.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50, // 🔥 Smaller height than before
      padding: const EdgeInsets.symmetric(
        horizontal: AppResponsive.spaceSM,
        vertical: AppResponsive.spaceXS,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.radiusMD),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          // Smaller icon badge
          Container(
            height: 20,   // 🔥 smaller
            width: 20,    // 🔥 circle fixed
            decoration: BoxDecoration(
              color: color.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 18, // 🔥 smaller icon
            ),
          ),

          const SizedBox(width: AppResponsive.spaceSM),

          // Text column
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppResponsive.fontXS(context), // 🔥 smaller title
                    fontWeight: AppResponsive.medium,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 2), // 🔥 tiny spacing

                Text(
                  value,
                  style: TextStyle(
                    fontSize: AppResponsive.fontSM(context), // 🔥 smaller value
                    fontWeight: AppResponsive.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
