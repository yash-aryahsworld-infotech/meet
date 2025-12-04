import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './healthcare_filters.dart';
import './doctor_card.dart';

class OnlineConsultantPage extends StatefulWidget {
  const OnlineConsultantPage({super.key});

  @override
  State<OnlineConsultantPage> createState() => _OnlineConsultantPageState();
}

class _OnlineConsultantPageState extends State<OnlineConsultantPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  String _selectedFilter = "All";
  String _searchQuery = "";
  String? _currentUserKey;

  final List<String> _filters = ["All", "General Physician", "Cardiologist", "Pediatrician", "Dermatologist"];

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _currentUserKey = prefs.getString("userKey");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Component height logic (Assuming parent handles safe area/bounds)
    double contentHeight = MediaQuery.of(context).size.height * 0.75;

    return SizedBox(
      height: contentHeight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: "Search doctor...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 15),

            HealthcareFilters(
              filters: _filters,
              selectedFilter: _selectedFilter,
              onFilterSelected: (val) => setState(() => _selectedFilter = val),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: StreamBuilder(
                stream: _dbRef.child("healthcare/users/providers").onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasError) return const Center(child: Text("Something went wrong"));
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

                  if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                    return const Center(child: Text("No doctors available."));
                  }

                  final dataMap = Map<dynamic, dynamic>.from(snapshot.data!.snapshot.value as Map);
                  final List<Map<String, dynamic>> doctors = [];

                  dataMap.forEach((key, value) {
                    final doc = Map<String, dynamic>.from(value);
                    doc['key'] = key; 
                    
                    String specialtyStr = "General";
                    if (doc['specialties'] != null && (doc['specialties'] as List).isNotEmpty) {
                      specialtyStr = (doc['specialties'] as List).first.toString();
                    }
                    doc['displaySpecialty'] = specialtyStr;

                    final matchesFilter = _selectedFilter == "All" || specialtyStr == _selectedFilter;
                    final matchesSearch = doc['firstName'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
                                          specialtyStr.toLowerCase().contains(_searchQuery.toLowerCase());

                    if (matchesFilter && matchesSearch) doctors.add(doc);
                  });

                  if (doctors.isEmpty) return const Center(child: Text("No doctors found."));

                  return ListView.builder(
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      return DoctorCard(
                        doctor: doctors[index], 
                        patientUserKey: _currentUserKey, 
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}