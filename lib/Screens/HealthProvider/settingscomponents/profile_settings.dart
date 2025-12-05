import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Ensure these point to your actual widget files
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
  final TextEditingController qualification = TextEditingController();
  final TextEditingController experience = TextEditingController();
  final TextEditingController fee = TextEditingController();
  final TextEditingController bio = TextEditingController();
  final TextEditingController achievementController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  // Controller for manual specialty entry
  final TextEditingController manualSpecialtyController = TextEditingController();

  // ---------------- Data State ----------------
  List<String> specialties = [];       // List 1: Selected from Dropdown
  List<String> customSpecialties = []; // List 2: Manually Typed
  
  List<String> achievements = [];
  List<String> _masterSpecialties = [];
  List<String> languages = []; 
  String? _selectedDropdownValue;

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
    userRole = prefs.getString("userRole");

    if (userKey == null || userKey!.isEmpty || userRole == null || userRole!.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User not logged in")));
      setState(() => isLoading = false);
      return;
    }

    await Future.wait([_loadProfile(), _loadMasterSpecialties()]);
  }

  Future<void> _loadMasterSpecialties() async {
    try {
      final snap = await _dbRef.child("healthcare/config/specialties").get();
      if (snap.exists) {
        final List<dynamic> data = snap.value as List<dynamic>;
        setState(() {
          _masterSpecialties = data.map((e) => e is Map ? e['name'].toString() : e.toString()).toList();
        });
      }
    } catch (e) {
      debugPrint("Error loading master specialties: $e");
    }
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
          qualification.text = data["qualification"] ?? "";
          experience.text = data["experienceYears"]?.toString() ?? "";
          fee.text = data["consultationFee"]?.toString() ?? "";
          bio.text = data["bio"] ?? "";
          
          // LOAD LIST 1
          specialties = List<String>.from(data["specialties"] ?? []);
          // LOAD LIST 2
          customSpecialties = List<String>.from(data["customSpecialties"] ?? []);
          
          achievements = List<String>.from(data["achievements"] ?? []);
          
          languages = List<String>.from(data["languages"] ?? []);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> saveProfile() async {
    if (userKey == null || userRole == null) return;

    final profileMap = {
      "firstName": firstName.text.trim(),
      "lastName": lastName.text.trim(),
      "email": email.text.trim(), 
      "phone": phone.text.trim(),
      "medicalLicense": license.text.trim(),
      "qualification": qualification.text.trim(),
      "experienceYears": experience.text.trim(),
      "consultationFee": fee.text.trim(),
      "bio": bio.text.trim(),
      
      // SAVE SEPARATELY
      "specialties": specialties,       // Standard
      "customSpecialties": customSpecialties, // Manual
      
      "achievements": achievements,
       "languages": languages,
      "updatedAt": DateTime.now().toIso8601String(),
    };

    try {
      await _dbRef.child("healthcare/users/$userRole/$userKey").update(profileMap);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile saved successfully")));
      }
      await _loadProfile();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to save profile: $e")));
      }
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
          const Text("Professional Information", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text("Update your professional details and qualifications", style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          const SizedBox(height: 25),

          // ---------------- PHOTO SECTION ----------------
          Row(
            children: [
              Container(
                width: 75, height: 75,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100, shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Icon(Icons.person, size: 40, color: Colors.grey),
              ),
              const SizedBox(width: 20),
              OutlinedButton.icon(
                onPressed: () {}, 
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  foregroundColor: Colors.black87,
                ),
                icon: const Icon(Icons.camera_alt_outlined, size: 18),
                label: const Text("Change Photo"),
              ),
            ],
          ),
          
          const SizedBox(height: 30),

          // ---------------- NAME ----------------
          Row(
            children: [
              Expanded(child: _labeledInputField("First Name", firstName, Icons.person)),
              const SizedBox(width: 16),
              Expanded(child: _labeledInputField("Last Name", lastName, Icons.person_outline)),
            ],
          ),
          const SizedBox(height: 16),

          // ---------------- EMAIL (DISABLED) + PHONE ----------------
          Row(
            children: [
              // Email Field - Read Only
              Expanded(
                child: _labeledInputField("Email", email, Icons.email_outlined, isReadOnly: true)
              ),
              const SizedBox(width: 16),
              Expanded(child: _labeledInputField("Phone", phone, Icons.phone)),
            ],
          ),
          const SizedBox(height: 16),

          // ---------------- QUALIFICATION + LICENSE ----------------
          Row(
            children: [
              Expanded(child: _labeledInputField("Qualification (e.g. MBBS)", qualification, Icons.school_outlined)),
              const SizedBox(width: 16),
              Expanded(child: _labeledInputField("Medical License", license, Icons.badge_outlined)),
            ],
          ),

          const SizedBox(height: 16),

          // ---------------- EXPERIENCE + FEE ----------------
          Row(
            children: [
              Expanded(child: _labeledInputField("Years Exp.", experience, Icons.timeline)),
              const SizedBox(width: 16),
              Expanded(child: _labeledInputField("Consultation Fee (₹)", fee, Icons.currency_rupee)),
            ],
          ),

          const SizedBox(height: 16),
          _labeledMultilineField("Professional Bio", bio, 4),
          const SizedBox(height: 30),

          // ============================================================
          //             LIST 1: STANDARD SPECIALTIES (Dropdown)
          // ============================================================
          const Text("Standard Specialties", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),

          // Chips for List 1
          if (specialties.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Wrap(
                spacing: 10, runSpacing: 10,
                children: specialties.map((s) {
                  return Chip(
                    label: Text(s),
                    backgroundColor: Colors.blue.shade50,
                    side: BorderSide(color: Colors.blue.shade100),
                    deleteIcon: const Icon(Icons.close, size: 18, color: Colors.blue),
                    onDeleted: () => setState(() => specialties.remove(s)),
                  );
                }).toList(),
              ),
            ),

          // Dropdown Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedDropdownValue,
                isExpanded: true,
                hint: const Text("Select from list...", style: TextStyle(color: Colors.grey)),
                items: _masterSpecialties.map((String name) {
                  return DropdownMenuItem<String>(value: name, child: Text(name));
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null && !specialties.contains(newValue)) {
                    setState(() { specialties.add(newValue); _selectedDropdownValue = null; });
                  }
                },
              ),
            ),
          ),
          
          const SizedBox(height: 30),

          // ============================================================
          //             LIST 2: OTHER SPECIALTIES (Manual Text)
          // ============================================================
          const Text("Other Specialties", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),

          // Chips for List 2
          if (customSpecialties.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Wrap(
                spacing: 10, runSpacing: 10,
                children: customSpecialties.map((s) {
                  return Chip(
                    label: Text(s),
                    backgroundColor: Colors.orange.shade50, // Different color for distinction
                    side: BorderSide(color: Colors.orange.shade200),
                    deleteIcon: const Icon(Icons.close, size: 18, color: Colors.orange),
                    onDeleted: () => setState(() => customSpecialties.remove(s)),
                  );
                }).toList(),
              ),
            ),

          // Manual Input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: manualSpecialtyController,
                  decoration: _inputDecoration("Type custom specialty..."),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 50, width: 80,
                child: CustomButton(
                  text: "Add",
                  textColor: Colors.black,
                  outlineColor: Colors.grey,
                  colors: const [Colors.white, Colors.white],
                  onPressed: () {
                    final value = manualSpecialtyController.text.trim();
                    if (value.isNotEmpty && !customSpecialties.contains(value)) {
                      setState(() {
                        customSpecialties.add(value);
                        manualSpecialtyController.clear();
                      });
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),
            const Text("Languages Spoken", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),

          if (languages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Wrap(
                spacing: 10, runSpacing: 10,
                children: languages.map((l) {
                  return Chip(
                    label: Text(l),
                    // Purple Theme for Languages
                    backgroundColor: Colors.purple.shade50,
                    side: BorderSide(color: Colors.purple.shade200),
                    deleteIcon: const Icon(Icons.close, size: 18, color: Colors.purple),
                    onDeleted: () => setState(() => languages.remove(l)),
                  );
                }).toList(),
              ),
            ),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: languageController,
                  decoration: _inputDecoration("Add language (e.g. English, Marathi)"),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 50, width: 80,
                child: CustomButton(
                  text: "Add",
                  textColor: Colors.black,
                  outlineColor: Colors.grey,
                  colors: const [Colors.white, Colors.white],
                  onPressed: () {
                    final value = languageController.text.trim();
                    if (value.isNotEmpty && !languages.contains(value)) {
                      setState(() {
                        languages.add(value);
                        languageController.clear();
                      });
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // ---------------- ACHIEVEMENTS ----------------
          const Text("Achievements & Awards", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),

          Wrap(
            spacing: 10, runSpacing: 10,
            children: achievements.map((a) {
              return Chip(
                label: Text(a),
                backgroundColor: Colors.green.shade50,
                side: BorderSide(color: Colors.green.shade200),
                deleteIcon: const Icon(Icons.close, size: 18, color: Colors.green),
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
                  decoration: _inputDecoration("Add achievement"),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 50, width: 80,
                child: CustomButton(
                  text: "Add", textColor: Colors.black, outlineColor: Colors.grey,
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
          SizedBox(
            width: 200,
            child: CustomButton(text: "Save Profile", icon: Icons.save, onPressed: saveProfile),
          ),
        ],
      ),
    );
  }

  // --- Helpers ---

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
    );
  }

  Widget _labeledInputField(String label, TextEditingController controller, IconData icon, {bool isReadOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        isReadOnly 
        ? TextField(
            controller: controller,
            readOnly: true,
            style: TextStyle(color: Colors.grey.shade700),
            decoration: _inputDecoration("").copyWith(
              fillColor: Colors.grey.shade100,
              prefixIcon: Icon(icon, color: Colors.grey),
            ),
          )
        : CustomInputField(labelText: "", icon: icon, controller: controller),
      ],
    );
  }

  Widget _labeledMultilineField(String label, TextEditingController controller, int lines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: lines,
          decoration: _inputDecoration(""),
        ),
      ],
    );
  }
}