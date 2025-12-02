import 'package:flutter/material.dart';

class StatItem {
  final String title;
  final String count;
  final IconData icon;
  final Color themeColor;

  const StatItem({
    required this.title,
    required this.count,
    required this.icon,
    required this.themeColor,
  });
}

class QuickStatCard extends StatelessWidget {
  final StatItem item;

  const QuickStatCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 480;

    // Responsive sizes
    final double iconSize = isMobile ? 20 : 28;
    final double titleSize = isMobile ? 12 : 14;
    final double countSize = isMobile ? 18 : 24;
    final double horizontalPadding = isMobile ? 12 : 16;
    final double verticalPadding = isMobile ? 14 : 20;
    final double spacing = isMobile ? 10 : 16;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            item.icon,
            size: iconSize,
            color: item.themeColor,
          ),

          SizedBox(width: spacing),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    color: Colors.blueGrey[400],
                    fontSize: titleSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.count,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: countSize,
                    fontWeight: FontWeight.bold,
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
