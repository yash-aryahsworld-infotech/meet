import 'package:flutter/material.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';
class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onTap;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.bgColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final bool isMobile = AppResponsive.isMobile(context);
    final bool isTablet = AppResponsive.isTablet(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 10 : 14,
          horizontal: 4,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: isMobile
                  ? 20
                  : isTablet
                      ? 26
                      : 30,
              color: textColor,
            ),

            const SizedBox(height: 10),

            Text(
              title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isMobile
                    ? 10
                    : isTablet
                        ? 13
                        : 14,
                color: textColor,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
