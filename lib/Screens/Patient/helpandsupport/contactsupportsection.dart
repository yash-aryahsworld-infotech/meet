import 'package:flutter/material.dart';

class ContactSupportSection extends StatefulWidget {
  const ContactSupportSection({super.key});

  @override
  State<ContactSupportSection> createState() => _ContactSupportSectionState();
}

class _ContactSupportSectionState extends State<ContactSupportSection> {
  // Form Controllers & Values
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String? _selectedCategory;
  String? _selectedPriority = "Medium - Issue affecting usage";

  // Colors extracted from image
  final Color _primaryBlue = const Color(0xFF1665D8);
  final Color _textDark = const Color(0xFF2E3A59);
  final Color _textLight = const Color(0xFF8F9BB3);
  final Color _borderGrey = const Color(0xFFE4E9F2);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Breakpoint for switching from Stacked (Mobile) to Row (Desktop)
        bool isWide = constraints.maxWidth > 800;
        // Breakpoint for form fields (Subject/Category side-by-side)
        bool isFormWide = constraints.maxWidth > 600;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------------------
            // 1. TOP CONTACT CARDS SECTION
            // -------------------------------
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildContactCard(0)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildContactCard(1)), // Chat (Middle)
                  const SizedBox(width: 16),
                  Expanded(child: _buildContactCard(2)),
                ],
              )
            else
              Column(
                children: [
                  _buildContactCard(0),
                  const SizedBox(height: 16),
                  _buildContactCard(1),
                  const SizedBox(height: 16),
                  _buildContactCard(2),
                ],
              ),

            const SizedBox(height: 32),

            // -------------------------------
            // 2. TICKET FORM SECTION
            // -------------------------------
            Container(
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

                  // Row 1: Subject + Category
                  if (isFormWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 2,
                            child: _buildTextField(
                                "Subject *", "Brief description of your issue",
                                controller: _subjectController)),
                        const SizedBox(width: 16),
                        Expanded(
                            flex: 1,
                            child: _buildDropdownField(
                                "Category *", "Select category",
                                items: ["Technical Issue", "Billing", "General"],
                                value: _selectedCategory, onChanged: (val) {
                              setState(() => _selectedCategory = val);
                            })),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _buildTextField(
                            "Subject *", "Brief description of your issue",
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

                  // Row 2: Priority
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

                  // Row 3: Description
                  _buildTextField(
                    "Description *",
                    "Please provide detailed information about your issue, including steps to reproduce if applicable...",
                    maxLines: 5,
                    controller: _descController,
                  ),

                  const SizedBox(height: 24),

                  // Row 4: Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle submit logic
                      },
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
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // -------------------------------------------------------------------------
  // HELPER WIDGETS
  // -------------------------------------------------------------------------

  Widget _buildContactCard(int index) {
    // Data definition for the 3 cards
    final cards = [
      {
        "icon": Icons.phone_in_talk_outlined,
        "title": "Phone Support",
        "desc": "Available 24/7 for emergencies\n9 AM - 9 PM for general support",
        "actionText": "+91-1800-123-4567",
        "isButton": false,
      },
      {
        "icon": Icons.chat_bubble_outline,
        "title": "Live Chat",
        "desc": "Chat with our support team\nAverage response: 2-5 minutes",
        "actionText": "Start Chat",
        "isButton": true,
      },
      {
        "icon": Icons.email_outlined,
        "title": "Email Support",
        "desc": "Email us your questions\nResponse within 24 hours",
        "actionText": "support@healthcare-plus.com",
        "isButton": false,
      },
    ];

    final data = cards[index];
    final bool isButton = data["isButton"] as bool;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderGrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(data["icon"] as IconData, size: 32, color: _primaryBlue),
          const SizedBox(height: 16),
          Text(
            data["title"] as String,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data["desc"] as String,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: _textLight,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          if (isButton)
            SizedBox(
              width: double.infinity,
              height: 40,
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
                child: Text(data["actionText"] as String),
              ),
            )
          else
            Text(
              data["actionText"] as String,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _textDark,
              ),
            ),
        ],
      ),
    );
  }

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