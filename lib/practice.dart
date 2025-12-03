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
  // Controllers
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
  String? userRole; // from prefs
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initAndLoad();
  }

  Future<void> _initAndLoad() async {
    final prefs = await SharedPreferences.getInstance();
    userKey = prefs.getString("userKey");
    userRole = prefs.getString("userRole"); // should be "providers"

    if (userKey == null || userKey!.isEmpty || userRole == null || userRole!.isEmpty) {
      // not logged in
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User not logged in")));
      }
      setState(() => isLoading = false);
      return;
    }

    await _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (userKey == null || userRole == null) return;
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
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error loading profile: $e")));
    }
  }

  Future<void> saveProfile() async {
    if (userKey == null || userRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User not available")));
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
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile saved successfully")));
      await _loadProfile(); // refresh
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to save profile: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Professional Information", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(child: _labeledInputField("First Name", firstName, Icons.person)),
              const SizedBox(width: 12),
              Expanded(child: _labeledInputField("Last Name", lastName, Icons.person_outline)),
            ],
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _labeledInputField("Email", email, Icons.email)),
              const SizedBox(width: 12),
              Expanded(child: _labeledInputField("Phone", phone, Icons.phone)),
            ],
          ),

          const SizedBox(height: 12),
          _labeledInputField("Medical License", license, Icons.badge),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _labeledInputField("Experience (Years)", experience, Icons.timeline)),
              const SizedBox(width: 12),
              Expanded(child: _labeledInputField("Consultation Fee (₹)", fee, Icons.currency_rupee)),
            ],
          ),

          const SizedBox(height: 18),
          const Text("Specialties", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: specialties.map((s) {
            return Chip(label: Text(s), onDeleted: () => setState(() => specialties.remove(s)));
          }).toList()),

          Row(children: [
            Expanded(child: TextField(controller: specialtyController, decoration: _inputDecoration("Add Specialty"))),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: () {
              final v = specialtyController.text.trim();
              if (v.isNotEmpty && !specialties.contains(v)) {
                setState(() {
                  specialties.add(v);
                  specialtyController.clear();
                });
              }
            }, child: const Text("Add"))
          ]),

          const SizedBox(height: 18),
          const Text("Achievements", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: achievements.map((a) {
            return Chip(label: Text(a), onDeleted: () => setState(() => achievements.remove(a)));
          }).toList()),

          Row(children: [
            Expanded(child: TextField(controller: achievementController, decoration: _inputDecoration("Add Achievement"))),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: () {
              final v = achievementController.text.trim();
              if (v.isNotEmpty && !achievements.contains(v)) {
                setState(() {
                  achievements.add(v);
                  achievementController.clear();
                });
              }
            }, child: const Text("Add"))
          ]),

          const SizedBox(height: 20),
          ElevatedButton.icon(onPressed: saveProfile, icon: const Icon(Icons.save), label: const Text("Save Profile")),
        ],
      ),
    );
  }

  Widget _labeledInputField(String label, TextEditingController controller, IconData icon) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      CustomInputField(labelText: "", icon: icon, controller: controller),
    ]);
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(hintText: hint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)));
  }
}
