
import 'package:flutter/material.dart';
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

  final List<String> _filters = ["All", "General Physician", "Cardiologist", "Pediatrician", "Dermatologist"];

  // Doctor Data
  final List<Map<String, dynamic>> _doctors = [
    {
      "name": "Dr. Sarah Wilson",
      "specialty": "General Physician",
      "degree": "MBBS, MD", 
      "experience": "8 Years",
      "about": "Dr. Sarah is a compassionate General Physician with 8 years of experience.",
      "image": "images/female.jpg", // Ensure this exists or use network URL
      "price": 299,
      "rating": 4.8,
      "durations": ["10 min", "30 min"]
    },
    {
      "name": "Dr. Raj Patel",
      "specialty": "Cardiologist",
      "degree": "MBBS, DM (Cardio)", 
      "experience": "15+ Years",
      "about": "Dr. Raj Patel is a renowned Cardiologist specializing in interventional cardiology.",
      "image": "https://randomuser.me/api/portraits/men/32.jpg",
      "price": 599,
      "rating": 4.9,
      "durations": ["15 min", "45 min", "1 hr"]
    },
    {
      "name": "Dr. Emily Chen",
      "specialty": "Dermatologist",
      "degree": "MBBS, MD (Derma)",
      "experience": "5 Years",
      "about": "Dr. Emily helps patients achieve healthy skin through personalized care.",
      "image": "https://randomuser.me/api/portraits/women/44.jpg",
      "price": 399,
      "rating": 4.5,
      "durations": ["10 min", "20 min"]
    },
  ];

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
              child: filteredDoctors.isEmpty
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
