import 'package:flutter/material.dart';
import './transparent_card.dart';

class PaymentBreakdownCard extends StatelessWidget {
  final double baseAmount;
  final double fee;
  final double totalPayable;

  const PaymentBreakdownCard({
    super.key,
    required this.baseAmount,
    required this.fee,
    required this.totalPayable,
  });

  @override
  Widget build(BuildContext context) {
    return TransparentCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Payment Breakdown",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildRow(
            "Teleconsultation Amount:",
            "₹${baseAmount.toStringAsFixed(2)}",
          ),
          const SizedBox(height: 12),
          _buildRow(
            "Processing Fee:",
            fee == 0 ? "₹0.00 (Waived)" : "₹${fee.toStringAsFixed(2)}",
            isGreen: fee == 0,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Payable:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "₹${totalPayable.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isGreen ? Colors.green : Colors.black87,
          ),
        ),
      ],
    );
  }
}