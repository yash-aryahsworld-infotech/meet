import 'package:flutter/material.dart';

class CustomToggleSwitch extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final Function(int) onSelected;
  final double height;
  final double fontSize;

  const CustomToggleSwitch({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
    this.height = 45,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.8;
    final double segmentWidth = width / options.length;

    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // 🔹 Animated background indicator
          AnimatedAlign(
            alignment: Alignment(
              (selectedIndex / (options.length - 1)) * 2 - 1, // Dynamic positioning
              0,
            ),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            child: Container(
              width: segmentWidth - 8,
              height: height - 8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),

          // 🔹 Full clickable segments
          Row(
            children: List.generate(options.length, (index) {
              final bool isSelected = selectedIndex == index;
              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () => onSelected(index),
                  child: Container(
                    alignment: Alignment.center,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.grey.shade600,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        fontSize: fontSize,
                      ),
                      child: Text(options[index]),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
