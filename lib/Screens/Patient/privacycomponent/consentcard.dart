import 'package:flutter/material.dart';

class ConsentCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(bool) onChanged;

  const ConsentCard({
    super.key,
    required this.data,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isGranted = data['isGranted'] ?? false;
    final List<dynamic> badges = data['badges'] ?? [];
    final List<String> purposes = List<String>.from(data['purposes'] ?? []);
    final List<String> dataTypes = List<String>.from(data['dataTypes'] ?? []);
    
    // 1. Extract the new "sharedWith" list from data
    final List<String> sharedWith = List<String>.from(data['sharedWith'] ?? []); 
    
    final String? warning = data['warning'];
    final String? grantedOn = data['grantedOn'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
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
          // --- HEADER SECTION ---
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Badges
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Text(
                                data['title'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              ...badges.map((b) => _buildBadge(b)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            data['description'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Toggle Button
                    InkWell(
                      onTap: () => onChanged(!isGranted),
                      borderRadius: BorderRadius.circular(20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isGranted
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: isGranted
                                ? Colors.blue.shade400
                                : Colors.grey.shade400,
                            size: 24,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isGranted ? "Granted" : "Not Granted",
                            style: TextStyle(
                              color: isGranted
                                  ? Colors.green.shade600
                                  : Colors.grey.shade500,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Warning Section (Dynamic)
                if (warning != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.error_outline_rounded,
                          size: 16, color: Colors.deepOrange.shade400),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          warning,
                          style: TextStyle(
                            color: Colors.deepOrange.shade400,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Divider
          Divider(height: 1, color: Colors.grey.shade100),

          // --- DETAILS SECTION ---
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Purposes
                _buildChipSection("Purposes:", purposes),
                const SizedBox(height: 16),
                
                // Data Types
                _buildChipSection("Data Types:", dataTypes),
                
                // 2. Add the new "Shared With" section here
                // We check if list is not empty inside _buildChipSection, 
                // but we also add spacing only if previous items exist.
                if (sharedWith.isNotEmpty) ...[
                   const SizedBox(height: 16),
                   _buildChipSection("Shared With:", sharedWith),
                ],

                // Footer Timestamp
                if (grantedOn != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    "Granted on: $grantedOn",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(Map<String, dynamic> badgeData) {
    final String text = badgeData['text'];
    final String colorType = badgeData['color'] ?? 'grey';

    Color bgColor;
    Color textColor;

    switch (colorType) {
      case 'red':
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        break;
      case 'orange':
        bgColor = const Color(0xFFFFF7E6); // Light beige/orange
        textColor = Colors.brown.shade700;
        break;
      case 'blue':
        bgColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
        break;
      default:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildChipSection(String label, List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}