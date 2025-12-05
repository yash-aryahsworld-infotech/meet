
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthcare_plus/widgets/custom_button.dart'; // Ensure this path is correct for your project
import '../../../widgets/switch_on_off.dart';
// ---------------------------------------------------------
//  MODEL: TIME SLOT
// ---------------------------------------------------------
class TimeSlot {
  String start;
  String end;
  int slotDuration; // Duration in minutes (5, 10, 20, 30, 40, 50, 60)
  
  TimeSlot({
    required this.start,
    required this.end,
    this.slotDuration = 30, // Default 30 minutes
  });

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'start': start,
      'end': end,
      'slotDuration': slotDuration,
    };
  }

  // Create from Map
  factory TimeSlot.fromMap(Map<dynamic, dynamic> map) {
    return TimeSlot(
      start: map['start'] ?? '09:00',
      end: map['end'] ?? '17:00',
      slotDuration: map['slotDuration'] ?? 30,
    );
  }
}

// ---------------------------------------------------------
//  MAIN WIDGET: AVAILABILITY SETTINGS
// ---------------------------------------------------------
class AvailabilitySettings extends StatefulWidget {
  const AvailabilitySettings({super.key});

  @override
  State<AvailabilitySettings> createState() => _AvailabilitySettingsState();
}

class _AvailabilitySettingsState extends State<AvailabilitySettings> {
  final List<String> days = const [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  final Map<String, bool> active = {};
  final Map<String, List<TimeSlot>> dailySchedules = {};
  
  String? userKey;
  String? userRole;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initAndLoad();
  }

  Future<void> _initAndLoad() async {
    setState(() => _isLoading = true);

    // Get user info from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    userKey = prefs.getString("userKey");
    userRole = prefs.getString("userRole");

    if (userKey == null || userKey!.isEmpty) {
      _showSnackBar("User not logged in", bg: Colors.red);
      setState(() => _isLoading = false);
      return;
    }

    // Initialize default values
    for (var day in days) {
      active[day] = !["Saturday", "Sunday"].contains(day);
      dailySchedules[day] = [
        TimeSlot(start: "09:00", end: "17:00", slotDuration: 30),
      ];
    }

    // Load existing availability from Firebase
    await _loadAvailability();

    setState(() => _isLoading = false);
  }

