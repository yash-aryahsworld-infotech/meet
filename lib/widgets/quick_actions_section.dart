import 'package:flutter/material.dart';
import '../utils/app_responsive.dart';

class QuickActionsSection extends StatefulWidget {
  const QuickActionsSection({super.key});

  @override
  State<QuickActionsSection> createState() => _QuickActionsSectionState();
}

class _QuickActionsSectionState extends State<QuickActionsSection> {
  bool hovered1 = false, pressed1 = false;
  bool hovered2 = false, pressed2 = false;
  bool hovered3 = false, pressed3 = false;

  bool get isMobile {
    final platform = Theme.of(context).platform;
    return platform == TargetPlatform.android ||
        platform == TargetPlatform.iOS;
  }

  /// BUTTON WIDGET
  Widget actionButton(
    String title,
    IconData icon,
    bool hovered,
    bool pressed,
    Function(bool) onHover,
    Function(bool) onPressed,
  ) {
    return MouseRegion(
      onEnter: (_) {
        if (!isMobile) onHover(true);
      },
      onExit: (_) {
        if (!isMobile) onHover(false);
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: pressed ? 0.94 : 1.0,      // Press animation

        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppResponsive.radiusMD),
            color: (hovered || pressed) ? Colors.cyan.shade100 : Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: pressed
                ? []      // Remove shadow when pressed
                : const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
          ),

          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppResponsive.radiusMD),

              // Mobile / touch press animation
              onTapDown: (_) => onPressed(true),
              onTapUp: (_) => onPressed(false),
              onTapCancel: () => onPressed(false),

              onTap: () {
                print("$title clicked");
              },

              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 12),
                child: Row(
                  children: [
                    Icon(icon, color: Colors.black87),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// MAIN UI
  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppResponsive.isMobile(context) ? double.infinity : 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.radiusLG),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Quick Actions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          actionButton(
            "Block Time Slots",
            Icons.calendar_month,
            hovered1,
            pressed1,
            (v) => setState(() => hovered1 = v),
            (v) => setState(() => pressed1 = v),
          ),

          actionButton(
            "Patient Records",
            Icons.people_alt_outlined,
            hovered2,
            pressed2,
            (v) => setState(() => hovered2 = v),
            (v) => setState(() => pressed2 = v),
          ),

          actionButton(
            "Messages",
            Icons.message_outlined,
            hovered3,
            pressed3,
            (v) => setState(() => hovered3 = v),
            (v) => setState(() => pressed3 = v),
          ),
        ],
      ),
    );
  }
}
