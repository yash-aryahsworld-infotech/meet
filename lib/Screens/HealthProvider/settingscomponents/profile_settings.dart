import 'package:flutter/material.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_input_field.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  // ---------------- Controllers ----------------
  final TextEditingController firstName = TextEditingController(text: "Berry");
  final TextEditingController lastName = TextEditingController(text: "Alien");
  final TextEditingController email = TextEditingController(text: "abcd@gmail.com");
  final TextEditingController phone = TextEditingController();
  final TextEditingController license = TextEditingController();
  final TextEditingController experience = TextEditingController(text: "10");
  final TextEditingController fee = TextEditingController(text: "500");

  // Specialties
  final List<String> specialties = ["General Medicine"];
  final TextEditingController specialtyController = TextEditingController();

  // ---------------- NEW: Achievements Controllers ----------------
  final List<String> achievements = ["Best Doctor Award 2023"];
  final TextEditingController achievementController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Professional Information",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            "Update your professional details and qualifications",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),

          const SizedBox(height: 25),

          // ---------------- PROFILE PHOTO ----------------
          Row(
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: const Icon(Icons.person, size: 40),
              ),
              const SizedBox(width: 16),
              SizedBox(
                height: 50,
                width: 160,
                child: CustomButton(
                  height: 30,
                  text: "Change Photo",
                  buttonPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                  icon: Icons.camera_alt_outlined,
                  colors: const [Colors.white, Colors.white],
                  textColor: Colors.black,
                  outlineColor: Colors.black,
                  onPressed: () {},
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // ---------------- NAME FIELDS ----------------
          Row(
            children: [
              Expanded(
                child: _labeledInputField("First Name", firstName, Icons.person),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _labeledInputField("Last Name", lastName, Icons.person_outline),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ---------------- EMAIL + PHONE ----------------
          Row(
            children: [
              Expanded(
                child: _labeledInputField("Email", email, Icons.email_outlined),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _labeledInputField("Phone", phone, Icons.phone),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _labeledInputField(
            "Medical License Number",
            license,
            Icons.badge_outlined,
          ),

          const SizedBox(height: 16),

          // ---------------- EXPERIENCE + FEE ----------------
          Row(
            children: [
              Expanded(
                child: _labeledInputField("Years of Experience", experience, Icons.timeline),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _labeledInputField("Consultation Fee (₹)", fee, Icons.currency_rupee),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ---------------- BIO ----------------
          _inputField("Professional Bio", "", maxLines: 4),

          const SizedBox(height: 30),

          // ---------------- SPECIALTIES SECTION ----------------
          const Text(
            "Specialties",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: specialties.map((s) {
              return Chip(
                label: Text(s),
                backgroundColor: Colors.grey.shade200,
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => setState(() => specialties.remove(s)),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Add Specialty Input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: specialtyController,
                  decoration: _inputDecoration("Add specialty (e.g., Cardiology)"),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 50,
                width: 100,
                child: CustomButton(
                  text: "Add",
                  textColor: Colors.black,
                  outlineColor: Colors.grey,
                  colors: const [Colors.white, Colors.white],
                  onPressed: () {
                    final value = specialtyController.text.trim();
                    if (value.isNotEmpty && !specialties.contains(value)) {
                      setState(() {
                        specialties.add(value);
                        specialtyController.clear();
                      });
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // ---------------- NEW: ACHIEVEMENTS SECTION ----------------
          const Text(
            "Achievements & Awards",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          // Display Achievements Chips
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: achievements.map((a) {
              return Chip(
                label: Text(a),
                backgroundColor: Colors.amber.shade50, // Different color for awards
                side: BorderSide(color: Colors.amber.shade200),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => setState(() => achievements.remove(a)),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Add Achievement Input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: achievementController,
                  decoration: _inputDecoration("Add achievement (e.g., Gold Medalist)"),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 50,
                width: 100,
                child: CustomButton(
                  text: "Add",
                  textColor: Colors.black,
                  outlineColor: Colors.grey,
                  colors: const [Colors.white, Colors.white],
                  onPressed: () {
                    final value = achievementController.text.trim();
                    if (value.isNotEmpty && !achievements.contains(value)) {
                      setState(() {
                        achievements.add(value);
                        achievementController.clear();
                      });
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // ---------------- SAVE PROFILE ----------------
          SizedBox(
            width: 200,
            child: CustomButton(
              text: "Save Profile",
              icon: Icons.save,
              onPressed: () {
                // TODO: Handle Save Logic
                print("Saved Specialties: $specialties");
                print("Saved Achievements: $achievements");
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper for Input Decoration to avoid code repetition
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  // ---------------- LABEL + CUSTOM INPUT FIELD ----------------
  Widget _labeledInputField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        CustomInputField(
          labelText: "",
          icon: icon,
          controller: controller,
        ),
      ],
    );
  }

  // ---------------- OLD BIO INPUT FIELD ----------------
  Widget _inputField(
    String label,
    String placeholder, {
    bool readOnly = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          readOnly: readOnly,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: placeholder,
            filled: true,
            fillColor: readOnly ? Colors.grey.shade100 : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}