import 'package:flutter/material.dart';
 // Optional: If you use real calling
import './healthcare_filters.dart';
import './doctor_details_page.dart';
import './booking_bottom_sheet.dart'; // <--- IMPORT THIS

class ClinicVisitPage extends StatefulWidget {
  const ClinicVisitPage({super.key});

  @override
  State<ClinicVisitPage> createState() => _ClinicVisitPageState();
}

class _ClinicVisitPageState extends State<ClinicVisitPage> {
  String _selectedFilter = "All";
  String _searchQuery = "";

  final List<String> _filters = ["All", "General Physician", "Dentist", "Cardiologist", "Orthopedic"];

  // --- MOCK DATA ---
  final List<Map<String, dynamic>> _clinicDoctors = [
    {
      "name": "Dr. Amit Verma",
      "degree": "MBBS, MD (Medicine)",
      "specialty": "General Physician",
      "experience": "12 Years",
      "about": "Dr. Amit is a senior physician at Sunshine Clinic specializing in diabetes and hypertension management.",
      "address": "Sunshine Clinic, Andheri West, Mumbai",
      "phone": "9876543210",
      "image": "https://randomuser.me/api/portraits/men/32.jpg",
      "price": 500,
      "rating": 4.7,
      "distance": "1.2 km"
    },
    {
      "name": "Dr. Sneha Kapoor",
      "degree": "BDS, MDS",
      "specialty": "Dentist",
      "experience": "8 Years",
      "about": "Dr. Sneha specializes in cosmetic dentistry, root canals, and implants.",
      "address": "Smile Care, Bandra, Mumbai",
      "phone": "9876543211",
      "image": "https://randomuser.me/api/portraits/women/44.jpg",
      "price": 800,
      "rating": 4.9,
      "distance": "3.5 km"
    },
    {
      "name": "Dr. Robert D'souza",
      "degree": "MBBS, MS (Ortho)",
      "specialty": "Orthopedic",
      "experience": "20+ Years",
      "about": "Dr. Robert is a leading orthopedic surgeon known for joint replacement surgeries.",
      "address": "City Hospital, Dadar, Mumbai",
      "phone": "9876543212",
      "image": "https://randomuser.me/api/portraits/men/11.jpg",
      "price": 1000,
      "rating": 4.5,
      "distance": "5.0 km"
    },
  ];

  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else {
      return AssetImage(imagePath);
    }
  }

  void _makePhoneCall(String phoneNumber) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Calling $phoneNumber...")),
    );
  }

  @override
  Widget build(BuildContext context) {
    double contentHeight = MediaQuery.of(context).size.height * 0.75;

    final filteredDoctors = _clinicDoctors.where((doctor) {
      final matchesFilter = _selectedFilter == "All" || doctor['specialty'] == _selectedFilter;
      final searchLower = _searchQuery.toLowerCase();
      final matchesSearch = doctor['name'].toString().toLowerCase().contains(searchLower) ||
                            doctor['specialty'].toString().toLowerCase().contains(searchLower) ||
                            doctor['address'].toString().toLowerCase().contains(searchLower);
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
                hintText: "Search doctor, clinic, location...",
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
            // --- CLICKABLE PROFILE SECTION ---
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorDetailsPage(doctor: doctor)),
                );
              },
              child: Container(
                color: Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: doctor['image'],
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.blue.shade50,
                        backgroundImage: _getImageProvider(doctor['image']),
                      ),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  doctor['address'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                ),
                              ),
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
                        const Text("Consultation", style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // --- ACTION BUTTONS (Call + Book) ---
            Row(
              children: [
                // Call Button (Small)
                SizedBox(
                  width: 50,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () => _makePhoneCall(doctor['phone']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade50,
                      foregroundColor: Colors.green,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Icon(Icons.call, size: 22),
                  ),
                ),
                const SizedBox(width: 10),

                // Book Appointment Button (Big)
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        // --- UPDATED: Open Booking Bottom Sheet ---
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => BookingBottomSheet(doctor: doctor),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
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