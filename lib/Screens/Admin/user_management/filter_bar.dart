import 'package:flutter/material.dart';

class SearchAndFilters extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final String selectedRole;
  final ValueChanged<String?> onRoleChanged;
  final String selectedStatus;
  final ValueChanged<String?> onStatusChanged;

  const SearchAndFilters({
    super.key,
    required this.onSearchChanged,
    required this.selectedRole,
    required this.onRoleChanged,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Basic responsive check
    bool isSmallScreen = MediaQuery.of(context).size.width < 800;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Flex(
        direction: isSmallScreen ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Expanded(
            flex: isSmallScreen ? 0 : 2,
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search users by name or email...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
          
          if (isSmallScreen) const SizedBox(height: 12),
          if (!isSmallScreen) const SizedBox(width: 16),

          // Filters
          Row(
            children: [
              _buildDropdown(
                value: selectedRole,
                items: ['All Roles', 'Admin', 'Provider', 'Patient', 'Corporate'],
                onChanged: onRoleChanged,
              ),
              const SizedBox(width: 16),
              _buildDropdown(
                value: selectedStatus,
                items: ['All Status', 'Active', 'Inactive', 'Suspended'],
                onChanged: onStatusChanged,
              ),
            ],
          ),
        ],
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}