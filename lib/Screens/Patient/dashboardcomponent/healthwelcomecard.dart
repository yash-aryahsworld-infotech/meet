import 'package:flutter/material.dart';
import '../../../utils/app_responsive.dart';

class HealthWelcomeCard extends StatelessWidget {
  const HealthWelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine responsive styles based on your AppResponsive class
    final bool isDesktop = AppResponsive.isDesktop(context);
    final bool isMobile = AppResponsive.isMobile(context);

    return Container(
      width: double.infinity,
      // Add responsive padding inside the card
      padding: EdgeInsets.all(isDesktop ? AppResponsive.spaceLG : AppResponsive.spaceMD),
      decoration: BoxDecoration(
        // The gradient blue background from the image
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1565C0), // Darker Blue (Left)
            Color(0xFF42A5F5), // Lighter Blue (Right)
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(AppResponsive.radiusMD),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // LEFT SIDE: Welcome Text & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title Row
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "Welcome back, Pramod !",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppResponsive.fontLG(context), // Responsive Font
                        fontWeight: AppResponsive.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "👋",
                      style: TextStyle(
                        fontSize: AppResponsive.fontLG(context),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 4 : 8),
                // Subtitle with Hindi text
                Text(
                  "Your health journey continues with Mirai Health - स्वास्थ्य आपका, देखभाल हमारी",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: AppResponsive.fontSM(context), // Responsive Font
                    fontWeight: AppResponsive.regular,
                    height: 1.4, // Better line height for readability
                  ),
                ),
              ],
            ),
          ),

          // Gap between text and score
          SizedBox(width: isMobile ? 12 : 32),

          // RIGHT SIDE: Health Score
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Health Score",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: AppResponsive.fontXS(context),
                  fontWeight: AppResponsive.medium,
                ),
              ),
              // The Score Row (100 /100)
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "100",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isDesktop ? 36 : 28, // Custom large size for score
                      fontWeight: AppResponsive.bold,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    " /100",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: AppResponsive.fontSM(context),
                      fontWeight: AppResponsive.medium,
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}