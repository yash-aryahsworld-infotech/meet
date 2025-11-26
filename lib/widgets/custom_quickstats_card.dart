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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0), // Rounded corners like image
        border: Border.all(
          color: Colors.grey.shade300, // Subtle border
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
        crossAxisAlignment: CrossAxisAlignment.start, // Align icon with top of text
        children: [
          // Icon Section
          Container(
            padding: const EdgeInsets.only(top: 2), // Slight visual adjustment
            child: Icon(
              item.icon,
              size: 28,
              color: item.themeColor,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Text Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    color: Colors.blueGrey[400], // Muted text color for label
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.count,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 24.0, // Large number
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