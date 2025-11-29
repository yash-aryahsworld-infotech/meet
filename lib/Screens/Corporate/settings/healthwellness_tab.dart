import 'package:flutter/material.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';
import 'package:healthcare_plus/widgets/custom_button.dart';
import '../../../widgets/switch_on_off.dart';

class HealthWellnessTab extends StatefulWidget {
  const HealthWellnessTab({super.key});

  @override
  State<HealthWellnessTab> createState() => _HealthWellnessTabState();
}

class _HealthWellnessTabState extends State<HealthWellnessTab> {
  // State variables to track toggle status
  bool _enableScreenings = true;
  bool _mandatoryCheckup = true;
  bool _allowFamily = false;
  bool _enableMentalHealth = true;
  bool _enableFitness = true;
  bool _emergencyContact = true;

  // Controller for the budget input
  final TextEditingController _budgetController = TextEditingController(
    text: "5000",
  );

  @override
  Widget build(BuildContext context) {
    final bool isMobile = AppResponsive.isMobile(context);
    return Container(
      // Limit width for desktop look
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
        mainAxisSize: MainAxisSize.min, // Wrap content
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.favorite_border, size: 24, color: Colors.grey[700]),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Health & Wellness Configuration",
                  softWrap: true,
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

          // Switch 1
          _buildDirectSwitch(
            "Enable Health Screenings",
            "Allow employees to book health screenings",
            _enableScreenings,
            (val) => setState(() => _enableScreenings = val),
          ),
          // Switch 2
          _buildDirectSwitch(
            "Mandatory Annual Checkup",
            "Require employees to complete annual health checkup",
            _mandatoryCheckup,
            (val) => setState(() => _mandatoryCheckup = val),
          ),
          // Switch 3
          _buildDirectSwitch(
            "Allow Family Members",
            "Extend health benefits to employee family members",
            _allowFamily,
            (val) => setState(() => _allowFamily = val),
          ),
          // Switch 4
          _buildDirectSwitch(
            "Enable Mental Health Support",
            "Provide access to mental health resources",
            _enableMentalHealth,
            (val) => setState(() => _enableMentalHealth = val),
          ),
          // Switch 5
          _buildDirectSwitch(
            "Enable Fitness Programs",
            "Offer fitness and wellness programs",
            _enableFitness,
            (val) => setState(() => _enableFitness = val),
          ),

          const SizedBox(height: 16),
          // Input
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Health Budget per Employee (Annual)",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: "\$ ",
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
          const SizedBox(height: 24),

          // Switch 6
          _buildDirectSwitch(
            "Emergency Contact Required",
            "Require employees to provide emergency contact",
            _emergencyContact,
            (val) => setState(() => _emergencyContact = val),
          ),

          const SizedBox(height: 30),
          CustomButton(
            text: "Save health Setting",
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
          // Using the custom On/Off toggle here
          OnOffSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// CUSTOM ON/OFF TOGGLE WIDGET
// ---------------------------------------------------------
