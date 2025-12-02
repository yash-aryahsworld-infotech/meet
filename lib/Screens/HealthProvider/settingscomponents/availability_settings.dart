
import 'package:flutter/material.dart';
import 'package:healthcare_plus/widgets/custom_button.dart'; // Ensure this path is correct for your project
import '../../../widgets/switch_on_off.dart';
// ---------------------------------------------------------
//  MODEL: TIME SLOT
// ---------------------------------------------------------
class TimeSlot {
  String start;
  String end;
  TimeSlot({required this.start, required this.end});
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

  @override
  void initState() {
    super.initState();
    for (var day in days) {
      active[day] = !["Saturday", "Sunday"].contains(day);
      dailySchedules[day] = [
        TimeSlot(start: "09:00", end: "17:00"),
      ];
    }
  }

  void _addTimeSlot(String day) {
    setState(() {
      dailySchedules[day]!.add(TimeSlot(start: "18:00", end: "19:00"));
    });
  }

  void _removeTimeSlot(String day, int index) {
    setState(() {
      dailySchedules[day]!.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Working Hours",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            "Set your specific availability",
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 25),

          Column(children: days.map((day) => _dayItem(day)).toList()),

          const SizedBox(height: 20),

          CustomButton(
            text: "Save Availability",
            icon: Icons.save,
            onPressed: () {
              // Save Logic Here
              print("Saved");
            },
            height: 48,
            width: 200,
            textColor: Colors.white,
            colors: const [Color(0xFF2196F3), Color(0xFF1565C0)],
            buttonPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ],
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

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
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
                        style: const TextStyle(
                          fontSize: 16,
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
                            fontSize: 14,
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
                          child: _buildTimeRow(day, entry.key, entry.value, isMobile),
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
                                  color: Colors.blue.shade700, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                "Add Split Time",
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
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
                padding: const EdgeInsets.only(left: 10),
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
  Widget _buildTimeRow(String day, int index, TimeSlot slot, bool isMobile) {
    double timeFieldWidth = isMobile ? 85 : 120;

    return Row(
      children: [
        _timeField(
          label: slot.start,
          width: timeFieldWidth,
          onTap: () async {
            final t = await _pickTime(context, slot.start);
            if (t != null) setState(() => dailySchedules[day]![index].start = t);
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text("-", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        ),
        _timeField(
          label: slot.end,
          width: timeFieldWidth,
          onTap: () async {
            final t = await _pickTime(context, slot.end);
            if (t != null) setState(() => dailySchedules[day]![index].end = t);
          },
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.grey, size: 20),
          onPressed: () => _removeTimeSlot(day, index),
          splashRadius: 20,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
        ),
      ],
    );
  }

  Widget _timeField({
    required String label,
    required VoidCallback onTap,
    required double width,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            const Icon(Icons.expand_more, size: 16, color: Colors.grey),
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
