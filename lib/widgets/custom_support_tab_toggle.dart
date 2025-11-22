import 'package:flutter/material.dart';

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
  // 1. Controller to track scroll position
  final ScrollController _scrollController = ScrollController();
  bool _showRightArrow = false;

  @override
  void initState() {
    super.initState();
    // Listen to scroll changes
    _scrollController.addListener(_checkScrollability);

    // Check initially after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkScrollability());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Logic to hide arrow if we reach the end of the list
  void _checkScrollability() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // Show arrow only if there is more content to the right
    final canScroll = maxScroll > 0 && currentScroll < (maxScroll - 5);

    if (_showRightArrow != canScroll) {
      setState(() => _showRightArrow = canScroll);
    }
  }

  // Helper to scroll forward when arrow is clicked
  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 120, // Scroll by 120px
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWideScreen = constraints.maxWidth > 700;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FB),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(6),
          child: isWideScreen
              ? _buildWideLayout()
              : _buildMobileLayout(), // Mobile with Arrow logic
        );
      },
    );
  }

  Widget _buildWideLayout() {
    return Row(
      children: List.generate(widget.tabs.length, (index) {
        return Expanded(
          child: _buildTabItem(index, isExpanded: true),
        );
      }),
    );
  }

  // ⭐ UPDATED MOBILE LAYOUT WITH ARROW
  Widget _buildMobileLayout() {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        // The Scrollable List
        SingleChildScrollView(
          controller: _scrollController, // Attach controller
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.tabs.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 4),
                child: _buildTabItem(index, isExpanded: false),
              );
            }),
          ),
        ),

        // The Floating Right Arrow
        if (_showRightArrow)
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: _scrollRight,
              child: Container(
                // Add a fade gradient so text doesn't cut off abruptly
                padding: const EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      const Color(0xFFF8F9FB), // Matches background
                      const Color(0xFFF8F9FB).withOpacity(0.0), // Transparent
                    ],
                  ),
                ),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF6B7280),
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTabItem(int index, {required bool isExpanded}) {
    final isSelected = index == widget.selectedIndex;

    return GestureDetector(
      onTap: () => widget.onSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        alignment: Alignment.center,
        padding: isExpanded
            ? const EdgeInsets.symmetric(vertical: 12)
            : const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 1),
            )
          ]
              : [],
        ),
        child: Text(
          widget.tabs[index],
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? const Color(0xFF1A1A1A) : const Color(0xFF6B7280),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}