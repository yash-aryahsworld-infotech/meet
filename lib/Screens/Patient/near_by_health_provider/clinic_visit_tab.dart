import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import this
import './healthcare_filters.dart';
import './doctor_details_page.dart';
import './booking_bottom_sheet.dart'; 

class ClinicVisitPage extends StatefulWidget {
  const ClinicVisitPage({super.key});

  @override
  State<ClinicVisitPage> createState() => _ClinicVisitPageState();
}

class _ClinicVisitPageState extends State<ClinicVisitPage> {
  String _selectedFilter = "All";
  String _searchQuery = "";
  String? _currentUserKey; // Store user key here

  final List<String> _filters = ["All", "General Physician", "Dentist", "Cardiologist", "Orthopedic"];

  // Mock Data (Must include 'key' for booking logic to work, even if fake)
  final List<Map<String, dynamic>> _clinicDoctors = [
    {
      "key": "dummy_doc_1", // Required for booking
      "name": "Dr. Amit Verma",
      "degree": "MBBS, MD",
      "specialty": "General Physician",
      "experience": "12 Years",
      "about": "Senior physician specializing in diabetes.",
      "address": "Sunshine Clinic, Andheri West",
      "phone": "9876543210",
      "image": "https://randomuser.me/api/portraits/men/32.jpg",
      "price": 500,
      "rating": 4.7,
      "distance": "1.2 km"
    },
    {
      "key": "dummy_doc_2",
      "name": "Dr. Sneha Kapoor",
      "degree": "BDS, MDS",
      "specialty": "Dentist",
      "experience": "8 Years",
      "about": "Specializes in cosmetic dentistry.",
      "address": "Smile Care, Bandra",
      "phone": "9876543211",
      "image": "https://randomuser.me/api/portraits/women/44.jpg",
      "price": 800,
      "rating": 4.9,
      "distance": "3.5 km"
    },
  ];

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

  void _makePhoneCall(String phoneNumber) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Calling $phoneNumber...")));
  }

  @override
  Widget build(BuildContext context) {
    double contentHeight = MediaQuery.of(context).size.height * 0.75;

    final filteredDoctors = _clinicDoctors.where((doctor) {
      final matchesFilter = _selectedFilter == "All" || doctor['specialty'] == _selectedFilter;
      final searchLower = _searchQuery.toLowerCase();
      final matchesSearch = doctor['name'].toString().toLowerCase().contains(searchLower) ||
                            doctor['specialty'].toString().toLowerCase().contains(searchLower);
      return matchesFilter && matchesSearch;
    }).toList();

    return SizedBox(
      height: contentHeight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: "Search clinic...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
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
              child: filteredDoctors.isEmpty
                  ? const Center(child: Text("No clinics found."))
                  : ListView.builder(
                      itemCount: filteredDoctors.length,
                      itemBuilder: (context, index) {
                        return _buildClinicCard(filteredDoctors[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClinicCard(Map<String, dynamic> doctor) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorDetailsPage(
                    doctor: doctor,
                    patientUserKey: _currentUserKey, // Pass user key
                  )),
                );
              },
              child: Container(
                color: Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.blue.shade50,
                      backgroundImage: NetworkImage(doctor['image']),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doctor['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(doctor['degree'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
                          Text(doctor['specialty'], style: TextStyle(color: Colors.blue.shade700, fontSize: 13)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Expanded(child: Text(doctor['address'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Colors.grey.shade700))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(4)),
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: Colors.green, size: 12),
                              const SizedBox(width: 4),
                              Text("${doctor['rating']}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text("₹${doctor['price']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Divider(height: 1),
            const SizedBox(height: 10),

            Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () => _makePhoneCall(doctor['phone']),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade50, padding: EdgeInsets.zero, elevation: 0),
                    child: const Icon(Icons.call, size: 22, color: Colors.green),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentUserKey == null) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please login first")));
                          return;
                        }
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                          builder: (context) => BookingBottomSheet(doctor: doctor, patientKey: _currentUserKey!),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: const Text("Book Appointment", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}