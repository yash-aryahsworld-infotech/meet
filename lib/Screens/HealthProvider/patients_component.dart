import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthcare_plus/Screens/HealthProvider/patientscomponents/patient_appointment_list.dart';

// Assuming these exist in your project structure
import '../../widgets/custom_tab.dart'; 
import '../../widgets/custom_header.dart'; 

class PatientsComponent extends StatefulWidget {
  const PatientsComponent({super.key});

  @override
  State<PatientsComponent> createState() => _PatientsComponentState();
}

class _PatientsComponentState extends State<PatientsComponent> {
  int selectedTab = 0;
  String? doctorKey;
  bool _isLoading = true;
  String _searchQuery = "";

  final List<String> tabTitles = ["All Patients", "Recent Visits", "Upcoming"];
  
  List<AppointmentModel> _allAppointments = [];
  List<AppointmentModel> _recentAppointments = [];
  List<AppointmentModel> _upcomingAppointments = [];
  
  DatabaseReference? _appointmentsRef;
  
  // Dynamic counts based on our data
  List<int> get tabCounts => [
    _allAppointments.length,
    _recentAppointments.length,
    _upcomingAppointments.length,
  ];

  @override
  void initState() {
    super.initState();
    _initAndLoadPatients();
  }

  @override
  void dispose() {
    // Clean up the listener when widget is disposed
    _appointmentsRef?.onValue.drain();
    super.dispose();
  }

  Future<void> _initAndLoadPatients() async {
    setState(() => _isLoading = true);

    // Get doctor info from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    doctorKey = prefs.getString("userKey");

    if (doctorKey == null || doctorKey!.isEmpty) {
      _showSnackBar("Doctor not logged in", bg: Colors.red);
      setState(() => _isLoading = false);
      return;
    }

    // Set up real-time listener for appointments
    _setupRealtimeListener();

    setState(() => _isLoading = false);
  }

  void _setupRealtimeListener() {
    _appointmentsRef = FirebaseDatabase.instance.ref("healthcare/all_appointments");
    
    _appointmentsRef!.onValue.listen((event) {
      if (!mounted) return;
      
      if (!event.snapshot.exists) {
        setState(() {
          _allAppointments = [];
          _recentAppointments = [];
          _upcomingAppointments = [];
        });
        return;
      }

      _processAppointmentsSnapshot(event.snapshot);
    }, onError: (error) {
      if (mounted) {
        _showSnackBar("Error loading appointments: $error", bg: Colors.red);
      }
    });
  }

