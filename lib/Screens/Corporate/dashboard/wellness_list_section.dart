import 'package:flutter/material.dart';
import './wellness_program_card.dart';

class WellnessListSection extends StatelessWidget {
  const WellnessListSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Data matched to your image
    final List<Map<String, dynamic>> programs = [
      {
        'name': 'Annual Health Checkups',
        'status': 'active',
        'statusColor': const Color(0xFF2563EB), // Blue
        'enrolled': 145,
        'total': 250,
        'progress': 0.58,
        'completion': '58%',
        'showButton': true,
      },
      {
        'name': 'Mental Health Workshop',
        'status': 'scheduled',
        'statusColor': Colors.grey,
        'enrolled': 87,
        'total': 250,
        'progress': 0.35,
        'completion': '35%',
        'showButton': false,
      },
      {
        'name': 'Fitness Challenge Q1',
        'status': 'completed',
        'statusColor': Colors.grey,
        'enrolled': 203,
        'total': 250,
        'progress': 0.81,
        'completion': '81%',
        'showButton': false,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // Soft shadow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          // --- Header Section (Responsive) ---
          LayoutBuilder(
            builder: (context, constraints) {
              // Check available width to decide layout
              final bool isMobile = constraints.maxWidth < 480;

              if (isMobile) {
                // --- Mobile Layout: Stacked ---
                // Title & Button on top row, Subtitle below
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Title Area
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.favorite_border,
                                  size: 20, color: Colors.black87),
                              const SizedBox(width: 8),
                              // Flexible allows text to shrink nicely
                              const Flexible(
                                child: Text(
                                  "Wellness Programs",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Compact Manage Button for Mobile
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.settings_outlined, size: 14),
                          label: const Text("Manage"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black87,
                            side: BorderSide(color: Colors.grey.shade300),
                            // Reduced padding for mobile
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            minimumSize: const Size(0, 32),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Subtitle gets full width below
                    Text(
                      "Track employee participation and program effectiveness",
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey.shade500),
                    ),
                  ],
                );
              } else {
                // --- Desktop/Tablet Layout: Side by Side ---
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.favorite_border,
                                  size: 20, color: Colors.black87),
                              const SizedBox(width: 8),
                              const Flexible(
                                child: Text(
                                  "Wellness Programs",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Track employee participation and program effectiveness",
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Standard Manage Button
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.settings_outlined, size: 14),
                      label: const Text("Manage"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    )
                  ],
                );
              }
            },
          ),

          const SizedBox(height: 32),

          // --- The List ---
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: programs.length,
            // Adds generous spacing between cards
            separatorBuilder: (_, __) => const SizedBox(height: 40),
            itemBuilder: (context, index) {
              final data = programs[index];

              return WellnessProgramCard(
                name: data['name'],
                status: data['status'],
                statusColor: data['statusColor'],
                enrolled: data['enrolled'],
                total: data['total'],
                progress: data['progress'],
                completion: data['completion'],
                showViewDetails: data['showButton'],
                onViewDetailsTap: () {
                  // Details tapped for program
                },
              );
            },
          ),
        ],
      ),
    );
  }
}