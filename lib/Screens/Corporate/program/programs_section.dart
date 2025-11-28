import 'package:flutter/material.dart';
import './program_card.dart';

class ProgramsSection extends StatefulWidget {
  const ProgramsSection({super.key});

  @override
  State<ProgramsSection> createState() => _ProgramsSectionState();
}

class _ProgramsSectionState extends State<ProgramsSection> {
  // --- Data List (Moved to top) ---
  final List<Map<String, dynamic>> _programs = [
    {
      'title': "Stress Management Workshop",
      'category': "Mental Health",
      'status': "Active",
      'color': Colors.purple,
      'icon': Icons.psychology,
      'desc':
          "Learn effective techniques to manage workplace stress and improve mental well-being.",
      'instructor': "Dr. Sarah Johnson",
      'duration': "15/01/2024 - 15/03/2024",
      'enrolled': "45",
      'total': "50",
      'cost': "₹5,000",
      'enrollProgress': 0.90,
      'completionRate': 0.78,
    },
    {
      'title': "Corporate Fitness Challenge",
      'category': "Fitness",
      'status': "Draft",
      'color': Colors.blue,
      'icon': Icons.fitness_center,
      'desc':
          "A 12-week fitness program designed to improve overall health and team bonding.",
      'instructor': "Mike Davis",
      'duration': "01/01/2024 - 31/03/2024",
      'enrolled': "120",
      'total': "150",
      'cost': "₹8,000",
      'enrollProgress': 0.80,
      'completionRate': 0.65,
    },
    {
      'title': "Nutrition and Healthy Eating",
      'category': "Nutrition",
      'status': "Inactive",
      'color': Colors.green,
      'icon': Icons.restaurant_menu,
      'desc':
          "Learn about balanced nutrition and meal planning for busy professionals.",
      'instructor': "Nutritionist Priya Sharma",
      'duration': "01/02/2024 - 01/04/2024",
      'enrolled': "35",
      'total': "40",
      'cost': "₹3,500",
      'enrollProgress': 0.88,
      'completionRate': 0.0,
    },
  ];

  // --- State Variables ---
  String _selectedCategory = 'All Categories';
  String _selectedStatus = 'All Status';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Dropdown Options
  final List<String> _statusOptions = [
    'All Status',
    'Active',
    'Draft',
    'Inactive'
  ];
  late List<String> _categoryOptions;

  @override
  void initState() {
    super.initState();
    // Dynamically extract categories from the data and add "All Categories"
    final uniqueCategories =
        _programs.map((p) => p['category'] as String).toSet();
    _categoryOptions = ['All Categories', ...uniqueCategories];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- Filtering Logic ---
  List<Map<String, dynamic>> get _filteredPrograms {
    return _programs.where((program) {
      // 1. Filter by Search Query
      final searchLower = _searchQuery.toLowerCase();
      final titleMatch =
          (program['title'] as String).toLowerCase().contains(searchLower);
      final descMatch =
          (program['desc'] as String).toLowerCase().contains(searchLower);
      final instructorMatch =
          (program['instructor'] as String).toLowerCase().contains(searchLower);

      final matchesSearch = titleMatch || descMatch || instructorMatch;

      // 2. Filter by Category
      final matchesCategory = _selectedCategory == 'All Categories' ||
          program['category'] == _selectedCategory;

      // 3. Filter by Status
      final matchesStatus = _selectedStatus == 'All Status' ||
          program['status'] == _selectedStatus;

      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayList = _filteredPrograms;

    return Column(
      children: [
        // --- Search and Filters Bar ---
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;

            // Mobile: Stacked | Desktop: Row
            if (isMobile) {
              return Column(
                children: [
                  _buildSearchField(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          value: _selectedCategory,
                          items: _categoryOptions,
                          onChanged: (val) {
                            if (val != null)
                              setState(() => _selectedCategory = val);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdown(
                          value: _selectedStatus,
                          items: _statusOptions,
                          onChanged: (val) {
                            if (val != null)
                              setState(() => _selectedStatus = val);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              );
            } else {
              return Row(
                children: [
                  Expanded(flex: 3, child: _buildSearchField()),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: _buildDropdown(
                      value: _selectedCategory,
                      items: _categoryOptions,
                      onChanged: (val) {
                        if (val != null)
                          setState(() => _selectedCategory = val);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: _buildDropdown(
                      value: _selectedStatus,
                      items: _statusOptions,
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedStatus = val);
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),

        const SizedBox(height: 24),

        // --- Programs List ---
        if (displayList.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              "No programs found matching your criteria.",
              style: TextStyle(color: Colors.grey.shade500),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayList.length,
            separatorBuilder: (ctx, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final p = displayList[index];
              return ProgramCard(
                title: p['title'],
                category: p['category'],
                status: p['status'], // <--- Added Status here
                categoryColor: p['color'],
                categoryIcon: p['icon'],
                description: p['desc'],
                instructor: p['instructor'],
                duration: p['duration'],
                enrolled: p['enrolled'],
                totalSpots: p['total'],
                cost: p['cost'],
                enrollmentProgress: p['enrollProgress'],
                completionRate: p['completionRate'],
              );
            },
          ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: "Search programs by name, description, or instructor...",
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1976D2)),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: Icon(Icons.keyboard_arrow_down,
              size: 18, color: Colors.grey.shade500),
          isExpanded: true,
          style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(8),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}