import 'package:flutter/material.dart';
import '../utils/app_responsive.dart'; // Ensure this matches your file structure

class TabToggle extends StatefulWidget {
  final List<String> options;
  final List<int>? counts;
  final int selectedIndex;
  final Function(int) onSelected;

  const TabToggle({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
    this.counts,
    // Removed fixed height parameter to allow auto-sizing
  });

  @override
  State<TabToggle> createState() => _TabToggleState();
}

class _TabToggleState extends State<TabToggle> {
  final List<double> _itemWidths = [];

  // Scroll handling
  final ScrollController _scrollController = ScrollController();
  bool _isOverflowing = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checkOverflow);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _checkOverflow() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final isOverflow = maxScroll > 5;
    final atEnd = _scrollController.offset >= maxScroll - 5;
    final shouldShowArrow = isOverflow && !atEnd;

    if (_isOverflowing != shouldShowArrow) {
      setState(() => _isOverflowing = shouldShowArrow);
    }
  }

  double _calculateLeftOffset(int index) {
    double left = 0;
    for (int i = 0; i < index; i++) {
      // Add item width + spacing between items
      left += (_itemWidths.length > i ? _itemWidths[i] : 0) + 
              (AppResponsive.spaceXS); 
    }
    return left;
  }

  @override
  Widget build(BuildContext context) {
    // 1. Responsive Styling
    final isMobile = AppResponsive.isMobile(context);
    final double responsiveFontSize = AppResponsive.fontSM(context);
    const double radius = AppResponsive.radiusMD;
    
    // Dynamic padding based on device size
    final double verticalPad = isMobile ? 8 : 10;
    final double horizontalPad = isMobile ? 16 : 20;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.centerRight,
          children: [
            // ---------------- MAIN TRACK ----------------
            Container(
              padding: const EdgeInsets.all(4), // Padding around the pill
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9), // Subtle Slate Grey
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: IntrinsicHeight( // Allows children to determine height
                  child: Stack(
                    children: [
                      // ---------------- ANIMATED PILL ----------------
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        left: _itemWidths.isNotEmpty
                            ? _calculateLeftOffset(widget.selectedIndex)
                            : 0,
                        width: _itemWidths.isNotEmpty && _itemWidths.length > widget.selectedIndex
                            ? _itemWidths[widget.selectedIndex]
                            : 0,
                        // Top and Bottom 0 makes it fill vertical space automatically
                        top: 0, 
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(radius - 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 1,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ---------------- TAB ITEMS ----------------
                      Row(
                        children: List.generate(widget.options.length, (index) {
                          final int? count = widget.counts != null &&
                                  widget.counts!.length > index
                              ? widget.counts![index]
                              : null;
                          final bool isSelected = widget.selectedIndex == index;

                          return Padding(
                            padding: const EdgeInsets.only(right: AppResponsive.spaceXS),
                            child: MeasureSize(
                              onChange: (size) {
                                if (_itemWidths.length <= index) {
                                  _itemWidths.add(size.width);
                                } else {
                                  _itemWidths[index] = size.width;
                                }
                                if (index == widget.options.length - 1) {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    _checkOverflow();
                                    if (mounted) setState(() {});
                                  });
                                }
                              },
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => widget.onSelected(index),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: horizontalPad,
                                    vertical: verticalPad,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        widget.options[index],
                                        style: TextStyle(
                                          fontSize: responsiveFontSize,
                                          fontWeight: isSelected 
                                              ? FontWeight.w600 
                                              : FontWeight.w500,
                                          color: isSelected
                                              ? const Color(0xFF0F172A) // Dark Slate
                                              : const Color(0xFF64748B), // Slate 500
                                        ),
                                      ),
                                      if (count != null && count > 0) ...[
                                        const SizedBox(width: 8),
                                        AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Colors.blue.shade600
                                                : Colors.grey.shade300,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            count.toString(),
                                            style: TextStyle(
                                              color: isSelected ? Colors.white : Colors.grey.shade700,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ---------------- SCROLL INDICATOR ARROW ----------------
            if (_isOverflowing)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.only(left: 16, right: 4),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(radius)),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFF1F5F9).withValues(alpha: 0.0),
                        const Color(0xFFF1F5F9),
                      ],
                    ),
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        _scrollController.animateTo(
                          _scrollController.offset + 100,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutQuad,
                        );
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.chevron_right,
                          size: 18,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

// -------- UTILITY: Measure child size --------
class MeasureSize extends StatefulWidget {
  final Widget child;
  final void Function(Size size) onChange;
  const MeasureSize({super.key, required this.child, required this.onChange});

  @override
  State<MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<MeasureSize> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final size = context.size!;
      widget.onChange(size);
    });
    return widget.child;
  }
}