import 'package:flutter/material.dart';

class PediatricSection extends StatefulWidget {
  const PediatricSection({super.key});

  @override
  State<PediatricSection> createState() => _PediatricSectionState();
}

class _PediatricSectionState extends State<PediatricSection> {
  // State to toggle form visibility
  bool _isFormVisible = false;

  // List to store added children
  final List<Map<String, String>> _children = [];

  // Form Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _weightController = TextEditingController(text: '3.2'); // Default from image
  final TextEditingController _heightController = TextEditingController(text: '50.5'); // Default from image

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _onAddChild() {
    if (_nameController.text.isNotEmpty && _dobController.text.isNotEmpty) {
      setState(() {
        _children.add({
          'name': _nameController.text,
          'dob': _dobController.text,
          'weight': _weightController.text,
          'height': _heightController.text,
        });
        
        // Reset and hide form
        _nameController.clear();
        _dobController.clear();
        _weightController.text = '3.2';
        _heightController.text = '50.5';
        _isFormVisible = false;
      });
    }
  }

  void _onCancel() {
    setState(() {
      _isFormVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Blue Header Banner
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD), // Light blue background
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.child_care, color: Colors.blue[800], size: 24),
                  const SizedBox(width: 8),
                  Text(
                    "Pediatric Care Tracker",
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "Monitor your child's growth, vaccinations, and developmental milestones",
                style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // 2. Add Child Toggle Button
        if (!_isFormVisible)
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _isFormVisible = true;
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue[700],
                side: BorderSide(color: Colors.blue.shade600),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              icon: const Icon(Icons.add, size: 18),
              label: const Text("Add Child"),
            ),
          ),

        // 3. Form Section (Visible only when toggled)
        if (_isFormVisible)
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add New Child",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Row 1: Name & DOB
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildInputGroup(
                        "Child's Name", 
                        _nameController, 
                        hint: "Enter child's name"
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel("Birth Date"),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _dobController,
                            readOnly: true,
                            decoration: _inputDecoration().copyWith(
                              hintText: "dd-mm-yyyy",
                              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 16),
                            ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                              if (pickedDate != null) {
                                String formattedDate = "${pickedDate.day.toString().padLeft(2,'0')}-${pickedDate.month.toString().padLeft(2,'0')}-${pickedDate.year}";
                                setState(() {
                                  _dobController.text = formattedDate;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),

                // Row 2: Weight & Height
                Row(
                  children: [
                    Expanded(
                      child: _buildInputGroup("Birth Weight (kg)", _weightController),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildInputGroup("Birth Height (cm)", _heightController),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _onAddChild,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF64B5F6), // Light blue from image
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text("Add Child"),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: _onCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ],
                ),
              ],
            ),
          ),

        // 4. List of Children Cards (The "Child Info" display)
        if (_children.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Registered Children",
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.grey[800]
                  ),
                ),
                const SizedBox(height: 12),
                ..._children.map((child) => _buildChildCard(child)),
              ],
            ),
          ),
      ],
    );
  }

  // Helper Widget for Child Info Card
  Widget _buildChildCard(Map<String, String> child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: Icon(Icons.person, color: Colors.blue[700]),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child['name'] ?? "Unknown",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Born: ${child['dob']}",
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${child['weight']} kg",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                "${child['height']} cm",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Input Helpers
  Widget _buildInputGroup(String label, TextEditingController controller, {String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: _inputDecoration().copyWith(hintText: hint),
          keyboardType: label.contains("Name") ? TextInputType.text : TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.grey[800],
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.blue),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}