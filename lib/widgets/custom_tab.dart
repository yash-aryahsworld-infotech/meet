import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class TabToggle extends StatefulWidget {
  final List<String> options;
  final List<int>? counts;
  final int selectedIndex;
  final Function(int) onSelected;
  final double height;
  final double fontSize;

  const TabToggle({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
    this.counts,
    this.height = 45,
    this.fontSize = 14,
  });

  @override
  State<TabToggle> createState() => _TabToggleState();
}

class _TabToggleState extends State<TabToggle> {
  final List<double> _itemWidths = [];

  // Scroll and overflow handling
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
    // Simple check: if maxScroll > 5, we have overflow content
    final isOverflow = maxScroll > 5;

    // Logic: Hide arrow if we are AT the end
    final atEnd = _scrollController.offset >= maxScroll - 5;

    // Show arrow if we have overflow AND we are not at the very end
    final shouldShowArrow = isOverflow && !atEnd;

    if (_isOverflowing != shouldShowArrow) {
      setState(() {
        _isOverflowing = shouldShowArrow;
      });
    }
  }

  double _calculateLeftOffset(int index) {
    double left = 0;
    for (int i = 0; i < index; i++) {
      left += _itemWidths[i] + 8; // space between tabs
    }
    return left;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    double adjustedFontSize;

    if (responsive.isDesktop) {
      adjustedFontSize = widget.fontSize + 2;
    } else if (responsive.isTablet) {
      adjustedFontSize = widget.fontSize + 1;
    } else {
      adjustedFontSize = widget.fontSize;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.centerRight,
          children: [
            // MAIN CONTAINER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(14),
              ),
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Stack(
                  children: [
                    // ---------------- SLIDING ANIMATED PILL ----------------
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOut,
                      left: _itemWidths.isNotEmpty
                          ? _calculateLeftOffset(widget.selectedIndex)
                          : 0,
                      top: 0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOut,
                        height: widget.height - 2,
                        width: _itemWidths.isNotEmpty
                            ? _itemWidths[widget.selectedIndex]
                            : 0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(18),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ---------------- FOREGROUND TABS ----------------
                    Row(
                      children: List.generate(widget.options.length, (index) {
                        final int? count = widget.counts != null &&
                            widget.counts!.length > index
                            ? widget.counts![index]
                            : null;

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: MeasureSize(
                            onChange: (size) {
                              // Add width safely
                              if (_itemWidths.length <= index) {
                                _itemWidths.add(size.width);
                              } else {
                                _itemWidths[index] = size.width;
                              }

                              // Trigger a check after layout
                              if (index == widget.options.length - 1) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  _checkOverflow();
                                  setState(() {});
                                });
                              }
                            },
                            child: GestureDetector(
                              onTap: () => widget.onSelected(index),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    Text(
                                      widget.options[index],
                                      style: TextStyle(
                                        fontSize: adjustedFontSize,
                                        fontWeight: FontWeight.w600,
                                        color: widget.selectedIndex == index
                                            ? Colors.black
                                            : Colors.grey.shade700,
                                      ),
                                    ),
                                    if (count != null && count > 0) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: widget.selectedIndex == index
                                              ? Colors.blue
                                              : Colors.grey.shade600,
                                          borderRadius:
                                          BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          count.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
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

            // ---------------- RIGHT ARROW BUTTON (NEW DESIGN) ----------------
            if (_isOverflowing)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.only(left: 24, right: 6),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(14)),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.grey.shade200.withOpacity(0.0),
                        Colors.grey.shade200,
                      ],
                    ),
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        _scrollController.animateTo(
                          _scrollController.offset + 120,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutQuad,
                        );
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.chevron_right,
                          size: 20,
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

// -------- UTILITY: Measure child size for pill animation --------
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