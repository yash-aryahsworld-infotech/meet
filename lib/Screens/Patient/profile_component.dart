import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthcare_plus/Screens/Patient/profile/add_family.dart';
import 'package:healthcare_plus/Screens/Patient/profile/generic_profile.dart';
import 'package:healthcare_plus/Screens/Patient/profile/profile_selector.dart';

class PatientProfileManager extends StatefulWidget {
  const PatientProfileManager({super.key});

  @override
  State<PatientProfileManager> createState() => _PatientProfileManagerState();
}

class _PatientProfileManagerState extends State<PatientProfileManager> {
  // --- Firebase & State ---
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  bool isLoading = true;
  String? userKey;

  // --- Data Storage ---
  Map<String, dynamic>? mainProfileData;
  List<Map<String, dynamic>> familyMembers = [];

  // --- Selection State ---
  // null = Main User. String = Family Key.
  String? selectedFamilyKey; 

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // --- 1. Load Data (Updated to Fetch Selection) ---
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    userKey = prefs.getString("userKey");
    
    if (userKey == null) {
      if (mounted) setState(() => isLoading = false);
      return;
    }

    try {
      final snap = await _dbRef.child("healthcare/users/patients/$userKey").get();
      
      if (snap.exists) {
        final data = Map<String, dynamic>.from(snap.value as Map);
        
        // A. Parse Family Members
        final List<Map<String, dynamic>> loadedFamily = [];
        if (data["family"] != null) {
          final familyMap = Map<String, dynamic>.from(data["family"] as Map);
          familyMap.forEach((k, v) {
            final member = Map<String, dynamic>.from(v as Map);
            member['key'] = k; 
            loadedFamily.add(member);
          });
        }

        // B. Restore Previous Selection
        // We check if the backend has a saved selection key
        String? restoredKey;
        if (data.containsKey('selectedProfileKey')) {
          String savedKey = data['selectedProfileKey'];
          // Validation: Ensure the saved family member actually still exists
          bool memberExists = loadedFamily.any((m) => m['key'] == savedKey);
          if (memberExists) {
            restoredKey = savedKey;
          }
        }

        if (mounted) {
          setState(() {
            mainProfileData = data;
            familyMembers = loadedFamily;
            selectedFamilyKey = restoredKey; // <--- Set the restored selection
            isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  // --- 2. Switch & Persist Selection (NEW) ---
  Future<void> _switchProfile(String? key) async {
    // 1. Update UI immediately
    setState(() => selectedFamilyKey = key);

    // 2. Save choice to Firebase
    // If key is null (Main User), we remove the field. 
    // If key is String, we save it.
    if (key == null) {
      await _dbRef.child("healthcare/users/patients/$userKey/selectedProfileKey").remove();
    } else {
      await _dbRef.child("healthcare/users/patients/$userKey/selectedProfileKey").set(key);
    }
  }

  // --- 3. Save Profile Details ---
  Future<void> _saveProfileDetails(Map<String, dynamic> updatedData) async {
    String path = selectedFamilyKey == null
        ? "healthcare/users/patients/$userKey"
        : "healthcare/users/patients/$userKey/family/$selectedFamilyKey";

    try {
      updatedData['updatedAt'] = DateTime.now().toIso8601String();
      await _dbRef.child(path).update(updatedData);
      
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saved!")));
      _loadData(); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // --- 4. Add Family Logic ---
  void _openAddFamilySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddFamilySheet(
        onSave: (newData) async {
          await _dbRef.child("healthcare/users/patients/$userKey/family").push().set(newData);
          Navigator.pop(context);
          _loadData();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (userKey == null) return const Center(child: Text("Please Log In"));

    final isMainUser = selectedFamilyKey == null;
    final activeData = isMainUser
        ? (mainProfileData ?? {})
        : familyMembers.firstWhere((m) => m['key'] == selectedFamilyKey, orElse: () => {});

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // --- Selector ---
          ProfileSelector(
            mainUser: mainProfileData,
            familyMembers: familyMembers,
            selectedKey: selectedFamilyKey,
            onSelect: _switchProfile, // <--- Now calls the persisting function
            onAddFamily: _openAddFamilySheet,
          ),

          const Divider(height: 40, thickness: 1),

          // --- Form ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isMainUser ? "My Details" : "Family Member Details",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
                const SizedBox(height: 15),

                GenericProfileForm(
                  key: ValueKey(selectedFamilyKey ?? "MAIN"), 
                  initialData: activeData,
                  isMainUser: isMainUser,
                  onSave: _saveProfileDetails,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}