import 'package:flutter/material.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';
import 'package:healthcare_plus/widgets/custom_button.dart';
import '../../../widgets/switch_on_off.dart';

class PrivacySecurityTab extends StatefulWidget {
  const PrivacySecurityTab({super.key});

  @override
  State<PrivacySecurityTab> createState() => _PrivacySecurityTabState();
}

class _PrivacySecurityTabState extends State<PrivacySecurityTab> {
  // State variables
  final TextEditingController _retentionController = TextEditingController(
    text: "36",
  );
  bool _allowDataExport = true;
  bool _requireConsent = true;
  bool _anonymizeReports = true;
  bool _shareAggregatedData = false;
  bool _enableAuditLogs = true;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = AppResponsive.isMobile(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security, size: 24, color: Colors.grey[700]),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Privacy & Security Settings",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Input
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Data Retention Period (months)",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _retentionController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF2563EB),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _buildDirectSwitch(
            "Allow Data Export",
            "Allow employees to export their health data",
            _allowDataExport,
            (val) => setState(() => _allowDataExport = val),
          ),
          _buildDirectSwitch(
            "Require Consent for Programs",
            "Require explicit consent before enrolling in programs",
            _requireConsent,
            (val) => setState(() => _requireConsent = val),
          ),
          _buildDirectSwitch(
            "Anonymize Reports",
            "Remove personal identifiers from wellness reports",
            _anonymizeReports,
            (val) => setState(() => _anonymizeReports = val),
          ),
          _buildDirectSwitch(
            "Share Aggregated Data",
            "Share anonymized aggregated data for research",
            _shareAggregatedData,
            (val) => setState(() => _shareAggregatedData = val),
          ),
          _buildDirectSwitch(
            "Enable Audit Logs",
            "Maintain detailed logs of all system access",
            _enableAuditLogs,
            (val) => setState(() => _enableAuditLogs = val),
          ),

          const SizedBox(height: 16),
          // Warning Note
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF9C3), // Yellow-50/100
              border: Border.all(color: const Color(0xFFFDE047)), // Yellow-300
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.yellow[900]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Note: Changes to privacy settings may require employee notification and consent under applicable data protection laws.",
                    style: TextStyle(
                      color: Colors.yellow[900],
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
          CustomButton(
            text: "Save Privacy Setting",
            width: isMobile ? double.infinity : 200,
            onPressed: () => {},
          ),
        ],
      ),
    );
  }

  Widget _buildDirectSwitch(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Using the custom On/Off toggle
          OnOffSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
