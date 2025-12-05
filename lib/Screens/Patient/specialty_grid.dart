import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './near_by_health_provider/doctor_card.dart';

// ---- ICON HELPER ----
class IconHelper {
  static final Map<String, IconData> specialtyIcons = {
    "Cardiologist": Icons.favorite,
    "Dentist": Icons.medical_services_outlined,
    "Psychologist": Icons.psychology,
    "ENT": Icons.hearing,
    "Gynecologist": Icons.pregnant_woman,
    "Dermatologist": Icons.face,
    "Pediatrician": Icons.child_care,
    "Neurologist": Icons.psychology_alt,
    "Orthopedic": Icons.accessibility_new,
    "Physician": Icons.local_hospital,
    "General": Icons.person_add_alt,
  };

  static IconData getIconForSpecialty(String name) {
    return specialtyIcons[name] ?? Icons.local_hospital;
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

  bool _loadingSpecialties = true;
  List<String> _specialtyList = [];

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _fetchSpecialtiesFromDoctors();
  }

  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserKey = prefs.getString("userKey");
    setState(() {});
  }

  // 🔥 Fetch specialties DIRECTLY from doctor data
  Future<void> _fetchSpecialtiesFromDoctors() async {
    try {
      final snapshot = await _dbRef.child("healthcare/users/providers").get();
      Set<String> specialtiesSet = {};

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);

        data.forEach((key, value) {
          final doctor = Map<String, dynamic>.from(value);

          if (doctor["specialties"] != null) {
            for (var sp in doctor["specialties"]) {
              specialtiesSet.add(sp.toString());
            }
          }
        });
      }

      _specialtyList = specialtiesSet.toList()..sort();

      setState(() => _loadingSpecialties = false);
    } catch (e) {
      setState(() => _loadingSpecialties = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int gridCrossAxisCount = width > 600 ? 8 : 4;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- SEARCH BAR ----------------
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: "Search doctor...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Specialties",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => setState(() => _selectedFilter = "All"),
                  child: Text(
                    "View All",
                    style: TextStyle(
                        color:
                            _selectedFilter == "All" ? Colors.blue : Colors.grey),
                  ),
                )
              ],
            ),

            // ---------------- SPECIALTY GRID ----------------
            if (_loadingSpecialties)
              const Center(child: CircularProgressIndicator())
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _specialtyList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridCrossAxisCount,
                  childAspectRatio: 0.82,
                ),
                itemBuilder: (_, index) {
                  final name = _specialtyList[index];
                  final isSelected = _selectedFilter == name;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = name),
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue.shade100
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? Border.all(color: Colors.blue, width: 2)
                                : null,
                          ),
                          child: Icon(IconHelper.getIconForSpecialty(name),
                              size: 26,
                              color: isSelected ? Colors.blue : Colors.black87),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500),
                        )
                      ],
                    ),
                  );
                },
              ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            Text(
              _selectedFilter == "All"
                  ? "All Available Doctors"
                  : "$_selectedFilter Specialists",
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // ---------------- DOCTOR LIST ----------------
            StreamBuilder(
              stream: _dbRef.child("healthcare/users/providers").onValue,
              builder: (_, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.data!.snapshot.value == null) {
                  return const Text("No doctors found.");
                }

                final map = Map<String, dynamic>.from(
                    snapshot.data!.snapshot.value as Map);

                final doctors = map.values.map((doc) {
                  return Map<String, dynamic>.from(doc);
                }).where((doc) {
                  final specialty = (doc["specialties"] != null &&
                          doc["specialties"].isNotEmpty)
                      ? doc["specialties"][0]
                      : "General";

                  final matchesFilter =
                      _selectedFilter == "All" || specialty == _selectedFilter;

                  final matchesSearch =
                      doc["firstName"]
                          .toString()
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase());

                  return matchesFilter && matchesSearch;
                }).toList();

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: doctors.length,
                  itemBuilder: (_, i) => DoctorCard(
                    doctor: doctors[i],
     
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