  Future<void> _processAppointmentsSnapshot(DataSnapshot snapshot) async {
    try {
      Map<dynamic, dynamic> appointmentsData = snapshot.value as Map<dynamic, dynamic>;
      List<AppointmentModel> loadedAppointments = [];

      // Parse appointments
      for (var entry in appointmentsData.entries) {
        final appointmentData = entry.value as Map<dynamic, dynamic>;
        
        // Skip cancelled appointments
        final status = appointmentData['status']?.toString() ?? "";
        if (status == 'cancelled') continue;
        
        // Get appointment doctor fields
        final appointmentDoctorId = appointmentData['doctorId']?.toString() ?? "";
        final selectedProfileKey = appointmentData['selectedProfileKey']?.toString() ?? "";
        final doctorKeyStr = doctorKey?.toString() ?? "";
        
        // Match appointments for this doctor - check doctorId field
        bool isMatch = appointmentDoctorId == doctorKeyStr;
        
        if (isMatch) {
          
          // Get patient details
          final patientId = appointmentData['patientId']?.toString() ?? "";
          
          // Use data directly from appointment record
          String patientName = appointmentData['patientName']?.toString() ?? "Unknown Patient";
          String patientImage = "";
          String gender = "Unknown";
          int age = 0;
          
          // Try to get additional patient data if patientId exists
          if (patientId.isNotEmpty) {
            final patientData = await _getPatientData(patientId);
            if (patientData != null) {
              patientImage = patientData['profileImage']?.toString() ?? "";
              gender = patientData['gender']?.toString() ?? "Unknown";
              
              // Get age directly from database
              if (patientData['age'] != null) {
                age = int.tryParse(patientData['age'].toString()) ?? 0;
              }
            }
          }
          
          // Get family member profile info from selectedProfileKey
          String? bookingForInfo;
          if (selectedProfileKey.isNotEmpty && patientId.isNotEmpty) {
            final profileData = await _getFamilyMemberProfile(patientId, selectedProfileKey);
            if (profileData != null) {
              final profileName = profileData['name']?.toString() ?? "";
              final relationship = profileData['relationship']?.toString() ?? "";
              
              if (profileName.isNotEmpty && relationship.isNotEmpty) {
                bookingForInfo = "$profileName ($relationship)";
              } else if (profileName.isNotEmpty) {
                bookingForInfo = profileName;
              } else if (relationship.isNotEmpty) {
                bookingForInfo = relationship;
              }
            }
          }
          
          // Build appointment reason/history
          String appointmentReason = appointmentData['reason']?.toString() ?? 
                                    appointmentData['complaint']?.toString() ?? 
                                    appointmentData['symptoms']?.toString() ?? 
                                    "General Consultation";
          
          // Get date and time from appointment data
          String appointmentDate = appointmentData['date']?.toString() ?? "";
          final appointmentTime = appointmentData['time']?.toString() ?? 
                                 appointmentData['selectedTime']?.toString() ?? 
                                 appointmentData['timeSlot']?.toString() ?? "";
          
          // If no date field, try to use timestamp
          if (appointmentDate.isEmpty && appointmentData['timestamp'] != null) {
            try {
              final timestamp = appointmentData['timestamp'];
              final dateTime = DateTime.fromMillisecondsSinceEpoch(
                timestamp is int ? timestamp : int.parse(timestamp.toString())
              );
              appointmentDate = dateTime.toIso8601String();
            } catch (e) {
              // Failed to parse timestamp
            }
          }
          
          loadedAppointments.add(AppointmentModel(
            name: patientName,
            image: patientImage,
            history: appointmentReason,
            time: _formatAppointmentTime(appointmentDate, appointmentTime),
            gender: gender,
            age: age,
            status: appointmentData['status']?.toString() ?? "Scheduled",
            appointmentId: appointmentData['appointmentId']?.toString() ?? entry.key,
            patientId: patientId,
            bookingFor: bookingForInfo,
          ));
        }
      }

      // Sort by date/time
      loadedAppointments.sort((a, b) => _compareAppointmentTimes(a.time, b.time));

      if (mounted) {
        setState(() {
          _allAppointments = loadedAppointments;
          _filterAppointments();
        });
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar("Failed to process appointments: $e", bg: Colors.red);
      }
    }
  }

  Future<Map<dynamic, dynamic>?> _getPatientData(String patientId) async {
    try {
      final ref = FirebaseDatabase.instance.ref("healthcare/users/patients/$patientId");
      final snapshot = await ref.get();
      
      if (snapshot.exists) {
        return snapshot.value as Map<dynamic, dynamic>;
      }
    } catch (e) {
      // Error getting patient data
    }
    return null;
  }

  Future<Map<dynamic, dynamic>?> _getFamilyMemberProfile(String patientId, String profileKey) async {
    try {
      final ref = FirebaseDatabase.instance.ref("healthcare/users/patients/$patientId/familyMembers/$profileKey");
      final snapshot = await ref.get();
      
      if (snapshot.exists) {
        return snapshot.value as Map<dynamic, dynamic>;
      }
    } catch (e) {
      // Error getting family member profile
    }
    return null;
  }

  void _filterAppointments() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    _recentAppointments = _allAppointments.where((appointment) {
      final appointmentDate = _parseAppointmentDate(appointment.time);
      return appointmentDate != null && appointmentDate.isBefore(today);
    }).toList();

