import 'package:flutter/material.dart';

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
    // 1. Determine if device is mobile based on width
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      height: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 20, // Less padding on mobile
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 2. Expanded prevents the column from pushing the icon off-screen
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1, // Ensures it stays on one line
                  overflow: TextOverflow.ellipsis, // Adds "..." if still too long
                  style: TextStyle(
                    // 3. Dynamic Font Size: Smaller on mobile
                    fontSize: isMobile ? 11 : 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    // 3. Dynamic Font Size: Smaller on mobile
                    fontSize: isMobile ? 18 : 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8), // Space between text and icon

          // Icon
          Icon(
            icon,
            color: color,
            // 3. Dynamic Icon Size: Smaller on mobile
            size: isMobile ? 22 : 28,
          ),
        ],
      ),
    );
  }
}