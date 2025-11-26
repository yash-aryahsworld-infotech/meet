import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// MODELS
// ---------------------------------------------------------------------------

class FaqCategory {
  final String id;
  final String title;
  final IconData icon;

  FaqCategory(this.id, this.title, this.icon);
}

class FaqItem {
  final String question;
  final String answer;
  final List<String> categories; // e.g., ["Account & Profile", "Security"]
  final List<String> tags;       // Optional: for the pills inside the answer
  final int helpfulCount;        // Optional: for the "89 people found helpful"

  FaqItem({
    required this.question,
    required this.answer,
    required this.categories,
    this.tags = const [],
    this.helpfulCount = 0,
  });
}


class FaqSection extends StatefulWidget {
  final List<FaqItem> items;
  final List<FaqCategory> categories;

  const FaqSection({
    super.key,
    required this.items,
    required this.categories,
  });

  @override
  State<FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<FaqSection> {
  // We filter by Category Title (String) because FaqItem uses List<String>
  String _selectedCategoryTitle = "All Topics"; 
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  // Color Palette
  final Color _primaryBlue = const Color(0xFF1665D8);
  final Color _bgGrey = const Color(0xFFF7F9FC);
  final Color _borderGrey = const Color(0xFFE4E9F2);
  final Color _textDark = const Color(0xFF2E3A59);
  final Color _textLight = const Color(0xFF8F9BB3);

  @override
  Widget build(BuildContext context) {
    
    // 1. FILTER LOGIC
    final filteredItems = widget.items.where((item) {
      // Category Match: Check if item's category list contains the selected title
      final matchesCategory = _selectedCategoryTitle == "All Topics" ||
          item.categories.contains(_selectedCategoryTitle);

      // Search Match
      final matchesSearch =
          item.question.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();

    // 2. LAYOUT
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWideScreen = constraints.maxWidth > 600;

        return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- TOP SEARCH & TABS SECTION ---
                _buildSearchAndCategoriesCard(isWideScreen),

                const SizedBox(height: 20),

                // --- FAQ LIST SECTION ---
                _buildFaqListCard(filteredItems),
              ],
            ),

        );
      },
    );
  }

  Widget _buildSearchAndCategoriesCard(bool isWideScreen) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderGrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: "Search frequently asked questions...",
              hintStyle: TextStyle(color: _textLight, fontSize: 14),
              prefixIcon: Icon(Icons.search, color: _textLight),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: _borderGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: _primaryBlue),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Horizontal Categories
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildCategoryChip("all", "All Topics", Icons.help_outline),
              ...widget.categories.map((cat) =>
                  _buildCategoryChip(cat.id, cat.title, cat.icon)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String id, String label, IconData icon) {
    final isSelected = _selectedCategoryTitle == label;
    
    return InkWell(
      onTap: () => setState(() => _selectedCategoryTitle = label),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? _primaryBlue : _borderGrey,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : _textLight,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : _textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqListCard(List<FaqItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Frequently Asked Questions",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${items.length} questions found",
                  style: TextStyle(fontSize: 13, color: _textLight),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),

          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                  child: Text("No questions found matching criteria.",
                      style: TextStyle(color: _textLight))),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (c, i) => Divider(
                height: 1,
                thickness: 1,
                color: _borderGrey.withOpacity(0.5),
              ),
              itemBuilder: (context, index) {
                return _buildExpansionTile(items[index]);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile(FaqItem item) {
    return Theme(
      // Removes the default top/bottom borders of ExpansionTile
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        title: Text(
          item.question,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: _textDark,
          ),
        ),
        subtitle: item.categories.isNotEmpty 
          ? Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(item.categories.join(", "), style: TextStyle(fontSize: 11, color: _textLight)),
            )
          : null,
        iconColor: _textLight,
        collapsedIconColor: _textLight,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.answer,
                  style: TextStyle(
                      fontSize: 14, height: 1.6, color: _textLight),
                ),
                
                // Tags Row (Pills)
                if (item.tags.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: item.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _bgGrey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _textLight,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],

                // Helpful Check
                if (item.helpfulCount > 0) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          size: 16, color: _textLight),
                      const SizedBox(width: 6),
                      Text(
                        "${item.helpfulCount} people found this helpful",
                        style: TextStyle(
                            fontSize: 12,
                            color: _textLight,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}