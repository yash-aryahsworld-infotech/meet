import 'package:flutter/material.dart';

class ProviderCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const ProviderCard({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    // We remove the hardcoded height or aspect ratio issues
    // The parent Row + IntrinsicHeight handles the layout sizing.
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  data['name'],
                  maxLines: 2, // Allow 2 lines for web safety
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4CC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      "${data['rating']}",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 12),

          // Type
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              data['type'],
              style: TextStyle(fontSize: 12, color: Colors.blue.shade800),
            ),
          ),

          const SizedBox(height: 10),

          // Distance
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                data['distance'],
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
            ],
          ),

          // This Spacer pushes tags to the bottom. 
          // It works now because we wrapped the parent Row in IntrinsicHeight.
          const Spacer(), 
          const SizedBox(height: 15),

          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: (data['tags'] as List).map<Widget>((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tag,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}