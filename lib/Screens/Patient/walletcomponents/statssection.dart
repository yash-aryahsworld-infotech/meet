import 'package:flutter/material.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = AppResponsive.isMobile(context);

    double cardWidth = isMobile ? 180 : double.infinity;
    double cardPadding = isMobile ? 16 : 20;
    double iconSize = isMobile ? 22 : 26;
    double titleSize = isMobile ? 12 : 14;
    double valueSize = isMobile ? 18 : 20;
    double subtitleSize = isMobile ? 11 : 12;
    double spacing = isMobile ? 6 : 10;

    Widget statCard({
      required String title,
      required String value,
      required String subtitle,
      required Color subtitleColor,
      required IconData icon,
      required Color iconColor,
    }) {
      return Container(
        width: cardWidth,
        padding: EdgeInsets.symmetric(vertical: cardPadding, horizontal: cardPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: iconSize),
            SizedBox(height: spacing),
            Text(
              title,
              style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: spacing),
            Text(
              value,
              style: TextStyle(
                fontSize: valueSize,
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
            SizedBox(height: spacing),
            Text(
              subtitle,
              style: TextStyle(fontSize: subtitleSize, color: subtitleColor),
            ),
          ],
        ),
      );
    }

    // MOBILE → HORIZONTAL SCROLL
    if (isMobile) {
      return SizedBox(
        height: 150,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            statCard(
              title: "Monthly Spending",
              value: "₹3,450",
              subtitle: "↑ 12% from last month",
              subtitleColor: Colors.green,
              icon: Icons.trending_up,
              iconColor: Colors.green,
            ),
            const SizedBox(width: 12),
            statCard(
              title: "This Month",
              value: "8",
              subtitle: "Total transactions",
              subtitleColor: Colors.grey,
              icon: Icons.calendar_today,
              iconColor: Colors.blue,
            ),
            const SizedBox(width: 12),
            statCard(
              title: "Rewards Earned",
              value: "125",
              subtitle: "Points this month",
              subtitleColor: Colors.grey,
              icon: Icons.account_balance_wallet,
              iconColor: Colors.purple,
            ),
          ],
        ),
      );
    }

    // DESKTOP/TABLET → NORMAL ROW
    return Row(
      children: [
        Expanded(
          child: statCard(
            title: "Monthly Spending",
            value: "₹3,450",
            subtitle: "↑ 12% from last month",
            subtitleColor: Colors.green,
            icon: Icons.trending_up,
            iconColor: Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: statCard(
            title: "This Month",
            value: "8",
            subtitle: "Total transactions",
            subtitleColor: Colors.grey,
            icon: Icons.calendar_today,
            iconColor: Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: statCard(
            title: "Rewards Earned",
            value: "125",
            subtitle: "Points this month",
            subtitleColor: Colors.grey,
            icon: Icons.account_balance_wallet,
            iconColor: Colors.purple,
          ),
        ),
      ],
    );
  }
}
