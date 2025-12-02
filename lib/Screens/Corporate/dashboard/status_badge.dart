import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final Color color;
  
  const StatusBadge({super.key, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    // Styling based on status type
    Color bgColor;
    Color textColor;
    
    if (status == 'active') {
      bgColor = const Color(0xFF1976D2);
      textColor = Colors.white;
    } else if (status == 'scheduled') {
      bgColor = Colors.grey.shade100;
      textColor = Colors.grey.shade800;
    } else {
      // Completed or others
      bgColor = Colors.white;
      textColor = Colors.black87;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: status == 'completed' ? Border.all(color: Colors.grey.shade300) : null,
      ),
      child: Text(
        status,
        style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}