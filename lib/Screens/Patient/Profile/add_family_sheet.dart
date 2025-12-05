import 'package:flutter/material.dart';

class AddFamilySheet extends StatefulWidget {
  final Function(Map<String, String>) onSave;
  const AddFamilySheet({super.key, required this.onSave});

  @override
  State<AddFamilySheet> createState() => _AddFamilySheetState();
}

class _AddFamilySheetState extends State<AddFamilySheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _age = TextEditingController();
  final _phone = TextEditingController();
  String _relation = 'Spouse';
  String _gender = 'Male';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16, right: 16, top: 16
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Add Family Member", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              initialValue: _relation,
              decoration: const InputDecoration(labelText: "Relation", border: OutlineInputBorder()),
              items: ['Spouse', 'Child', 'Parent', 'Sibling', 'Other'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (v) => setState(() => _relation = v!),
            ),
            const SizedBox(height: 10),
            TextFormField(controller: _name, decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: TextFormField(controller: _age, decoration: const InputDecoration(labelText: "Age", border: OutlineInputBorder()))),
              const SizedBox(width: 10),
              Expanded(child: DropdownButtonFormField<String>(
                initialValue: _gender,
                decoration: const InputDecoration(labelText: "Gender", border: OutlineInputBorder()),
                items: ["Male", "Female","Other"].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (v) => setState(() => _gender = v!),
              )),
            ]),
            const SizedBox(height: 10),
            TextFormField(controller: _phone, decoration: const InputDecoration(labelText: "Phone", border: OutlineInputBorder())),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSave({
                      "name": _name.text,
                      "relation": _relation,
                      "age": _age.text,
                      "gender": _gender,
                      "phone": _phone.text,
                    });
                  }
                },
                child: const Text("Add Member", style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
