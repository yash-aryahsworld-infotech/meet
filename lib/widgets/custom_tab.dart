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
  // Store button widths for sliding pill
  final List<double> _itemWidths = [];

  double _calculateLeftOffset(int index) {
    double left = 0;
    for (int i = 0; i < index; i++) {
      left += _itemWidths[i] + 8; // + margin
    }
    return left;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final double adjustedFontSize = responsive.scale(widget.fontSize);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(14),
          ),
          child: SingleChildScrollView(
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
                          if (_itemWidths.length < widget.options.length) {
                            _itemWidths.add(size.width);
                          } else {
                            _itemWidths[index] = size.width;
                          }
                          setState(() {});
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
                                      borderRadius: BorderRadius.circular(12),
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
      final size = context.size!;
      widget.onChange(size);
    });
    return widget.child;
  }
}
