import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;

  /// Optional gradient colors
  final List<Color>? colors;

  /// Optional outline color
  final Color? outlineColor;

  /// Text color
  final Color textColor;

  /// Optional padding for the button
  final EdgeInsetsGeometry? buttonPadding;

  /// ⭐ NEW — optional width & height (default same as before)
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.colors,
    this.textColor = Colors.white,
    this.outlineColor,
    this.buttonPadding,
    this.width = double.infinity,        // NEW
    this.height = 50,  // NEW (DEFAULT SAME AS BEFORE)
  });

  @override
  Widget build(BuildContext context) {
    // Responsive font size for mobile
    final bool isMobile = AppResponsive.isMobile(context);
    final fontSize = isMobile ? 14.0 : 16.0;
    final iconSize = isMobile ? 18.0 : 20.0;

    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.numpadEnter): const ActivateIntent(),
      },

      child: Actions(
        actions: {
          ActivateIntent: CallbackAction(
            onInvoke: (intent) {
              onPressed();
              return null;
            },
          ),
        },

        child: SizedBox(
          width: width ?? double.infinity, // ⭐ DEFAULT same as before
          height: height ,                  // ⭐ DEFAULT = 50
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors ??
                    const [
                      Color(0xFF2196F3),
                      Color(0xFF1565C0),
                    ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              border: outlineColor != null
                  ? Border.all(color: outlineColor!, width: 2)
                  : null,
            ),

            child: ElevatedButton(
              onPressed: onPressed,
              style: ButtonStyle(
                elevation: const WidgetStatePropertyAll(0),
                backgroundColor:
                    const WidgetStatePropertyAll(Colors.transparent),
                shadowColor:
                    const WidgetStatePropertyAll(Colors.transparent),

                padding: buttonPadding != null
                    ? WidgetStatePropertyAll(buttonPadding)
                    : null,

                overlayColor: const WidgetStatePropertyAll(
                  Color.fromRGBO(255, 255, 255, 0.1),
                ),
              ),

              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: textColor, size: iconSize),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
