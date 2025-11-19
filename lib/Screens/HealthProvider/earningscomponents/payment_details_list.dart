import 'package:flutter/material.dart';

class PaymentDetailsList extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Map<String, dynamic>> payments;

  // dynamic button text
  final String buttonText;

  const PaymentDetailsList({
    super.key,
    required this.title,
    required this.subtitle,
    required this.payments,
    this.buttonText = "View",
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case "paid":
        return const Color(0xFFD1F2D5);
      case "pending":
        return const Color(0xFFFFF3B0);
      case "overdue":
        return const Color(0xFFFFD4D4);
      default:
        return Colors.grey.shade200;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case "paid":
        return const Color(0xFF2E7D32);
      case "pending":
        return const Color(0xFFA67C00);
      case "overdue":
        return const Color(0xFFC62828);
      default:
        return Colors.black;
    }
  }

  Color _iconBackground(String status) {
    switch (status) {
      case "pending":
        return const Color(0xFFFFF4CC);
      case "overdue":
        return const Color(0xFFFFE5E5);
      default:
        return const Color(0xFFE6F0FF);
    }
  }

  IconData _getIcon(String status) {
    switch (status) {
      case "pending":
        return Icons.access_time;
      case "overdue":
        return Icons.warning_amber_rounded;
      default:
        return Icons.credit_card;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        /// TITLE
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 4),

        /// SUBTITLE
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),

        const SizedBox(height: 20),

        ...payments.map((payment) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  spreadRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                // ICON
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _iconBackground(payment["status"]),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIcon(payment["status"]),
                    size: 22,
                    color: Colors.grey.shade800,
                  ),
                ),

                const SizedBox(width: 14),

                // NAME & DETAILS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment["name"],
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${payment["type"]} • ${payment["date"]}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                // AMOUNT & STATUS
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "₹${payment["amount"]}",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: _getStatusColor(payment["status"]),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        payment["status"],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _getStatusTextColor(payment["status"]),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 20),

                // ⭐ DYNAMIC BUTTON
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
