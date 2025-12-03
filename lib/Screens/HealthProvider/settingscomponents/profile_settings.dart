import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_input_field.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  // ---------------- Controllers ----------------
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController license = TextEditingController();
  final TextEditingController experience = TextEditingController();
  final TextEditingController fee = TextEditingController();

  final TextEditingController specialtyController = TextEditingController();
  final TextEditingController achievementController = TextEditingController();

  List<String> specialties = [];
  List<String> achievements = [];

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  String? userKey;
  String? userRole;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initAndLoad();
  }

  Future<void> _initAndLoad() async {
    final prefs = await SharedPreferences.getInstance();
    userKey = prefs.getString("userKey");
    userRole = prefs.getString("userRole"); // expected: "providers"

    if (userKey == null || userKey!.isEmpty || userRole == null || userRole!.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      setState(() => isLoading = false);
      return;
    }

    await _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final snap = await _dbRef.child("healthcare/users/$userRole/$userKey").get();

      if (snap.exists) {
        final data = Map<String, dynamic>.from(snap.value as Map);

        setState(() {
          firstName.text = data["first_name"] ?? data["firstName"] ?? "";
          lastName.text = data["last_name"] ?? data["lastName"] ?? "";
          email.text = data["email"] ?? "";
          phone.text = data["phone"] ?? "";
          license.text = data["medicalLicense"] ?? "";
          experience.text = data["experienceYears"]?.toString() ?? "";
          fee.text = data["consultationFee"]?.toString() ?? "";

          specialties = List<String>.from(data["specialties"] ?? []);
          achievements = List<String>.from(data["achievements"] ?? []);

          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading profile: $e")),
      );
    }
  }

  Future<void> saveProfile() async {
    if (userKey == null || userRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User Not Found")),
      );
      return;
    }

    final profileMap = {
      "firstName": firstName.text.trim(),
      "lastName": lastName.text.trim(),
      "email": email.text.trim(),
      "phone": phone.text.trim(),
      "medicalLicense": license.text.trim(),
      "experienceYears": experience.text.trim(),
      "consultationFee": fee.text.trim(),
      "specialties": specialties,
      "achievements": achievements,
      "updatedAt": DateTime.now().toIso8601String(),
    };

    try {
      await _dbRef.child("healthcare/users/$userRole/$userKey").update(profileMap);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Profile saved successfully")));

      await _loadProfile();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to save profile: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

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
              Expanded(child: _labeledInputField("First Name", firstName, Icons.person)),
              const SizedBox(width: 16),
              Expanded(child: _labeledInputField("Last Name", lastName, Icons.person_outline)),
            ],
          ),

          const SizedBox(height: 16),

          // ---------------- EMAIL + PHONE ----------------
          Row(
            children: [
              Expanded(child: _labeledInputField("Email", email, Icons.email_outlined)),
              const SizedBox(width: 16),
              Expanded(child: _labeledInputField("Phone", phone, Icons.phone)),
            ],
          ),

          const SizedBox(height: 16),

          _labeledInputField("Medical License Number", license, Icons.badge_outlined),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(child: _labeledInputField("Years of Experience", experience, Icons.timeline)),
              const SizedBox(width: 16),
              Expanded(child: _labeledInputField("Consultation Fee (₹)", fee, Icons.currency_rupee)),
            ],
          ),

          const SizedBox(height: 16),

          _inputField("Professional Bio", "", maxLines: 4),

          const SizedBox(height: 30),

          // ---------------- SPECIALTIES ----------------
          const Text("Specialties", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
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
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

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

          // ---------------- ACHIEVEMENTS ----------------
          const Text("Achievements & Awards",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: achievements.map((a) {
              return Chip(
                label: Text(a),
                backgroundColor: Colors.amber.shade50,
                side: BorderSide(color: Colors.amber.shade200),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => setState(() => achievements.remove(a)),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

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

          // ---------------- SAVE BUTTON ----------------
          SizedBox(
            width: 200,
            child: CustomButton(
              text: "Save Profile",
              icon: Icons.save,
              onPressed: saveProfile,
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _labeledInputField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        CustomInputField(labelText: "", icon: icon, controller: controller),
      ],
    );
  }

  Widget _inputField(String label, String placeholder, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: placeholder,
            filled: true,
            fillColor: Colors.white,
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
