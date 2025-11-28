import 'package:flutter/material.dart';

class PrivacySecurityTab extends StatelessWidget {
  const PrivacySecurityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security, size: 20, color: Colors.grey[700]),
              const SizedBox(width: 10),
              const Text(
                "Privacy & Security Settings",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Input
          SizedBox(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Data Retention Period (months)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                TextFormField(
                  initialValue: "36",
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _buildDirectSwitch("Allow Data Export", "Allow employees to export their health data", true),
          _buildDirectSwitch("Require Consent for Programs", "Require explicit consent before enrolling in programs", true),
          _buildDirectSwitch("Anonymize Reports", "Remove personal identifiers from wellness reports", true),
          _buildDirectSwitch("Share Aggregated Data", "Share anonymized aggregated data for research", false),
          _buildDirectSwitch("Enable Audit Logs", "Maintain detailed logs of all system access", true),

          const SizedBox(height: 24),
          // Warning Note
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF9C3), // Yellow-50/100
              border: Border.all(color: const Color(0xFFFDE047)), // Yellow-300
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Note: Changes to privacy settings may require employee notification and consent under applicable data protection laws.",
              style: TextStyle(color: Colors.yellow[900], fontSize: 13),
            ),
          ),

          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Save Privacy Settings"),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectSwitch(String title, String subtitle, bool value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (val) {},
            activeColor: const Color(0xFF2563EB),
          ),
        ],
      ),
    );
  }
}