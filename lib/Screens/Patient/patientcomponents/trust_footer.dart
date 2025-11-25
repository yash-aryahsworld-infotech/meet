import 'package:flutter/material.dart';

class TrustFooter extends StatelessWidget {
  const TrustFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.lock_outline,
              size: 14,
              color: Colors.amber.shade700,
            ),
            const SizedBox(width: 8),
            Text(
              "🔒 All payments are secured with 256-bit SSL encryption",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.verified_user_outlined,
              size: 14,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              "💰 No hidden charges - all fees displayed upfront",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 22),
          child: Text(
            "📱 Instant confirmation and digital receipt",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 22),
          child: Text(
            "🔄 Easy refunds within 24 hours for eligible transactions",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }
}