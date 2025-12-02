import 'package:flutter/material.dart';
import './near_by_health_provider/online_consultant_tab.dart'; // Adjust path based on your folder structure
import './near_by_health_provider/clinic_visit_tab.dart';      // Adjust path based on your folder structure

class NearbyHealthcare extends StatefulWidget {
  const NearbyHealthcare({super.key});

  @override
  State<NearbyHealthcare> createState() => _NearbyHealthcareState();
}

class _NearbyHealthcareState extends State<NearbyHealthcare> {
  int _selectedIndex = 0;
  final List<String> _tabs = ["Online Consult", "Clinic Visit"];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- Custom Simple Tab Bar ---
        Container(
          color: Colors.white,
          child: Row(
            children: List.generate(_tabs.length, (index) {
              final isSelected = _selectedIndex == index;
              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected ? Colors.blue : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _tabs[index],
                        style: TextStyle(
                          color: isSelected ? Colors.blue : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        // --- Body Content Switcher ---
        // Load the separate page components here
        _selectedIndex == 0 
            ? const OnlineConsultantPage() 
            : const ClinicVisitPage(),
      ],
    );
  }
}