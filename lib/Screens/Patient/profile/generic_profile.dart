import 'package:flutter/material.dart';

class GenericProfileForm extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final bool isMainUser;
  final Function(Map<String, dynamic>) onSave;

  const GenericProfileForm({
    super.key,
    required this.initialData,
    required this.isMainUser,
    required this.onSave,
  });

  @override
  State<GenericProfileForm> createState() => _GenericProfileFormState();
}

class _GenericProfileFormState extends State<GenericProfileForm> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  late TextEditingController nameCtrl; 
  late TextEditingController lastNameCtrl; 
  late TextEditingController phoneCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController ageCtrl;
  late TextEditingController relationCtrl;
  
  // Dropdown State
  String? _selectedGender;
  final List<String> _genderOptions = ["Male", "Female", "Other"];

  @override
  void initState() {
    super.initState();
    final d = widget.initialData;

    // 1. Initialize Text Controllers
    String combinedName = d['name'] ?? d['firstName'] ?? "";
    nameCtrl = TextEditingController(text: combinedName);
    lastNameCtrl = TextEditingController(text: d['lastName'] ?? "");
    phoneCtrl = TextEditingController(text: d['phone'] ?? "");
    emailCtrl = TextEditingController(text: d['email'] ?? "");
    ageCtrl = TextEditingController(text: d['age']?.toString() ?? "");
    relationCtrl = TextEditingController(text: d['relation'] ?? "");

    // 2. Initialize Gender Dropdown
    // Check if the loaded gender matches one of our options
    String? incomingGender = d['gender'];
    if (incomingGender != null && _genderOptions.contains(incomingGender)) {
      _selectedGender = incomingGender;
    } else {
      _selectedGender = null; // Default to null (shows "Select" hint)
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    lastNameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    ageCtrl.dispose();
    relationCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> result = {
        "phone": phoneCtrl.text.trim(),
        "age": ageCtrl.text.trim(),
        "gender": _selectedGender, // Taking value from Dropdown
      };

      if (widget.isMainUser) {
        result["firstName"] = nameCtrl.text.trim();
        result["lastName"] = lastNameCtrl.text.trim();
      } else {
        result["name"] = nameCtrl.text.trim();
        result["relation"] = relationCtrl.text.trim();
      }

      widget.onSave(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // --- Name Fields ---
          if (widget.isMainUser) ...[
            _buildField(nameCtrl, "First Name"),
            const SizedBox(height: 10),
            _buildField(lastNameCtrl, "Last Name"),
            const SizedBox(height: 10),
            _buildField(emailCtrl, "Email", readOnly: true),
          ] else ...[
            _buildField(nameCtrl, "Full Name"),
            const SizedBox(height: 10),
            _buildField(relationCtrl, "Relation (e.g. Spouse)"),
          ],

          const SizedBox(height: 10),
          _buildField(phoneCtrl, "Phone"),
          const SizedBox(height: 10),

          // --- Age & Gender Row ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              // Age Input
              Expanded(
                child: _buildField(ageCtrl, "Age"),
              ),
              const SizedBox(width: 10),
              
              // Gender Dropdown
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedGender,
                  decoration: const InputDecoration(
                    labelText: "Gender",
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                  items: _genderOptions
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedGender = val;
                    });
                  },
                  validator: (val) => val == null ? "Required" : null,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          
          // --- Save Button ---
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: _submit,
              child: const Text("Save Changes", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }

  // Helper for standard Text Fields
  Widget _buildField(TextEditingController ctrl, String label, {bool readOnly = false}) {
    return TextFormField(
      controller: ctrl,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: readOnly ? Colors.grey[200] : Colors.white,
      ),
      validator: (v) => v!.isEmpty ? "Required" : null,
    );
  }
}