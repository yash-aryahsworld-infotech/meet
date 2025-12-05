import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Profile/add_family_sheet.dart';
import 'Profile/generic_profile_form.dart';
import 'Profile/profile_selector.dart';

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

  // --- 1. Load Data ---
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
        String? restoredKey;
        if (data.containsKey('selectedProfileKey')) {
          String savedKey = data['selectedProfileKey'];

          // --- UPDATED LOGIC ---
          // 1. If the saved key matches the logged-in userKey, it means "Main User" is selected.
          //    We keep restoredKey as null (since null drives the Main User UI).
          if (savedKey == userKey) {
            restoredKey = null; 
          } 
          // 2. Otherwise, check if it matches a family member
          else {
            bool memberExists = loadedFamily.any((m) => m['key'] == savedKey);
            if (memberExists) {
              restoredKey = savedKey;
            }
          }
        }

        if (mounted) {
          setState(() {
            mainProfileData = data;
            familyMembers = loadedFamily;
            selectedFamilyKey = restoredKey;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  // --- 2. Switch & Persist Selection (Updated) ---
  Future<void> _switchProfile(String? key) async {
    // 1. Update UI immediately (Locally, null still means Main User)
    setState(() => selectedFamilyKey = key);

    // 2. Save choice to Firebase
    if (key == null) {
      // --- UPDATED LOGIC ---
      // If switching to Main User (null), store the actual userKey in DB 
      // instead of removing the node.
      if (userKey != null) {
        await _dbRef.child("healthcare/users/patients/$userKey/selectedProfileKey").set(userKey);
      }
    } else {
      // If switching to Family Member, store their specific key
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
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saved!")));
        _loadData(); 
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
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
          if (mounted) {
            Navigator.pop(context);
            _loadData();
          }
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
            onSelect: _switchProfile, 
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
