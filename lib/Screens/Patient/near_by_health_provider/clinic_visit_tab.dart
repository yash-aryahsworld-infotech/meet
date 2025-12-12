import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
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
  bool _isLoading = true;
  
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  List<String> _filters = ["All"];
  List<Map<String, dynamic>> _clinicDoctors = [];

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
          _clinicDoctors = [];
          _isLoading = false;
        });
        return;
      }

      final providersData = snapshot.value as Map<dynamic, dynamic>;
      final loadedDoctors = <Map<String, dynamic>>[];
      final specialtiesSet = <String>{'All'};

      providersData.forEach((key, value) {
        final doctor = value as Map<dynamic, dynamic>;
        
        final firstName = doctor['firstName']?.toString() ?? '';
        final lastName = doctor['lastName']?.toString() ?? '';
        final name = 'Dr. $firstName $lastName'.trim();
        
        final specialties = doctor['specialties'];
        String specialty = 'General Physician';
        if (specialties != null) {
          if (specialties is List && specialties.isNotEmpty) {
            specialty = specialties[0].toString();
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
          'address': doctor['address']?.toString() ?? 'Clinic Address',
          'phone': doctor['phone']?.toString() ?? '',
          'image': doctor['profileImage']?.toString() ?? '',
          'price': int.tryParse(doctor['consultationFee']?.toString() ?? '0') ?? 0,
          'rating': 4.5,
          'distance': '2.5 km',
          'email': doctor['email']?.toString() ?? '',
          'languages': languagesList,
          'type': 'Clinic', // Consultation type for clinic visit
        });
      });

      setState(() {
        _clinicDoctors = loadedDoctors;
        _filters = specialtiesSet.toList()..sort();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _clinicDoctors = [];
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load doctors: $e')),
        );
      }
    }
  }

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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredDoctors.isEmpty
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
                      tag: 'doctor_${doctor['userKey'] ?? doctor['id'] ?? doctor['name']}_${doctor['image']}',
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
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.language, size: 14, color: Colors.blue.shade600),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Builder(
                                  builder: (context) {
                                    final languages = doctor['languages'];
                                    if (languages == null || (languages is List && languages.isEmpty)) {
                                      return const Text(
                                        'Languages not specified',
                                        style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
                                      );
                                    }
                                    final langList = languages as List;
                                    final displayText = langList.take(3).join(', ') + 
                                      (langList.length > 3 ? ' +${langList.length - 3}' : '');
                                    return Text(
                                      displayText,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 11, color: Colors.blue.shade700, fontWeight: FontWeight.w600),
                                    );
                                  },
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