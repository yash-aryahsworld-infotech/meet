import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class DoctorListComponent extends StatefulWidget {
  const DoctorListComponent({super.key});

  @override
  State<DoctorListComponent> createState() => _DoctorListComponentState();
}

class _DoctorListComponentState extends State<DoctorListComponent> {
  List<Map<String, dynamic>> allDoctors = [];
  List<Map<String, dynamic>> filteredDoctors = [];

  String selectedCategory = "All";
  String searchQuery = "";
  
  // 🟢 State Variables
  bool loading = true; // For initial Firebase fetch

  // 📍 Location State variables
  double? userLat;
  double? userLng;
  double filterDistanceKm = 7.0; 

  final double defaultLat = 19.0760;
  final double defaultLng = 72.8777;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition();
        if (mounted) {
          setState(() {
            userLat = position.latitude;
            userLng = position.longitude;
          });
        }
      } else {
        setState(() {
          userLat = defaultLat;
          userLng = defaultLng;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          userLat = defaultLat;
          userLng = defaultLng;
        });
      }
    }
    fetchDoctors();
  }

  double _calculateDistance(
      double lat1, double lon1, double? lat2, double? lon2) {
    if (lat2 == null || lon2 == null) return 99999.0;
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> fetchDoctors() async {
    try {
      final ref = FirebaseDatabase.instance.ref("healthcare/doctors_map");
      final snapshot = await ref.get();

      if (snapshot.exists) {
        List<Map<String, dynamic>> doctors = [];
        Map data = snapshot.value as Map;

        data.forEach((key, value) {
          double? docLat;
          double? docLng;
          if (value["location"] != null) {
            docLat = double.tryParse(value["location"]["lat"].toString());
            docLng = double.tryParse(value["location"]["lng"].toString());
          }

          double distance = _calculateDistance(
            userLat ?? defaultLat,
            userLng ?? defaultLng,
            docLat,
            docLng,
          );

          doctors.add({
            "id": key,
            "title": value["title"] ?? "Unknown Doctor",
            "category": value["categoryName"] ?? "General",
            "address": value["address"] ?? "No address provided",
            "rating": value["totalScore"]?.toString() ?? "0",
            "reviews": value["reviewsCount"] ?? 0,
            "phone": value["phone"] ?? "",
            "isOpen": value["openingHours"] != null,
            "image": value["imageUrl"] ?? "",
            "url": value["url"] ?? "",
            "distance": distance,
          });
        });

        doctors.sort((a, b) =>
            (a["distance"] as double).compareTo(b["distance"] as double));

        if (mounted) {
          setState(() {
            allDoctors = doctors;
            // Initially show doctors within default distance
            filteredDoctors = allDoctors.where((doc) => (doc["distance"] as double) <= filterDistanceKm).toList();
            loading = false;
          });
        }
      } else {
        if (mounted) setState(() => loading = false);
      }
    } catch (e) {
      if (mounted) setState(() => loading = false);
    }
  }

  // 🟢 2. Search Function (No Artificial Delay)
  void applyFilter() {
    // 1. Set Loading to TRUE
    setState(() {
      loading = true;
    });

    // We use a microtask or zero-duration future to ensure the UI 
    // has a chance to repaint the "loading" spinner before the calculation runs.
    Future.delayed(Duration.zero, () {
      if (!mounted) return;

      // 2. Perform the logic
      final results = allDoctors.where((doc) {
        bool matchCategory =
            selectedCategory == "All" || doc["category"] == selectedCategory;
        bool matchSearch = doc["title"]
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
        bool matchDistance = (doc["distance"] as double) <= filterDistanceKm;

        return matchCategory && matchSearch && matchDistance;
      }).toList();

      // 3. Set Loading to FALSE
      setState(() {
        filteredDoctors = results;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories = [
      "All",
      ...{for (var doc in allDoctors) doc["category"] as String},
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// ------------------------------------------
        /// 1. 🔍 SEARCH & FILTER HEADER
        /// ------------------------------------------
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Search Bar + Search Button
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        textInputAction: TextInputAction.search,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: "Search doctors...",
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.blueAccent),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (val) {
                          searchQuery = val;
                        },
                        onSubmitted: (val) {
                          applyFilter();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // 🟢 Search Button with Spinner
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: ElevatedButton(
                      onPressed: loading ? null : applyFilter,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Icon(Icons.search),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 2: Category + Distance
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: Colors.grey),
                          value: categories.contains(selectedCategory)
                              ? selectedCategory
                              : "All",
                          items: categories
                              .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black87),
                                  )))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                selectedCategory = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Nearby Distance: ${filterDistanceKm.toStringAsFixed(1)} km",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black87),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 4.0,
                              thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 8.0),
                              overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 16.0),
                            ),
                            child: Slider(
                              value: filterDistanceKm,
                              min: 1.0,
                              max: 50.0,
                              activeColor: Colors.blueAccent,
                              inactiveColor: Colors.blue.shade100,
                              onChanged: (val) {
                                setState(() {
                                  filterDistanceKm = val;
                                });
                                // Only visual update, search button applies logic
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "${filteredDoctors.length} found",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),

        /// ------------------------------------------
        /// 2. 📋 SCROLLABLE LIST
        /// ------------------------------------------
        if (loading)
          const Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(),
          )
        else if (filteredDoctors.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32.0),
            child: Text("No doctors found matching criteria"),
          )
        else
          ListView.builder(
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredDoctors.length,
            itemBuilder: (context, index) {
              final doc = filteredDoctors[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: DoctorCard(doc: doc),
              );
            },
          ),
      ],
    );
  }
}

class DoctorCard extends StatelessWidget {
  final Map<String, dynamic> doc;

  const DoctorCard({super.key, required this.doc});

  Future<void> _launchURL(String urlString) async {
    if (urlString.isEmpty) return;
    final Uri url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Error launching URL: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: Colors.blueAccent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc["title"],
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${doc["category"]} • Walk-in clinic",
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, size: 12, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            "${doc["rating"]}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${(doc["distance"] as double).toStringAsFixed(1)} km away",
                      style: const TextStyle(
                          fontSize: 11, color: Colors.blueAccent),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 16, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    doc["address"],
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
             const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone_outlined,
                    size: 16, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  doc["phone"].toString(),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.call, size: 16),
                    label: const Text("Call"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      foregroundColor: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _launchURL(doc["url"]),
                    icon: const Icon(Icons.location_on, size: 16),
                    label: const Text("View Map"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}