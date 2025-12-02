import 'package:flutter/material.dart';

enum AnalyticsType { list, grid }

class AnalyticsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Map<String, String>> items;
  final AnalyticsType type;

  const AnalyticsCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          /// TITLE
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),

          /// SUBTITLE
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 20),

          /// SWITCH LAYOUT BASED ON TYPE
          type == AnalyticsType.list 
              ? _buildListLayout() 
              : _buildGridLayout(),
        ],
      ),
    );
  }

  /// -----------------------------------------
  /// A) VERTICAL LIST (Earnings Analytics)
  /// -----------------------------------------
  Widget _buildListLayout() {
    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item["label"]!,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                item["value"]!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// -----------------------------------------
  /// B) GRID (Performance Metrics)
  /// -----------------------------------------
Widget _buildGridLayout() {
  return LayoutBuilder(
    builder: (context, constraints) {
      double itemWidth = (constraints.maxWidth / 2) - 20;

      return Wrap(
        spacing: 20,
        runSpacing: 16,
        children: items.map((item) {
          return SizedBox(
            width: itemWidth,  // FIXED WIDTH FOR WEB/TABLET
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Value
                Text(
                  item["value"]!,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _getColor(item["value"]!),
                  ),
                ),

                const SizedBox(height: 4),

                /// Label
                Text(
                  item["label"]!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    },
  );
}

 
  /// Give color based on value (optional logic)
  Color _getColor(String value) {
    if (value.contains("%")) return Colors.green;
    if (value.contains("days")) return Colors.blue;
    if (value.contains("₹")) return Colors.purple;
    if (value.contains("/")) return Colors.deepOrange;
    return Colors.black87;
  }
}
