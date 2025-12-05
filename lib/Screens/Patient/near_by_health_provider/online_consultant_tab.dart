
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import './healthcare_filters.dart';
import './doctor_card.dart';

class OnlineConsultantPage extends StatefulWidget {
  const OnlineConsultantPage({super.key});

  @override
  State<OnlineConsultantPage> createState() => _OnlineConsultantPageState();
}

class _OnlineConsultantPageState extends State<OnlineConsultantPage> {
  String _selectedFilter = "All";
  String _searchQuery = "";
  bool _isLoading = true;
  
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  List<String> _filters = ["All"];
  List<Map<String, dynamic>> _doctors = [];

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    setState(() => _isLoading = true);

    try {
      final snapshot = await _database.child('healthcare/users/providers').get();

      if (!snapshot.exists) {
        setState(() {
          _doctors = [];
          _isLoading = false;
        });
        return;
      }

      final providersData = snapshot.value as Map<dynamic, dynamic>;
      final loadedDoctors = <Map<String, dynamic>>[];
      final specialtiesSet = <String>{'All'};

      providersData.forEach((key, value) {
        final doctor = value as Map<dynamic, dynamic>;
        
        // Build doctor data
        final firstName = doctor['firstName']?.toString() ?? '';
        final lastName = doctor['lastName']?.toString() ?? '';
        final name = 'Dr. $firstName $lastName'.trim();
        
        // Get specialties
        final specialties = doctor['specialties'];
        String specialty = 'General Physician';
        if (specialties != null) {
          if (specialties is List && specialties.isNotEmpty) {
            specialty = specialties[0].toString();
            // Add all specialties to filter
            for (var spec in specialties) {
              specialtiesSet.add(spec.toString());
            }
          } else if (specialties is String) {
            specialty = specialties;
            specialtiesSet.add(specialty);
          }
        }

        // Get languages
        final languages = doctor['languages'];
        List<String> languagesList = [];
        if (languages != null) {
          if (languages is List) {
            languagesList = languages.map((e) => e.toString()).toList();
          } else if (languages is Map) {
            // Firebase sometimes returns arrays as maps with numeric keys
            languagesList = languages.values.map((e) => e.toString()).toList();
          } else if (languages is String) {
            languagesList = [languages];
          }
        }

        loadedDoctors.add({
          'userKey': key,
          'name': name,
          'specialty': specialty,
          'specialties': specialties is List ? specialties : [specialty],
          'degree': doctor['medicalLicense']?.toString() ?? 'MBBS',
          'experience': '${doctor['experienceYears'] ?? '0'} Years',
          'about': doctor['about']?.toString() ?? 'Experienced healthcare professional',
          'image': doctor['profileImage']?.toString() ?? '',
          'price': int.tryParse(doctor['consultationFee']?.toString() ?? '0') ?? 0,
          'rating': 4.5, // Default rating
          'durations': ['10 min', '30 min', '45 min'],
          'phone': doctor['phone']?.toString() ?? '',
          'email': doctor['email']?.toString() ?? '',
          'languages': languagesList,
        });
      });

      setState(() {
        _doctors = loadedDoctors;
        _filters = specialtiesSet.toList()..sort();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _doctors = [];
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load doctors: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. FILTER LOGIC
    final filteredDoctors = _doctors.where((doctor) {
      final matchesFilter = _selectedFilter == "All" || doctor['specialty'] == _selectedFilter;
      final searchLower = _searchQuery.toLowerCase();
      final matchesSearch = doctor['name'].toString().toLowerCase().contains(searchLower) ||
                            doctor['specialty'].toString().toLowerCase().contains(searchLower);
      return matchesFilter && matchesSearch;
    }).toList();

    // 2. HEIGHT CALCULATION (Prevents Rendering Issues)
    double contentHeight = MediaQuery.of(context).size.height * 0.75;

    // 3. MAIN UI (No Tabs)
    return SizedBox(
      height: contentHeight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: "Search doctor, specialty...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Filters
            HealthcareFilters(
              filters: _filters,
              selectedFilter: _selectedFilter,
              onFilterSelected: (val) => setState(() => _selectedFilter = val),
            ),
            const SizedBox(height: 20),

            // Doctor List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredDoctors.isEmpty
                      ? const Center(child: Text("No doctors found."))
                      : ListView.builder(
                          itemCount: filteredDoctors.length,
                          itemBuilder: (context, index) {
                            return DoctorCard(doctor: filteredDoctors[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
