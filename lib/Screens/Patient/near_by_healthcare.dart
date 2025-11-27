import 'package:flutter/material.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';
import 'package:healthcare_plus/widgets/custom_provider_card.dart';
import './near_by_health_provider.dart/nearby_healthcare_filters.dart';
class NearbyHealthcare extends StatefulWidget {
  const NearbyHealthcare({super.key});

  @override
  State<NearbyHealthcare> createState() => _NearbyHealthcareState();
}

class _NearbyHealthcareState extends State<NearbyHealthcare> {
  // Search & Filters
  String searchQuery = "";
  String selectedHealthcareType = "All Types";
  String selectedRating = "Any Rating";
  String selectedDistance = "Any Distance";
  String selectedSort = "Distance (Nearest)";

  // Responsive text helper
  double rs(BuildContext context, double mobile, double tablet, double desktop) {
    if (AppResponsive.isMobile(context)) return mobile;
    if (AppResponsive.isTablet(context)) return tablet;
    return desktop;
  }

  // Healthcare Types
  final List<String> healthcareTypes = ["All Types", "Hospital", "Clinic", "Lab"];
  final List<String> ratings = ["Any Rating", "4.5+", "4.0+", "3.5+"];
  final List<String> distances = ["Any Distance", "1 km", "3 km", "5 km"];
  final List<String> sortOptions = ["Distance (Nearest)", "Rating (High to Low)", "Rating (Low to High)"];

  // Provider Data
  final List<Map<String, dynamic>> providers = [
    {
      "name": "Lilavati Hospital",
      "rating": 4.3,
      "type": "Hospital",
      "distance": "2.5 km",
      "tags": ["Emergency", "Cardiology"],
    },
    {
      "name": "Apollo Clinic Bandra",
      "rating": 4.1,
      "type": "Clinic",
      "distance": "1.2 km",
      "tags": ["General Medicine", "Pediatrics"],
    },
    {
      "name": "Dr. Lal PathLabs",
      "rating": 4.0,
      "type": "Lab",
      "distance": "800 m",
      "tags": ["Blood Tests", "Diagnostics"],
    },
    {
      "name": "Nanavati Max Hospital",
      "rating": 4.4,
      "type": "Hospital",
      "distance": "3.1 km",
      "tags": ["Cancer Care", "Neurology"],
    },
    {
      "name": "Suburban Diagnostics",
      "rating": 4.2,
      "type": "Lab",
      "distance": "1.8 km",
      "tags": ["Diagnostics", "X-Ray", "MRI"],
    },
  ];

  @override
  Widget build(BuildContext context) {
    // 1. Determine columns based on screen size
    int columns = AppResponsive.isMobile(context)
        ? 1
        : AppResponsive.isTablet(context)
            ? 2
            : 3;

    double spacing = 20;

    // 2. Filter Logic
    List<Map<String, dynamic>> filteredProviders = providers.where((p) {
      final search = searchQuery.toLowerCase();
      final matchesSearch = p["name"].toString().toLowerCase().contains(search) ||
          p["type"].toString().toLowerCase().contains(search) ||
          p["tags"].toString().toLowerCase().contains(search);

      final typeMatch = selectedHealthcareType == "All Types" ? true : p["type"] == selectedHealthcareType;
      
      final ratingMatch = selectedRating == "Any Rating"
          ? true
          : p["rating"] >= double.parse(selectedRating.replaceAll("+", ""));

      return matchesSearch && typeMatch && ratingMatch;
    }).toList();

    return Material(
      color: const Color(0xFFF7FBFF),
      child: Padding(
        padding: EdgeInsets.all(0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.blue, size: 26),
                  const SizedBox(width: 8),
                  Text(
                    "Nearby Healthcare Providers",
                    style: TextStyle(
                      fontSize: rs(context, 20, 20, 20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                "Find trusted hospitals, clinics, and labs near you",
                style: TextStyle(fontSize: rs(context, 12, 14, 16), color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),

              // SEARCH BAR
              TextField(
                onChanged: (value) => setState(() => searchQuery = value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search by name, specialty or service...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // FILTERS
              NearbyHealthcareFilters(
                selectedSpecialty: selectedHealthcareType,
                selectedRating: selectedRating,
                selectedDistance: selectedDistance,
                selectedSort: selectedSort,
                specialties: healthcareTypes,
                ratings: ratings,
                distances: distances,
                sortOptions: sortOptions,
                onSpecialtyChanged: (val) => setState(() => selectedHealthcareType = val),
                onRatingChanged: (val) => setState(() => selectedRating = val),
                onDistanceChanged: (val) => setState(() => selectedDistance = val),
                onSortChanged: (val) => setState(() => selectedSort = val),
              ),

              const SizedBox(height: 30),

              // REPLACEMENT FOR GRIDVIEW: Custom Column of Rows
              if (filteredProviders.isEmpty)
                const Center(child: Text("No providers found"))
              else
                Column(
                  children: _buildGridRows(filteredProviders, columns, spacing),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // HELPER METHOD TO CREATE ROWS manually
  List<Widget> _buildGridRows(List<Map<String, dynamic>> data, int columns, double spacing) {
    List<Widget> rows = [];
    
    for (int i = 0; i < data.length; i += columns) {
      // Get a chunk of data for this row
      List<Map<String, dynamic>> chunk = data.sublist(
        i,
        (i + columns > data.length) ? data.length : i + columns,
      );

      List<Widget> rowChildren = [];

      for (var item in chunk) {
        // Add the card inside Expanded so it splits width equally
        rowChildren.add(
          Expanded(
            child: ProviderCard(data: item),
          ),
        );
        // Add spacing after card
        rowChildren.add(SizedBox(width: spacing));
      }

      // If the row is not full (e.g. 2 items in a 3-column layout), fill with empty Expanded widgets
      while (rowChildren.length < columns * 2) { 
        rowChildren.add(const Expanded(child: SizedBox()));
        rowChildren.add(SizedBox(width: spacing));
      }

      // Remove the last extra spacing
      if (rowChildren.isNotEmpty) rowChildren.removeLast();

      // IntrinsicHeight ensures all cards in this row are the same height (important for Spacer to work)
      rows.add(IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: rowChildren,
        ),
      ));

      // Vertical spacing between rows
      rows.add(SizedBox(height: spacing));
    }
    
    return rows;
  }
}