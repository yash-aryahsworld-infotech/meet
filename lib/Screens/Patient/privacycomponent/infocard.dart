import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  // 1. Define final variables for dynamic data
  final String title;
  final IconData icon;
  final List<String> points;
  
  // 2. Optional styling properties with default values
  final Color backgroundColor;
  final Color accentColor;

  const InfoCard({
    super.key,
    required this.points, // The list of text is required
    this.title = "Your Rights", // Default title if none provided
    this.icon = Icons.remove_red_eye_outlined, // Default icon
    this.backgroundColor = const Color(0xFFE3F2FD), // Light Blue
    this.accentColor = const Color(0xFF1565C0), // Dark Blue
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accentColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          // 3. Generate the list of points dynamically
          ...points.map((text) => _buildBulletPoint(text)),
        ],
      ),
    );
  }

  // --- Helper Methods for Clean Code ---

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(icon, color: accentColor, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "•",
            style: TextStyle(
              color: accentColor,
              fontSize: 18,
              height: 1.1, 
            ),
          ),
          const SizedBox(width: 8),
          // Expanded ensures text wraps on mobile screens
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: accentColor.withOpacity(0.9), // Slightly softer text
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}