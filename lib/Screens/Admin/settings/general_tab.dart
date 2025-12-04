import 'package:flutter/material.dart';




class GeneralConfigurationCard extends StatefulWidget {
  const GeneralConfigurationCard({super.key});

  @override
  State<GeneralConfigurationCard> createState() => _GeneralConfigurationCardState();
}

class _GeneralConfigurationCardState extends State<GeneralConfigurationCard> {
  // State variables for switches
  bool _maintenanceMode = false;
  bool _enableUserRegistration = true;
  bool _enablePaymentProcessing = true;

  // Controllers for text fields
  final TextEditingController _maxAppointmentsController = TextEditingController(text: "50");
  final TextEditingController _defaultDurationController = TextEditingController(text: "30");
  final TextEditingController _timeZoneController = TextEditingController(text: "Asia/Kolkata");
  final TextEditingController _emailController = TextEditingController(text: "admin@healthcare.com");

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
              "General Configuration",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),

            // Switches
            _buildSwitchRow("Maintenance Mode", _maintenanceMode, (val) {
              setState(() => _maintenanceMode = val);
            }),
            _buildSwitchRow("Enable User Registration", _enableUserRegistration, (val) {
              setState(() => _enableUserRegistration = val);
            }),
            _buildSwitchRow("Enable Payment Processing", _enablePaymentProcessing, (val) {
              setState(() => _enablePaymentProcessing = val);
            }),

            const SizedBox(height: 16),

            // Row with two inputs
            Row(
              children: [
                Expanded(
                  child: LabeledTextField(
                    label: "Max Appointments/Day",
                    controller: _maxAppointmentsController,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: LabeledTextField(
                    label: "Default Duration (min)",
                    controller: _defaultDurationController,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // System Time Zone
            LabeledTextField(
              label: "System Time Zone",
              controller: _timeZoneController,
            ),

            const SizedBox(height: 16),

            // Emergency Contact Email
            LabeledTextField(
              label: "Emergency Contact Email",
              controller: _emailController,
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
          ),
        ],
      ),
    );
  }
}

// Reusable Input Widget to match the specific "Label above box" style
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