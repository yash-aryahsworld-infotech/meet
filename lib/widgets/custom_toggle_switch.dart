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

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth; // Parent width (card or screen)

        // 🔹 Define widths per device type

    double width = maxWidth * 0.85;

    // if (isMobile) {
    //   width = maxWidth * 0.85; // 85% width for mobile
    // } else if (isTablet) {
    //   width = maxWidth * 0.85; // 50% width for tablet
    // } else {
    //   width = maxWidth * 0.85; // 40% width for desktop/web
    // }
        // Prevent width exceeding parent (important for cards)
        if (width > maxWidth) width = maxWidth * 0.9;

        final double adjustedFontSize = (fontSize);
        final double segmentWidth = width / options.length;

        return Center(
          child: Container(
            height: height,
            width: width,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F1F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 🔹 Animated background indicator
                AnimatedAlign(
                  alignment: Alignment(
                    (selectedIndex / (options.length - 1)) * 2 - 1,
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
                          color: Colors.grey.withAlpha(77),
                          blurRadius: 6,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),

                // 🔹 Clickable Text Segments
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
                              color: isSelected
                                  ? Colors.black
                                  : Colors.grey.shade600,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              fontSize: adjustedFontSize,
                            ),
                            child: Text(
                              options[index],
                              textAlign: TextAlign.center,
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
