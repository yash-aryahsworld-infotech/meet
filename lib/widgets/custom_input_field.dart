import 'package:flutter/material.dart';
import '../utils/app_responsive.dart';

class CustomInputField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final bool obscureText;
  final TextInputType inputType;
  final TextEditingController controller;
  final int maxLines;

  const CustomInputField({
    super.key,
    required this.labelText,
    required this.icon,
    this.obscureText = false,
    this.inputType = TextInputType.text,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    bool isMobile = AppResponsive.isMobile(context);
    bool isTablet = AppResponsive.isTablet(context);

    // ------------------------------
    // 📌 Smaller Font Sizes
    // ------------------------------
    double fieldFont = isMobile
        ? AppResponsive.fontSM(context)        // ~12 (mobile)
        : isTablet
            ? AppResponsive.fontSM(context)    // ~14 (tablet)
            : AppResponsive.fontMD(context);   // ~16 (desktop)

    double labelFont = isMobile
        ? AppResponsive.fontXS(context) - 1
        : isTablet
            ? AppResponsive.fontXS(context)
            : AppResponsive.fontSM(context);

    // ------------------------------
    // 📌 Smaller Icon Size
    // ------------------------------
    double iconSize = isMobile
        ? 18
        : isTablet
            ? 20
            : 22;

    // ------------------------------
    // 📌 Smaller Padding
    // ------------------------------
    EdgeInsets padding = EdgeInsets.symmetric(
      vertical: isMobile ? 8 : (isTablet ? 10 : 12),
      horizontal: isMobile ? 12 : (isTablet ? 14 : 16),
    );

    // ------------------------------
    // 📌 Border Radius
    // ------------------------------
    double radius = isMobile
        ? AppResponsive.radiusSM
        : isTablet
            ? AppResponsive.radiusMD
            : AppResponsive.radiusMD;

    return TextField(
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLines,
      keyboardType: inputType,

      style: TextStyle(
        fontSize: fieldFont,
        color: Colors.black87,
      ),

      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          size: iconSize,
          color: Colors.grey,
        ),

        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: labelFont,
          color: Colors.grey.shade700,
        ),

        contentPadding: padding,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(
            color: Colors.blueAccent,
            width: 1.2,
          ),
        ),
      ),
    );
  }
}
