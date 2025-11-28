import 'package:flutter/material.dart';
import 'status_badge.dart'; // Assuming this exists based on your context

class WellnessProgramCard extends StatelessWidget {
  final String name;
  final String status;
  final Color statusColor;
  final int enrolled;
  final int total;
  final double progress; // 0.0 to 1.0
  final String completion;

  // Logic controls
  final bool showViewDetails;
  final VoidCallback? onViewDetailsTap;

  const WellnessProgramCard({
    super.key,
    required this.name,
    required this.status,
    required this.statusColor,
    required this.enrolled,
    required this.total,
    required this.progress,
    required this.completion,
    this.showViewDetails = false, // Defaults to false
    this.onViewDetailsTap,        // Function passed from parent
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Row 1: Title and Status ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            StatusBadge(status: status, color: statusColor),
          ],
        ),
        const SizedBox(height: 4),

        // --- Row 2: Count ---
        Text(
          "$enrolled / $total employees",
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 12),

        // --- Row 3: Participation Labels ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Participation",
                style: TextStyle(fontSize: 12, color: Colors.black54)),
            Text("${(progress * 100).toInt()}%",
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),

        // --- Row 4: Progress Bar ---
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: Colors.grey.shade100,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
          ),
        ),
        const SizedBox(height: 12),

        // --- Row 5: Completion & Optional Button ---
        // WRAPPED in SizedBox(width: double.infinity) to force full width on Web
        SizedBox(
          width: double.infinity, 
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween, // Now works to push button to right
            spacing: 8.0,
            runSpacing: 8.0, // Handles responsive wrapping
            children: [
              Text(
                "Completion: $completion",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              // Conditionally render the button
              if (showViewDetails)
                OutlinedButton(
                  onPressed: onViewDetailsTap,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    side: BorderSide(color: Colors.grey.shade300),
                    foregroundColor: Colors.black87,
                    backgroundColor: Colors.white,
                  ),
                  child: const Text("View Details", style: TextStyle(fontSize: 12)),
                ),
            ],
          ),
        )
      ],
    );
  }
}