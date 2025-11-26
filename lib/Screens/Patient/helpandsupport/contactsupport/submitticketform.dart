import 'package:flutter/material.dart';

class SubmitTicketForm extends StatefulWidget {
  const SubmitTicketForm({super.key});

  @override
  State<SubmitTicketForm> createState() => _SubmitTicketFormState();
}

class _SubmitTicketFormState extends State<SubmitTicketForm> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String? _selectedCategory;
  String? _selectedPriority = "Medium - Issue affecting usage";

  // Colors
  final Color _primaryBlue = const Color(0xFF1665D8);
  final Color _textDark = const Color(0xFF2E3A59);
  final Color _textLight = const Color(0xFF8F9BB3);
  final Color _borderGrey = const Color(0xFFE4E9F2);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isFormWide = constraints.maxWidth > 600;

      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderGrey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Submit a Support Ticket",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Can't find what you're looking for? Submit a ticket and our team will help you.",
              style: TextStyle(fontSize: 14, color: _textLight),
            ),
            const SizedBox(height: 24),

            // Responsive Row/Column for Subject & Category
            if (isFormWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildTextField(
                        "Subject *", "Brief description of your issue",
                        controller: _subjectController),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: _buildDropdownField(
                        "Category *", "Select category",
                        items: ["Technical Issue", "Billing", "General"],
                        value: _selectedCategory, onChanged: (val) {
                      setState(() => _selectedCategory = val);
                    }),
                  ),
                ],
              )
            else
              Column(
                children: [
                  _buildTextField("Subject *", "Brief description of your issue",
                      controller: _subjectController),
                  const SizedBox(height: 16),
                  _buildDropdownField("Category *", "Select category",
                      items: ["Technical Issue", "Billing", "General"],
                      value: _selectedCategory, onChanged: (val) {
                    setState(() => _selectedCategory = val);
                  }),
                ],
              ),

            const SizedBox(height: 16),

            // Priority
            _buildDropdownField("Priority", "Select priority",
                items: [
                  "Low - General Question",
                  "Medium - Issue affecting usage",
                  "High - System Down"
                ],
                value: _selectedPriority, onChanged: (val) {
              setState(() => _selectedPriority = val);
            }),

            const SizedBox(height: 16),

            // Description
            _buildTextField(
              "Description *",
              "Please provide detailed information about your issue, including steps to reproduce if applicable...",
              maxLines: 5,
              controller: _descController,
            ),

            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Submit Support Ticket",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // Helper Widgets specific to form
  Widget _buildTextField(String label, String hint,
      {int maxLines = 1, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600, color: _textDark),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: _textLight, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: _borderGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: _primaryBlue),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String hint,
      {required List<String> items,
      required String? value,
      required Function(String?) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600, color: _textDark),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _borderGrey),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(hint,
                  style: TextStyle(color: _textLight, fontSize: 14)),
              icon: Icon(Icons.keyboard_arrow_down, color: _textLight),
              isExpanded: true,
              style: TextStyle(color: _textDark, fontSize: 14),
              dropdownColor: Colors.white,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}