import 'package:flutter/material.dart';
import '../../../utils/app_responsive.dart';

class EarningsStatCard extends StatelessWidget {
  final String title;               // e.g., "Total Earnings"
  final IconData? icon;             // top-right icon (optional)
  final String amount;              // e.g., "₹0"
  final String? subtext;            // e.g., "From 0 consultations"
  final String? percentageChange;   // e.g., "+12% from last month"
  final bool positive;              // green if true, red if false (optional)

  const EarningsStatCard({
    super.key,
    required this.title,
    this.icon,
    required this.amount,
    this.subtext,
    this.percentageChange,
    this.positive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.radiusMD),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Icon Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: AppResponsive.fontMD(context),
                  fontWeight: AppResponsive.semiBold,
                ),
              ),
              if (icon != null)
                Icon(
                  icon,
                  size: 20,
                  color: Colors.grey[600],
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Amount
          Text(
            amount,
            style: TextStyle(
              fontSize: AppResponsive.fontXL(context),
              fontWeight: AppResponsive.bold,
            ),
          ),

          const SizedBox(height: 6),

          // Subtext (optional)
          if (subtext != null)
            Text(
              subtext!,
              style: TextStyle(
                fontSize: AppResponsive.fontSM(context),
                color: Colors.grey[700],
              ),
            ),

          // Percentage change (optional)
          if (percentageChange != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                percentageChange!,
                style: TextStyle(
                  fontSize: AppResponsive.fontSM(context),
                  color: positive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
