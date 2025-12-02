import 'package:flutter/material.dart';

class NearbyHealthcareFilters extends StatelessWidget {
  final String selectedSpecialty;
  final String selectedRating;
  final String selectedDistance;
  final String selectedSort;

  final List<String> specialties;
  final List<String> ratings;
  final List<String> distances;
  final List<String> sortOptions;

  final Function(String) onSpecialtyChanged;
  final Function(String) onRatingChanged;
  final Function(String) onDistanceChanged;
  final Function(String) onSortChanged;

  const NearbyHealthcareFilters({
    super.key,
    required this.selectedSpecialty,
    required this.selectedRating,
    required this.selectedDistance,
    required this.selectedSort,
    required this.specialties,
    required this.ratings,
    required this.distances,
    required this.sortOptions,
    required this.onSpecialtyChanged,
    required this.onRatingChanged,
    required this.onDistanceChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Breakpoint for switching from Row to Column
          bool isMobile = constraints.maxWidth < 800; 

          return isMobile
              ? Column(
                  children: _filterWidgets(isMobile),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _filterWidgets(isMobile),
                );
        },
      ),
    );
  }

  // ---------- Widgets List ----------
  List<Widget> _filterWidgets(bool isMobile) {
    // Helper to wrap widgets based on layout
    Widget responsiveWrapper(Widget child) {
      if (isMobile) {
        // In Column: Take full width
        return SizedBox(width: double.infinity, child: child);
      } else {
        // In Row: Share width equally
        return Expanded(child: child);
      }
    }

    return [
      responsiveWrapper(
        _buildDropdown(
          label: "Specialty",
          value: selectedSpecialty,
          items: specialties,
          onChanged: onSpecialtyChanged,
        ),
      ),
      
      gap(isMobile),

      responsiveWrapper(
        _buildDropdown(
          label: "Minimum Rating",
          value: selectedRating,
          items: ratings,
          onChanged: onRatingChanged,
        ),
      ),

      gap(isMobile),

      responsiveWrapper(
        _buildDropdown(
          label: "Max Distance",
          value: selectedDistance,
          items: distances,
          onChanged: onDistanceChanged,
        ),
      ),

      gap(isMobile),

      responsiveWrapper(
        _buildDropdown(
          label: "Sort By",
          value: selectedSort,
          items: sortOptions,
          onChanged: onSortChanged,
        ),
      ),
    ];
  }

  // Gap between filters
  Widget gap(bool isMobile) =>
      isMobile ? const SizedBox(height: 16) : const SizedBox(width: 20);

  // ---------- Dropdown Builder ----------
  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),

        // Dropdown Box
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline( // Added HideUnderline for cleaner look
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: items
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ))
                  .toList(),
              onChanged: (val) => onChanged(val!),
            ),
          ),
        ),
      ],
    );
  }
}