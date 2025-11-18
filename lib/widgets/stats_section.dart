import 'package:flutter/material.dart';
import '../utils/app_responsive.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  // Compact stat card
  Widget statCard(String title, String value, IconData icon, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppResponsive.spaceMD,
        vertical: AppResponsive.spaceSM,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.radiusMD),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: AppResponsive.semiBold,
              fontSize: AppResponsive.fontSM(context),
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: AppResponsive.spaceSM),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: AppResponsive.fontLG(context),
                  fontWeight: AppResponsive.bold,
                  color: Colors.black87,
                ),
              ),

              Icon(
                icon,
                color: Colors.blue,
                size: 22,
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
    final bool isDesktop = AppResponsive.isDesktop(context);

    // Responsive column count
    int colCount = isMobile
        ? 2
        : isTablet
            ? 3
            : 4; // desktop -> 4 cards in a row

    // Increase spacing for desktop
    double spacing = isDesktop ? 20 : 16;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: colCount,
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
      childAspectRatio: 1.6, // FIXED: prevents cards from becoming too tall

      children: [
        statCard("Today's Patients", "12", Icons.people_alt, context),
        statCard("This Week", "67", Icons.calendar_today, context),
        statCard("Rating", "4.8", Icons.star, context),
        statCard("Response Time", "< 2 min", Icons.access_time, context),
      ],
    );
  }
}