  Future<void> _loadAvailability() async {
    try {
      final ref = FirebaseDatabase.instance
          .ref("healthcare/users/providers/$userKey/availability");
      
      final snapshot = await ref.get();

      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        
        data.forEach((day, dayData) {
          if (days.contains(day)) {
            active[day] = dayData['active'] ?? false;
            
            if (dayData['slots'] != null) {
              List<dynamic> slotsData = dayData['slots'];
              dailySchedules[day] = slotsData
                  .map((slot) => TimeSlot.fromMap(slot as Map))
                  .toList();
            }
          }
        });
      }
    } catch (e) {
      // Error loading availability
      _showSnackBar("Failed to load availability", bg: Colors.orange);
    }
  }

  Future<void> _saveAvailability() async {
    if (userKey == null || userKey!.isEmpty) {
      _showSnackBar("User not logged in", bg: Colors.red);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final ref = FirebaseDatabase.instance
          .ref("healthcare/users/providers/$userKey/availability");

      Map<String, dynamic> availabilityData = {};

      for (var day in days) {
        availabilityData[day] = {
          'active': active[day],
          'slots': dailySchedules[day]!.map((slot) => slot.toMap()).toList(),
        };
      }

      await ref.set(availabilityData);

      _showSnackBar("Availability saved successfully!", bg: Colors.green);
    } catch (e) {
      _showSnackBar("Failed to save availability: $e", bg: Colors.red);
    }

    setState(() => _isSaving = false);
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

  void _addTimeSlot(String day) {
    // Get the end time of the last slot
    String newStartTime = "18:00";
    if (dailySchedules[day]!.isNotEmpty) {
      newStartTime = dailySchedules[day]!.last.end;
    }
    
    // Check if new slot would start at or after 11:00 PM
    final startMinutes = _timeToMinutes(newStartTime);
    if (startMinutes >= 23 * 60) {
      _showSnackBar(
        "Cannot add more slots after 11:00 PM. The day ends at midnight.",
        bg: Colors.red.shade400,
      );
      return;
    }
    
    setState(() {
      // Calculate new end time (1 hour after start)
      final startParts = newStartTime.split(":");
      int startHour = int.parse(startParts[0]);
      int startMinute = int.parse(startParts[1]);
      
      // Add 1 hour
      int endHour = startHour + 1;
      int endMinute = startMinute;
      
      // Handle overflow (max 23:59)
      if (endHour > 23) {
        endHour = 23;
        endMinute = 59;
      }
      
      String newEndTime = "${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}";
      
      dailySchedules[day]!.add(TimeSlot(start: newStartTime, end: newEndTime, slotDuration: 30));
    });
  }

  void _removeTimeSlot(String day, int index) {
    setState(() {
      dailySchedules[day]!.removeAt(index);
    });
  }

  // Validate and adjust slot times to prevent overlap
  void _validateAndAdjustSlots(String day, int changedIndex, bool isStartTime) {
    final slots = dailySchedules[day]!;
    
    if (isStartTime && changedIndex > 0) {
      // If start time changed, ensure it's not before previous slot's end time
      final prevSlot = slots[changedIndex - 1];
      final currentSlot = slots[changedIndex];
      
      if (_timeToMinutes(currentSlot.start) < _timeToMinutes(prevSlot.end)) {
        // Adjust start time to match previous end time
        currentSlot.start = prevSlot.end;
        
        // Convert to 12-hour format for display
        final prevEndTime = _formatTimeTo12Hour(prevSlot.end);
        
        _showSnackBar(
          "Slot $changedIndex ends at $prevEndTime. Slot ${changedIndex + 1} can only start after that time.",
          bg: Colors.orange,
        );
      }
      
      // Check if start time is too late (after 11:00 PM)
      if (_timeToMinutes(currentSlot.start) >= 23 * 60) {
        currentSlot.start = "23:00";
        _showSnackBar(
          "Slots cannot start after 11:00 PM as a new day begins at midnight.",
          bg: Colors.red.shade400,
        );
      }
    }
    
    if (!isStartTime) {
      final currentSlot = slots[changedIndex];
      
      // Check if end time exceeds midnight (11:59 PM max)
      if (_timeToMinutes(currentSlot.end) > 23 * 60 + 59) {
        currentSlot.end = "23:59";
        _showSnackBar(
          "Slots cannot extend past midnight (11:59 PM). A new day begins at 12:00 AM.",
          bg: Colors.red.shade400,
        );
      }
      
      // Ensure end time is after start time
      if (_timeToMinutes(currentSlot.end) <= _timeToMinutes(currentSlot.start)) {
        final startParts = currentSlot.start.split(":");
        int hour = int.parse(startParts[0]);
        int minute = int.parse(startParts[1]);
        
        hour += 1;
        if (hour > 23) {
          hour = 23;
          minute = 59;
        }
        
        currentSlot.end = "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
        
        _showSnackBar(
          "End time must be after start time. Adjusted automatically.",
          bg: Colors.orange,
        );
      }
      
      // Check if there's enough time for at least one appointment
      final duration = _timeToMinutes(currentSlot.end) - _timeToMinutes(currentSlot.start);
      if (duration < 5) {
        final startParts = currentSlot.start.split(":");
        int hour = int.parse(startParts[0]);
        int minute = int.parse(startParts[1]);
        
        minute += 30;
        if (minute >= 60) {
          hour += 1;
          minute -= 60;
        }
        
        if (hour > 23) {
          hour = 23;
          minute = 59;
        }
        
        currentSlot.end = "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
        
        _showSnackBar(
          "Slot duration too short. Minimum 30 minutes recommended.",
          bg: Colors.orange,
        );
      }
      
      // Adjust next slot's start time if exists
      if (changedIndex < slots.length - 1) {
        final nextSlot = slots[changedIndex + 1];
        
        // Check if next slot can fit before midnight
        if (_timeToMinutes(currentSlot.end) >= 23 * 60) {
          // Current slot ends at or after 11:00 PM, remove next slots
          _showSnackBar(
            "Cannot add more slots after 11:00 PM. Please adjust your schedule.",
            bg: Colors.red.shade400,
          );
          return;
        }
        
        if (nextSlot.start != currentSlot.end) {
          nextSlot.start = currentSlot.end;
          
          // Ensure next slot's end doesn't exceed midnight
          if (_timeToMinutes(nextSlot.end) > 23 * 60 + 59) {
            nextSlot.end = "23:59";
          }
          
          // Ensure next slot's end is after its start
          if (_timeToMinutes(nextSlot.end) <= _timeToMinutes(nextSlot.start)) {
            final startParts = nextSlot.start.split(":");
            int hour = int.parse(startParts[0]);
            int minute = int.parse(startParts[1]);
            
            hour += 1;
            if (hour > 23) {
              hour = 23;
              minute = 59;
            }
            
            nextSlot.end = "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
          }
          
          // Convert to 12-hour format for display
          final currentEndTime = _formatTimeTo12Hour(currentSlot.end);
          
          _showSnackBar(
            "Slot ${changedIndex + 1} updated. Next slot will now start at $currentEndTime.",
            bg: Colors.blue.shade300,
          );
        }
      }
    }
  }

  // Convert 24-hour time to 12-hour format with AM/PM
  String _formatTimeTo12Hour(String time24) {
    final parts = time24.split(":");
    int hour = int.parse(parts[0]);
    final minute = parts[1];
    
    String period = hour >= 12 ? "PM" : "AM";
    
    if (hour == 0) {
      hour = 12;
    } else if (hour > 12) {
      hour = hour - 12;
    }
    
    return "$hour:$minute $period";
  }

  // Convert time string to minutes for comparison
  int _timeToMinutes(String time) {
    final parts = time.split(":");
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 400;
    final padding = isSmallDevice ? 12.0 : 22.0;

    if (_isLoading) {
      return Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Working Hours",
              style: TextStyle(
                fontSize: isSmallDevice ? 18 : 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Set your specific availability",
              style: TextStyle(
                fontSize: isSmallDevice ? 12 : 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 25),

            Column(children: days.map((day) => _dayItem(day)).toList()),

            const SizedBox(height: 20),

            Center(
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      text: "Save Availability",
                      icon: Icons.save,
                      onPressed: _saveAvailability,
                      height: 48,
                      width: isSmallDevice ? double.infinity : 200,
                      textColor: Colors.white,
                      colors: const [Color(0xFF2196F3), Color(0xFF1565C0)],
                      buttonPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------
  //  DAY ITEM ROW
  // ----------------------------------------------------
  Widget _dayItem(String day) {
    bool isActive = active[day]!;
    List<TimeSlot> slots = dailySchedules[day]!;

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        bool isVerySmall = constraints.maxWidth < 400;
        
        final horizontalPadding = isVerySmall ? 10.0 : 18.0;
        final verticalPadding = isVerySmall ? 12.0 : 16.0;

        return Container(
          margin: EdgeInsets.only(bottom: isVerySmall ? 12 : 16),
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----------------------------
              // LEFT SIDE: Day Name + Times
              // ----------------------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Day Name - Aligned with the switch visually
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0), 
                      child: Text(
                        day,
                        style: TextStyle(
                          fontSize: isVerySmall ? 14 : 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    if (!isActive)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          "Unavailable",
                          style: TextStyle(
                            fontSize: isVerySmall ? 12 : 14,
                            color: Colors.grey.shade500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    else ...[
                      const SizedBox(height: 8),
                      // List of Time Inputs
                      ...slots.asMap().entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildTimeRow(day, entry.key, entry.value, isMobile, isVerySmall),
                        );
                      }),

                      // Add Button
                      InkWell(
                        onTap: () => _addTimeSlot(day),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_circle_outline,
                                  color: Colors.blue.shade700, size: isVerySmall ? 16 : 18),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  "Add Split Time",
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.w600,
                                    fontSize: isVerySmall ? 11 : 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // ----------------------------
              // RIGHT SIDE: Custom On/Off Switch
              // ----------------------------
              Padding(
                padding: EdgeInsets.only(left: isVerySmall ? 6 : 10),
                child: OnOffSwitch(
                  value: isActive,
                  onChanged: (value) {
                    setState(() => active[day] = value);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ----------------------------------------------------
  //  TIME ROW
  // ----------------------------------------------------
  Widget _buildTimeRow(String day, int index, TimeSlot slot, bool isMobile, bool isVerySmall) {
    double timeFieldWidth = isVerySmall ? 70 : (isMobile ? 85 : 120);
    final slots = dailySchedules[day]!;
    final isLastSlot = index == slots.length - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Show slot number if multiple slots
        if (slots.length > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Slot ${index + 1}",
                    style: TextStyle(
                      fontSize: isVerySmall ? 14 : 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
                if (!isLastSlot) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: isVerySmall ? 12 : 14, color: Colors.grey),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      "Next slot begins at ${_formatTimeTo12Hour(slot.end)}",
                      style: TextStyle(
                        fontSize: isVerySmall ? 11 : 12,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        Row(
          children: [
            _timeField(
              label: slot.start,
              width: timeFieldWidth,
              isVerySmall: isVerySmall,
              onTap: () async {
                final t = await _pickTime(context, slot.start);
                if (t != null) {
                  setState(() {
                    dailySchedules[day]![index].start = t;
                    _validateAndAdjustSlots(day, index, true);
                  });
                }
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isVerySmall ? 4 : 8),
              child: Text(
                "-",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: isVerySmall ? 12 : 14,
                ),
              ),
            ),
            _timeField(
              label: slot.end,
              width: timeFieldWidth,
              isVerySmall: isVerySmall,
              onTap: () async {
                final t = await _pickTime(context, slot.end);
                if (t != null) {
                  setState(() {
                    dailySchedules[day]![index].end = t;
                    _validateAndAdjustSlots(day, index, false);
                  });
                }
              },
            ),
            SizedBox(width: isVerySmall ? 4 : 8),
            IconButton(
              icon: Icon(Icons.close, color: Colors.grey, size: isVerySmall ? 18 : 20),
              onPressed: () => _removeTimeSlot(day, index),
              splashRadius: isVerySmall ? 18 : 20,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(
                minWidth: isVerySmall ? 24 : 30,
                minHeight: isVerySmall ? 24 : 30,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _slotDurationDropdown(day, index, slot, isVerySmall),
      ],
    );
  }

  // ----------------------------------------------------
  //  SLOT DURATION DROPDOWN
  // ----------------------------------------------------
  Widget _slotDurationDropdown(String day, int index, TimeSlot slot, bool isVerySmall) {
    final List<int> durations = [5, 10, 20, 30, 40, 50, 60];

    return Wrap(
      spacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Icon(Icons.schedule, size: isVerySmall ? 14 : 16, color: Colors.grey),
        Text(
          "Slot:",
          style: TextStyle(
            fontSize: isVerySmall ? 10 : 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isVerySmall ? 6 : 10,
            vertical: isVerySmall ? 2 : 4,
          ),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: DropdownButton<int>(
            value: slot.slotDuration,
            underline: const SizedBox(),
            isDense: true,
            style: TextStyle(
              fontSize: isVerySmall ? 10 : 12,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            items: durations.map((duration) {
              return DropdownMenuItem<int>(
                value: duration,
                child: Text("$duration min"),
              );
            }).toList(),
            onChanged: (newDuration) {
              if (newDuration != null) {
                setState(() {
                  dailySchedules[day]![index].slotDuration = newDuration;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _timeField({
    required String label,
    required VoidCallback onTap,
    required double width,
    required bool isVerySmall,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(
          horizontal: isVerySmall ? 6 : 10,
          vertical: isVerySmall ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: isVerySmall ? 11 : 13,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.expand_more, size: isVerySmall ? 14 : 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Future<String?> _pickTime(BuildContext context, String initial) async {
    final parts = initial.split(":");
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1])),
    );
    if (picked == null) return null;
    return "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
  }
}
