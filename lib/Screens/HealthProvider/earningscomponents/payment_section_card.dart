import 'package:flutter/material.dart';
import '../../../utils/app_responsive.dart';

/// ------------------------------------------------------------
/// WRAPPER: SECTION CARD
/// A generic card that provides the white background, title, and subtitle for a list.
/// ------------------------------------------------------------
class PaymentSectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const PaymentSectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppResponsive.spaceLG),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.radiusLG),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: AppResponsive.fontLG(context),
              fontWeight: AppResponsive.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: AppResponsive.spaceXS),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: AppResponsive.fontSM(context),
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: AppResponsive.spaceLG),
          ...children,
        ],
      ),
    );
  }
}