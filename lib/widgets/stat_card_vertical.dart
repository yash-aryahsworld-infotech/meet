import 'package:flutter/material.dart';

class VerticalStatCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color iconColor;
  final double width;

  const VerticalStatCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.iconColor,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 480;

    // Responsive sizes
    final double iconSize = isMobile ? 16 : 20;
    final double countSize = isMobile ? 18 : 22;
    final double titleSize = isMobile ? 11 : 13;
    final double padding = isMobile ? 10 : 12;

    return Container(
      width: width,
      padding: EdgeInsets.symmetric(vertical: padding, horizontal: padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ICON
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: iconSize, color: iconColor),
          ),

          const SizedBox(height: 8),

          // COUNT
          Text(
            "$count",
            style: TextStyle(
              fontSize: countSize,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 6),

          // LABEL
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
