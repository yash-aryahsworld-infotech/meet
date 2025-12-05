
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './near_by_health_provider/doctor_card.dart'; 

// --- Icon Helper ---
class IconHelper {
  static IconData getIcon(String iconName) {
    switch (iconName) {
      case 'medical_services_outlined': return Icons.medical_services_outlined;
      case 'face': return Icons.face;
      case 'psychology': return Icons.psychology;
      case 'hearing': return Icons.hearing;
      case 'pregnant_woman': return Icons.pregnant_woman;
      case 'favorite': return Icons.favorite;
      case 'water_drop': return Icons.water_drop;
      case 'child_care': return Icons.child_care;
      case 'waves': return Icons.waves;
      case 'psychology_alt': return Icons.psychology_alt;
      case 'bloodtype': return Icons.bloodtype;
      case 'accessibility_new': return Icons.accessibility_new;
      case 'person_add_alt': return Icons.person_add_alt;
      case 'spa': return Icons.spa;
      case 'local_florist': return Icons.local_florist;
      default: return Icons.local_hospital;
    }
  }

  static Color getColor(String? hexString) {
    if (hexString == null || hexString.isEmpty) return Colors.blue;
    try {
      return Color(int.parse(hexString));
    } catch (e) {
      return Colors.blue;
    }
  }
}

class DoctorDiscoveryPage extends StatefulWidget {
  const DoctorDiscoveryPage({super.key});

  @override
  State<DoctorDiscoveryPage> createState() => _DoctorDiscoveryPageState();
}

class _DoctorDiscoveryPageState extends State<DoctorDiscoveryPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  
  String _selectedFilter = "All";
  String _searchQuery = "";
  String? _currentUserKey;
  
  List<Map<String, dynamic>> _specialties = [];
  bool _isLoadingSpecialties = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _fetchSpecialties();
  }

  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) setState(() => _currentUserKey = prefs.getString("userKey"));
  }

  Future<void> _fetchSpecialties() async {
    try {
      final snapshot = await _dbRef.child("healthcare/config/specialties").get();
      if (snapshot.exists) {
        final List<dynamic> rawData = snapshot.value as List<dynamic>;
        if (mounted) {
          setState(() {
            _specialties = rawData.map((e) => Map<String, dynamic>.from(e as Map)).toList();
            _isLoadingSpecialties = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoadingSpecialties = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingSpecialties = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int gridCrossAxisCount = width > 600 ? 8 : 4; 

    // FIX: Removed 'Expanded' and outer 'Column'. 
    // Everything is now inside ONE SingleChildScrollView.
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- A. Search Bar (Now scrolls with content) ---
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: "Search doctor by name...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none
                ),
              ),
            ),
            
            const SizedBox(height: 15),

            // --- B. Header Row ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Specialties",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => setState(() => _selectedFilter = "All"),
                  child: Text(
                    "View All", 
                    style: TextStyle(color: _selectedFilter == "All" ? Colors.blue : Colors.grey)
                  ),
                )
              ],
            ),

            // --- C. Specialty Grid ---
            if (_isLoadingSpecialties)
              const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
            else if (_specialties.isNotEmpty)
              GridView.builder(
                shrinkWrap: true, // CRITICAL: Allows Grid inside ScrollView
                physics: const NeverScrollableScrollPhysics(), // CRITICAL: Disables Grid's own scrolling
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridCrossAxisCount,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _specialties.length,
                itemBuilder: (context, index) {
                  final item = _specialties[index];
                  final String name = item['name'];
                  final String iconStr = item['icon'];
                  final String colorHex = item['color'];
                  final bool isSelected = _selectedFilter == name;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = name),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue.shade100 : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2))
                            ]
                          ),
                          child: Icon(
                            IconHelper.getIcon(iconStr),
                            color: IconHelper.getColor(colorHex),
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11, 
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? Colors.blue : Colors.black87
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            // --- D. Dynamic Title ---
            Text(
              _selectedFilter == "All" ? "All Available Doctors" : "$_selectedFilter Doctors",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // --- E. Doctor List ---
            StreamBuilder(
              stream: _dbRef.child("healthcare/users/providers").onValue,
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Padding(padding: EdgeInsets.all(20), child: Text("Something went wrong"));
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));

                if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                  return const Padding(padding: EdgeInsets.all(20), child: Text("No doctors available."));
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

                  if (matchesFilter && matchesSearch) {
                    doctors.add(doc);
                  }
                });

                if (doctors.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Center(child: Text("No doctors found matching criteria.")),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true, // CRITICAL: Allows List inside ScrollView
                  physics: const NeverScrollableScrollPhysics(), // CRITICAL: Disables List's own scrolling
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
