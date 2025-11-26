// ticket_badge.dart
import 'package:flutter/material.dart';

class TicketBadge extends StatelessWidget {
  final String text;

  const TicketBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (text.toLowerCase()) {
      case 'medium':
        bg = const Color(0xFFFFF7E6);
        fg = const Color(0xFFD48806);
        break;
      case 'resolved':
        bg = const Color(0xFFF6FFED);
        fg = const Color(0xFF52C41A);
        break;
      case 'high':
        bg = const Color(0xFFFFF1F0);
        fg = const Color(0xFFF5222D);
        break;
      case 'open':
        bg = const Color(0xFFE6F7FF);
        fg = const Color(0xFF1890FF);
        break;
      default:
        bg = Colors.grey.shade100;
        fg = Colors.grey.shade600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

