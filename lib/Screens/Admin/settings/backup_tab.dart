import 'package:flutter/material.dart';




class BackupMaintenanceCard extends StatelessWidget {
  const BackupMaintenanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Controllers initialized with the values from the image
    final TextEditingController backupFreqController = TextEditingController(text: "daily");
    final TextEditingController retentionController = TextEditingController(text: "90");

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main Header
            const Text(
              "Backup & Maintenance",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),

            // Backup Frequency Input
            LabeledTextField(
              label: "Backup Frequency",
              controller: backupFreqController,
            ),
            
            const SizedBox(height: 16),

            // Data Retention Input
            LabeledTextField(
              label: "Data Retention Period (days)",
              controller: retentionController,
            ),

            const SizedBox(height: 24),

            // Divider Line
            Divider(color: Colors.grey.shade200, thickness: 1),
            
            const SizedBox(height: 16),

            // Sub-header for System Status
            const Text(
              "System Status",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 12),

            // Status Chips
            Wrap(
              spacing: 8.0, // Gap between chips horizontally
              runSpacing: 8.0, // Gap between lines if they wrap
              children: [
                _buildStatusChip("Database: Online"),
                _buildStatusChip("Storage: Online"),
                _buildStatusChip("Payment Gateway: Online"),
                _buildStatusChip("Notifications: Online"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to create the grey status pills
  Widget _buildStatusChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200], // Light grey background
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey[800],
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// Reusing the same Input Widget for consistency across all cards
class LabeledTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const LabeledTextField({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue, width: 1.5),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}