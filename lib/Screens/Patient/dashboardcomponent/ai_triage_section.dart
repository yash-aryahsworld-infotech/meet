import 'package:flutter/material.dart';

class AiTriageSection extends StatefulWidget {
  const AiTriageSection({super.key});

  @override
  State<AiTriageSection> createState() => _AiTriageSectionState();
}

class _AiTriageSectionState extends State<AiTriageSection> {
  // State for interactivity
  final TextEditingController _symptomController = TextEditingController();
  String _selectedLanguage = 'English';
  String? _selectedDuration;
  String? _selectedSeverity;
  
  // List of common symptoms shown as chips
  final List<String> _commonSymptoms = [
    'Fever', 'Headache', 'Cough', 'Sore throat', 'Fatigue', 
    'Nausea', 'Abdominal pain', 'Chest pain', 'Shortness of breath',
    'Dizziness', 'Rash', 'Joint pain', 'Back pain', 'Vomiting', 'Diarrhea'
  ];

  // Selected symptoms list
  final Set<String> _selectedSymptoms = {};

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.psychology_alt, color: Colors.black87, size: 28),
                const SizedBox(width: 12),
                Text(
                  "AI Symptom Triage",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Describe your symptoms for AI-powered health assessment and recommendations.",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Language Selector
            _buildLabel("Language / भाषा / ভাষা"),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    value: _selectedLanguage,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(8),
                    items: ['English', 'Hindi', 'Bengali', 'Spanish'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() => _selectedLanguage = newValue!);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Add Symptoms Input
            _buildLabel("Add Symptoms"),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _symptomController,
                    onSubmitted: (_) => _addSymptom(),
                    decoration: const InputDecoration(
                      hintText: "Type a symptom...",
                      hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: _addSymptom,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Add"),
                ),
              ],
            ),
            
            // Selected Symptoms Section (New!)
            if (_selectedSymptoms.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildLabel("Selected Symptoms:"),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedSymptoms.map((symptom) {
                  return InputChip(
                    label: Text(symptom),
                    labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    backgroundColor: const Color(0xFF4285F4), // Google Blue
                    deleteIcon: const Icon(Icons.close, size: 16, color: Colors.white),
                    onDeleted: () {
                      setState(() {
                        _selectedSymptoms.remove(symptom);
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide.none,
                    ),
                    padding: const EdgeInsets.all(0),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 24),

            // Common Symptoms Chips
            _buildLabel("Common Symptoms (click to add)"),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _commonSymptoms.map((symptom) {
                final isSelected = _selectedSymptoms.contains(symptom);
                // We don't show them as selected here if they are in the list above to avoid duplicates visual, 
                // OR we keep them selected. Standard pattern is to highlight them.
                return ActionChip(
                  label: Text(symptom),
                  onPressed: () {
                    setState(() {
                      if (!_selectedSymptoms.contains(symptom)) {
                        _selectedSymptoms.add(symptom);
                      } else {
                         // Optional: Allow toggling off from here too
                         _selectedSymptoms.remove(symptom);
                      }
                    });
                  },
                  backgroundColor: isSelected ? Colors.grey.shade100 : Colors.white,
                  side: BorderSide(
                    color: isSelected ? Colors.blue.shade200 : Colors.grey.shade300,
                  ),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.blue.shade700 : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Duration Dropdown
            _buildLabel("How long have you had these symptoms?"),
            const SizedBox(height: 8),
            _buildDropdown(
              value: _selectedDuration,
              hint: "Select duration",
              items: ["Less than 1 day", "1-3 days", "1 week", "More than 2 weeks"],
              onChanged: (val) => setState(() => _selectedDuration = val),
            ),
            const SizedBox(height: 24),

            // Severity Dropdown
            _buildLabel("How severe are your symptoms?"),
            const SizedBox(height: 8),
            _buildDropdown(
              value: _selectedSeverity,
              hint: "Select severity",
              items: ["Mild", "Moderate", "Severe", "Critical"],
              onChanged: (val) => setState(() => _selectedSeverity = val),
            ),
            const SizedBox(height: 24),

            // Additional Info
            _buildLabel("Additional Information (optional)"),
            const SizedBox(height: 8),
            TextField(
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Any other relevant information about your symptoms, medical history, current medications, etc.",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.info_outline, size: 20, color: Colors.white),
                label: const Text(
                  "Get AI Analysis", 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4285F4), // Stronger Blue from 2nd image
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Disclaimer
            Center(
              child: Text(
                "This AI analysis is for informational purposes only and should not replace professional medical advice. Always consult with healthcare providers for proper diagnosis and treatment.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addSymptom() {
    if (_symptomController.text.trim().isNotEmpty) {
      setState(() {
        _selectedSymptoms.add(_symptomController.text.trim());
        _symptomController.clear();
      });
    }
  }

  // Helper for Section Labels
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  // Helper for styled dropdowns
  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            value: value,
            hint: Text(hint, style: TextStyle(color: Colors.black87, fontSize: 14)),
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}