import 'package:flutter/material.dart';
import 'dart:math' as math;

class SupportTabsToggle extends StatefulWidget {
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
  State<SupportTabsToggle> createState() => _SupportTabsToggleState();
}

class _SupportTabsToggleState extends State<SupportTabsToggle> {
  // Track if we need to show the fade
  bool _showRightFade = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 1. Calculate Widths
        const double minTabWidth = 100.0;
        final double contentWidth = math.max(
          constraints.maxWidth,
          widget.tabs.length * minTabWidth,
        );
        
        // 2. Determine if content is actually wider than screen (to enable/disable fade logic)
        final bool isScrollable = contentWidth > constraints.maxWidth;

        // 3. Sliding Pill Math
        final double alignStep = widget.tabs.length > 1 ? 2.0 / (widget.tabs.length - 1) : 0;
        final double alignmentX = -1.0 + (widget.selectedIndex * alignStep);

        return Container(
          height: 50,
          clipBehavior: Clip.antiAlias, // Ensures gradient doesn't bleed out
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              // LAYER A: Scrollable Content
              NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  // Logic: If there is content remaining to the right (extentAfter), show fade
                  final shouldShow = scrollInfo.metrics.extentAfter > 10;
                  if (shouldShow != _showRightFade) {
                    setState(() => _showRightFade = shouldShow);
                  }
                  return true;
                },
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    width: contentWidth,
                    padding: const EdgeInsets.all(4),
                    child: Stack(
                      children: [
                        // 1. The Sliding White Pill
                        AnimatedAlign(
                          alignment: Alignment(alignmentX, 0),
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.fastOutSlowIn,
                          child: LayoutBuilder(
                            builder: (context, box) {
                              return Container(
                                width: box.maxWidth / widget.tabs.length,
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

                        // 2. The Text Buttons
                        Row(
                          children: widget.tabs.asMap().entries.map((e) {
                            return Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () => widget.onSelected(e.key),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 200),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: widget.selectedIndex == e.key
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
                ),
              ),

              // LAYER B: The Fade Gradient (Visual Hint)
              // Only shows if scrolling is possible AND we aren't at the end
              if (isScrollable && _showRightFade)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: 40, // Width of the fade
                  child: IgnorePointer( // Allows clicking "through" the fade
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            const Color(0xFFF3F4F6), // Matches BG color (Solid)
                            const Color(0xFFF3F4F6).withOpacity(0.0), // Transparent
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                
               // Optional: A tiny arrow icon on top of the gradient for extra clarity
               if (isScrollable && _showRightFade)
                 const Positioned(
                   right: 8,
                   top: 0,
                   bottom: 0,
                   child: IgnorePointer(
                     child: Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                   ),
                 )
            ],
          ),
        );
      },
    );
  }
}