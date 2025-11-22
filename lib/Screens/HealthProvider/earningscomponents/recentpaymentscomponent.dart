import 'package:flutter/material.dart';
import '../../../widgets/custom_details.dart';
import './payment_section_card.dart';

/// ------------------------------------------------------------
/// COMPONENT 1: RECENT PAYMENTS
/// Implements the specific data and styling for "Recent Payments".
/// ------------------------------------------------------------
class RecentPaymentsComponent extends StatelessWidget {
  const RecentPaymentsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return PaymentSectionCard(
      title: "Recent Payments",
      subtitle: "Your latest payment transactions",
      children: [
        PaymentDetailRow(
          name: "Priya Sharma",
          subtitle: "Video Consultation • 15/01/2024",
          amount: "₹500",
          statusText: "paid",
          statusColor: const Color(0xFF1E8E3E),
          statusBgColor: const Color(0xFFE6F4EA),
          icon: const Icon(Icons.credit_card, color: Color(0xFF1976D2)),
          iconBgColor: const Color(0xFFE3F2FD),
          actionWidget: _buildEyeButton(),
        ),
        PaymentDetailRow(
          name: "Rahul Kumar",
          subtitle: "In-Person Consultation • 14/01/2024",
          amount: "₹750",
          statusText: "paid",
          statusColor: const Color(0xFF1E8E3E),
          statusBgColor: const Color(0xFFE6F4EA),
          icon: const Icon(Icons.credit_card, color: Color(0xFF1976D2)),
          iconBgColor: const Color(0xFFE3F2FD),
          actionWidget: _buildEyeButton(),
        ),
        PaymentDetailRow(
          name: "Anita Patel",
          subtitle: "Audio Consultation • 13/01/2024",
          amount: "₹400",
          statusText: "pending",
          statusColor: const Color(0xFFF57F17),
          statusBgColor: const Color(0xFFFFF8E1),
          icon: const Icon(Icons.credit_card, color: Color(0xFF1976D2)),
          iconBgColor: const Color(0xFFE3F2FD),
          actionWidget: _buildEyeButton(),
        ),
        PaymentDetailRow(
          name: "Vikram Singh",
          subtitle: "Video Consultation • 10/01/2024",
          amount: "₹600",
          statusText: "overdue",
          statusColor: const Color(0xFFC62828),
          statusBgColor: const Color(0xFFFFEBEE),
          icon: const Icon(Icons.credit_card, color: Color(0xFF1976D2)),
          iconBgColor: const Color(0xFFE3F2FD),
          actionWidget: _buildEyeButton(),
        ),
      ],
    );
  }

  Widget _buildEyeButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.visibility_outlined,
          size: 20, color: Colors.black54),
    );
  }
}