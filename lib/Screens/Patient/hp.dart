import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';

// Import your card component
import './near_by_health_provider/near_by_doctor_card.dart';

class DoctorListComponent extends StatefulWidget {
  const DoctorListComponent({super.key});

  @override
  State<DoctorListComponent> createState() => _DoctorListComponentState();
}

class _DoctorListComponentState extends State<DoctorListComponent> with WidgetsBindingObserver {
  List<Map<String, dynamic>> allDoctors = [];
  List<Map<String, dynamic>> filteredDoctors = [];

  String selectedCategory = "All";
  String searchQuery = "";
  
  // 🟢 State Variables
  bool loading = true;
  
  // distinct error states to show different buttons
  bool isServiceDisabled = false; 
  bool isPermissionDenied = false; 
  String? errorMessage; 

  // 📍 Location State variables
  double? userLat;
  double? userLng;
  double filterDistanceKm = 7.0; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); 
    _getUserLocation(); 
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 🟢 Detect when user comes back from Settings (App settings or GPS toggle)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // If we were previously in an error state, try again automatically
      if (isServiceDisabled || isPermissionDenied || errorMessage != null) {
        _getUserLocation();
      }
    }
  }

  Future<void> _getUserLocation() async {
    if (!mounted) return;

    setState(() {
      loading = true;
      isServiceDisabled = false;
      isPermissionDenied = false;
      errorMessage = null;
    });

    try {
      // 1. Check if GPS/Location Service is ENABLED
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        setState(() {
          isServiceDisabled = true;
          errorMessage = "Location services are disabled. Please turn on GPS.";
          loading = false;
        });
        return;
      }

      // 2. Check Permissions
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        // Request permission
        permission = await Geolocator.requestPermission();
        
        if (permission == LocationPermission.denied) {
          if (!mounted) return;
          setState(() {
            isPermissionDenied = true;
            errorMessage = "Location permission is denied.";
            loading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        setState(() {
          isPermissionDenied = true;
          errorMessage = "Location permission is permanently denied. Please enable it in App Settings.";
          loading = false;
        });
        return;
      }

      // 3. Permission Granted & Service On -> Get Position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      
      if (mounted) {
        setState(() {
          userLat = position.latitude;
          userLng = position.longitude;
        });
        fetchDoctors();
      }

    } catch (e) {
      debugPrint("Location error: $e");
      if (mounted) {
        setState(() {
          errorMessage = "Error determining location: $e";
          loading = false;
        });
      }
    }
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
            userLat ?? 0,
            userLng ?? 0,
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

  void applyFilter() {
    setState(() {
      loading = true;
    });

    Future.delayed(Duration.zero, () {
      if (!mounted) return;

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

      setState(() {
        filteredDoctors = results;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    
    // 🔴 1. Error View 
    if (errorMessage != null || isServiceDisabled || isPermissionDenied) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_off, size: 64, color: Colors.redAccent),
              const SizedBox(height: 24),
              Text(
                isServiceDisabled ? "GPS is Disabled" : "Permission Required",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                errorMessage ?? "To find nearby doctors, please allow location access.",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 32),
              
              // 🟢 Dynamic Button based on Error Type
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                     if (isServiceDisabled) {
                       // Opens GPS Toggle Settings
                       await Geolocator.openLocationSettings();
                     } else {
                       // Opens App Permission Settings
                       await Geolocator.openAppSettings();
                     }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  child: Text(isServiceDisabled ? "Turn on GPS" : "Open App Settings"),
                ),
              ),
              const SizedBox(height: 16),
              
              // Retry Button
              TextButton.icon(
                onPressed: _getUserLocation,
                icon: const Icon(Icons.refresh),
                label: const Text("Try Again"),
              )
            ],
          ),
        ),
      );
    }

    // 🔴 2. Loading View
    if (loading && allDoctors.isEmpty) {
       return const Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             CircularProgressIndicator(),
             SizedBox(height: 16),
             Text("Finding doctors nearby...")
           ],
         )
       );
    }

    List<String> categories = [
      "All",
      ...{for (var doc in allDoctors) doc["category"] as String},
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ... (Header Search & Slider Code remains exactly the same as previous) ...
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
                              "Nearby: ${filterDistanceKm.toStringAsFixed(1)} km",
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

        // List
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