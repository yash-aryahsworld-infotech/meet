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
  
  late TextEditingController nameCtrl; // Handles "first_name" or "name"
  late TextEditingController lastNameCtrl; // Only for main user usually
  late TextEditingController phoneCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController ageCtrl;
  late TextEditingController genderCtrl;
  late TextEditingController relationCtrl; // Only for family

  @override
  void initState() {
    super.initState();
    // Initialize controllers with passed data
    final d = widget.initialData;
    
    // Normalize data: Main user has first/last, Family has 'name'
    String combinedName = d['name'] ?? d['first_name'] ?? "";
    
    nameCtrl = TextEditingController(text: combinedName);
    lastNameCtrl = TextEditingController(text: d['last_name'] ?? "");
    phoneCtrl = TextEditingController(text: d['phone'] ?? "");
    emailCtrl = TextEditingController(text: d['email'] ?? "");
    ageCtrl = TextEditingController(text: d['age']?.toString() ?? "");
    genderCtrl = TextEditingController(text: d['gender'] ?? "");
    relationCtrl = TextEditingController(text: d['relation'] ?? "");
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    lastNameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    ageCtrl.dispose();
    genderCtrl.dispose();
    relationCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> result = {
        "phone": phoneCtrl.text.trim(),
        "age": ageCtrl.text.trim(),
        "gender": genderCtrl.text.trim(),
      };

      if (widget.isMainUser) {
        result["first_name"] = nameCtrl.text.trim();
        result["last_name"] = lastNameCtrl.text.trim();
        // Email usually not editable here, but added if needed
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
          
          Row(
            children: [
              Expanded(child: _buildField(ageCtrl, "Age")),
              const SizedBox(width: 10),
              Expanded(child: _buildField(genderCtrl, "Gender")),
            ],
          ),

          const SizedBox(height: 20),
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