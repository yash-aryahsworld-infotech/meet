import 'package:flutter/material.dart';




class SecuritySettingsCard extends StatefulWidget {
  const SecuritySettingsCard({super.key});

  @override
  State<SecuritySettingsCard> createState() => _SecuritySettingsCardState();
}

class _SecuritySettingsCardState extends State<SecuritySettingsCard> {
  // State variables for switches
  bool _enableAuditLogging = true;
  bool _requireTwoFactor = false;

  // Controllers for text fields
  final TextEditingController _sessionTimeoutController = TextEditingController(text: "30");
  final TextEditingController _minPasswordLengthController = TextEditingController(text: "8");
  final TextEditingController _maxFileSizeController = TextEditingController(text: "10");

  @override
  Widget build(BuildContext context) {
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
            // Header
            const Text(
              "Security Settings",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),

            // Switches
            _buildSwitchRow("Enable Audit Logging", _enableAuditLogging, (val) {
              setState(() => _enableAuditLogging = val);
            }),
            _buildSwitchRow("Require Two-Factor Authentication", _requireTwoFactor, (val) {
              setState(() => _requireTwoFactor = val);
            }),

            const SizedBox(height: 16),

            // Row with two inputs
            Row(
              children: [
                Expanded(
                  child: LabeledTextField(
                    label: "Session Timeout (minutes)",
                    controller: _sessionTimeoutController,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: LabeledTextField(
                    label: "Minimum Password Length",
                    controller: _minPasswordLengthController,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Full width input
            LabeledTextField(
              label: "Max File Upload Size (MB)",
              controller: _maxFileSizeController,
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for the Switch Rows
  Widget _buildSwitchRow(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue,
            activeTrackColor: Colors.blue.withOpacity(0.4),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }
}

// Reusable Input Widget (Same as previous component for consistency)
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