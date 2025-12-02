import 'package:flutter/material.dart';
import '../../../widgets/custom_details.dart';
import './payment_section_card.dart';

/// ------------------------------------------------------------
/// COMPONENT 2: PENDING PAYMENTS
/// Implements the specific data and styling for "Pending Payments".
/// ------------------------------------------------------------
class PendingPaymentsComponent extends StatelessWidget {
  const PendingPaymentsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return PaymentSectionCard(
      title: "Pending Payments",
      subtitle: "Payments awaiting processing",
      children: [
        PaymentDetailRow(
          name: "Anita Patel",
          subtitle: "Audio Consultation • 13/01/2024",
          amount: "₹400",
          statusText: "pending",
          statusColor: const Color(0xFFF57F17),
          statusBgColor: const Color(0xFFFFF8E1),
          icon: const Icon(Icons.access_time, color: Color(0xFFF9A825)),
          iconBgColor: const Color(0xFFFFFDE7), // Lighter yellow
          actionWidget: _buildFollowUpButton(),
        ),
        PaymentDetailRow(
          name: "Vikram Singh",
          subtitle: "Video Consultation • 10/01/2024",
          amount: "₹600",
          statusText: "overdue",
          statusColor: const Color(0xFFC62828),
          statusBgColor: const Color(0xFFFFEBEE),
          icon: const Icon(Icons.access_time, color: Color(0xFFF9A825)),
          iconBgColor: const Color(0xFFFFFDE7),
          actionWidget: _buildFollowUpButton(),
        ),
      ],
    );
  }

  Widget _buildFollowUpButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: const Text("Follow Up"),
    );
  }
}