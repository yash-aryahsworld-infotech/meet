import 'package:flutter/material.dart';
import 'dart:math' as math; // Required for max()

class SupportTabsToggle extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const SupportTabsToggle({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 1. Determine how wide the container NEEDS to be.
        // E.g., at least 100px per tab, or the full screen width, whichever is larger.
        const double minTabWidth = 100.0; 
        final double contentWidth = math.max(
          constraints.maxWidth, 
          tabs.length * minTabWidth
        );

        // 2. Sliding Pill Math (Works relative to contentWidth)
        final double alignStep = tabs.length > 1 ? 2.0 / (tabs.length - 1) : 0;
        final double alignmentX = -1.0 + (selectedIndex * alignStep);

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(), // Smooth bounce on mobile
          child: Container(
            width: contentWidth, // Forces the Stack to be wide enough
            height: 50,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // LAYER 1: The Sliding White Pill
                AnimatedAlign(
                  alignment: Alignment(alignmentX, 0),
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.fastOutSlowIn,
                  child: LayoutBuilder(
                    builder: (context, box) {
                      return Container(
                        // Width is exactly 1/Nth of the total contentWidth
                        width: box.maxWidth / tabs.length,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // LAYER 2: The Clickable Text Areas
                Row(
                  children: tabs.asMap().entries.map((e) {
                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => onSelected(e.key),
                        child: Container(
                          alignment: Alignment.center,
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              fontWeight: FontWeight.w600, // Constant weight = No Jiggle
                              fontSize: 14,
                              color: selectedIndex == e.key
                                  ? const Color(0xFF1F2937)
                                  : const Color(0xFF9CA3AF),
                            ),
                            child: Text(
                              e.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}