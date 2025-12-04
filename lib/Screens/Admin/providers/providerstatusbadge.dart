import 'package:flutter/material.dart';

class ProviderStatusBadge extends StatelessWidget {
  final String status;

  const ProviderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case 'Verified':
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        icon = Icons.check_circle_outline;
        break;
      case 'Pending':
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
        icon = Icons.access_time;
        break;
      case 'Rejected':
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        icon = Icons.cancel_outlined;
        break;
      default:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}