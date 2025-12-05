import 'package:flutter/material.dart';

class PaymentDetailRow extends StatelessWidget {
  final String name;
  final String subtitle;
  final String amount;
  final String statusText;
  final Color statusColor;
  final Color statusBgColor;
  final Widget icon;
  final Color iconBgColor;
  final Widget actionWidget;

  const PaymentDetailRow({
    super.key,
    required this.name,
    required this.subtitle,
    required this.amount,
    required this.statusText,
    required this.statusColor,
    required this.statusBgColor,
    required this.icon,
    required this.iconBgColor,
    required this.actionWidget,
  });

  @override
  Widget build(BuildContext context) {
    // Check responsive condition
    final bool isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      margin: const EdgeInsets.only(bottom: 16), // Standard spacing
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isMobile
          ? _buildMobileLayout(context)
          : _buildWebLayout(context),
    );
  }

  // 📱 MOBILE LAYOUT (Matches your uploaded image)
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        // ROW 1: User Details (Icon + Name/Subtitle)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIconBox(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),

        // Divider spacing
        const SizedBox(height: 16),

        // ROW 2: Financials + Action Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Side: Amount + Status Badge
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),

            // Right Side: The Button (Follow Up / Eye)
            actionWidget,
          ],
        ),
      ],
    );
  }

  // 🖥️ WEB LAYOUT (Your original single-row design)
  Widget _buildWebLayout(BuildContext context) {
    return Row(
      children: [
        _buildIconBox(),
        const SizedBox(width: 16),

        // Name & Subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // Amount & Status
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amount,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: statusBgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(width: 24),

        // Action Widget
        actionWidget,
      ],
    );
  }

  // Helper for the Icon Box
  Widget _buildIconBox() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: iconBgColor,
        shape: BoxShape.circle,
      ),
      child: Center(child: icon),
    );
  }
}