    _upcomingAppointments = _allAppointments.where((appointment) {
      final appointmentDate = _parseAppointmentDate(appointment.time);
      return appointmentDate != null && 
             (appointmentDate.isAtSameMomentAs(today) || appointmentDate.isAfter(today));
    }).toList();
  }

  String _formatAppointmentTime(String? date, String? time) {
    if (date == null || date.isEmpty) return "Not scheduled";
    
    try {
      final appointmentDate = DateTime.parse(date);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));
      final appointmentDay = DateTime(appointmentDate.year, appointmentDate.month, appointmentDate.day);

      String dayLabel;
      if (appointmentDay == today) {
        dayLabel = "Today";
      } else if (appointmentDay == tomorrow) {
        dayLabel = "Tomorrow";
      } else if (appointmentDay == today.subtract(const Duration(days: 1))) {
        dayLabel = "Yesterday";
      } else {
        dayLabel = "${appointmentDate.day}/${appointmentDate.month}/${appointmentDate.year}";
      }

      // Include time if available
      if (time != null && time.isNotEmpty) {
        return "$dayLabel, $time";
      } else {
        return dayLabel;
      }
    } catch (e) {
      // If date parsing fails, return raw values
      if (time != null && time.isNotEmpty) {
        return "$date, $time";
      }
      return date;
    }
  }

  DateTime? _parseAppointmentDate(String timeString) {
    try {
      if (timeString.contains("Today")) {
        return DateTime.now();
      } else if (timeString.contains("Tomorrow")) {
        return DateTime.now().add(const Duration(days: 1));
      } else if (timeString.contains("Yesterday")) {
        return DateTime.now().subtract(const Duration(days: 1));
      } else {
        // Try to parse date format
        final parts = timeString.split(",");
        if (parts.isNotEmpty) {
          final dateParts = parts[0].split("/");
          if (dateParts.length == 3) {
            return DateTime(
              int.parse(dateParts[2]),
              int.parse(dateParts[1]),
              int.parse(dateParts[0]),
            );
          }
        }
      }
    } catch (e) {
      // Error parsing date
    }
    return null;
  }

  int _compareAppointmentTimes(String time1, String time2) {
    final date1 = _parseAppointmentDate(time1);
    final date2 = _parseAppointmentDate(time2);
    
    if (date1 == null || date2 == null) return 0;
    return date2.compareTo(date1); // Most recent first
  }

  void _showSnackBar(String message, {Color bg = Colors.blue}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bg,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  List<AppointmentModel> _getFilteredAppointments(List<AppointmentModel> appointments) {
    if (_searchQuery.isEmpty) return appointments;
    
    return appointments.where((appointment) {
      return appointment.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             appointment.history.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 40), // Bottom padding for scroll
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -------------------------------------------------------------
          // ⭐ CUSTOM PAGE HEADER
          // -------------------------------------------------------------
          const PageHeader(
            title: "Patient Management",
            subtitle: "Manage your patients and view their information",
          ),

          // -------------------------------------------------------------
          // Search Bar
          // -------------------------------------------------------------
          TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: "Search patients...",
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _searchQuery = "";
                        });
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue, width: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // -------------------------------------------------------------
          // Tabs
          // -------------------------------------------------------------
          Align(
            alignment: Alignment.centerLeft,
            child: TabToggle(
              options: tabTitles,
              counts: tabCounts,
              selectedIndex: selectedTab,
              onSelected: (index) {
                setState(() => selectedTab = index);
              },
            ),
          ),

          const SizedBox(height: 20),

          // -------------------------------------------------------------
          // Unified Content Area
          // -------------------------------------------------------------
          _buildCurrentTabList(),
        ],
      ),
    );
  }

  Widget _buildCurrentTabList() {
    // We reuse the SAME component, just pass different data
    List<AppointmentModel> appointments;
    
    switch (selectedTab) {
      case 0:
        appointments = _getFilteredAppointments(_allAppointments);
        break;
      case 1:
        appointments = _getFilteredAppointments(_recentAppointments);
        break;
      case 2:
        appointments = _getFilteredAppointments(_upcomingAppointments);
        break;
      default:
        appointments = _getFilteredAppointments(_allAppointments);
    }

    return PatientAppointmentList(appointments: appointments);
  }
}
