import 'package:flutter/material.dart';
import 'package:healthcare_plus/widgets/custom_button.dart';

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
  final Map<String, String> startTime = {};
  final Map<String, String> endTime = {};

  @override
  void initState() {
    super.initState();

    for (var day in days) {
      active[day] = !["Saturday", "Sunday"].contains(day);

      startTime[day] = "09:00";
      endTime[day] = "17:00";
    }
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
            "Set your availability for appointments",
            style: TextStyle(color: Colors.grey.shade600),
          ),

          const SizedBox(height: 25),

          // DAYS LIST
          Column(children: days.map((day) => _dayItem(day)).toList()),

          const SizedBox(height: 20),

          // SAVE BUTTON
          Align(
            alignment: Alignment.centerLeft,
            child: CustomButton(
              text: "Save Availability",
              icon: Icons.save, // optional
              onPressed: () {
                // Your save logic here
              },

              // Optional button styling
              height: 48,
              width: 200,
              textColor: Colors.white,
              buttonPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),

              colors: const [Color(0xFF2196F3), Color(0xFF1565C0)],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  //  RESPONSIVE DAY ITEM
  // ----------------------------------------------------
  Widget _dayItem(String day) {
    bool isActive = active[day]!;

    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        bool isMobile = width < 600;

        double timeFieldWidth = isMobile ? 85 : 135;
        double fontSize = isMobile ? 14 : 16;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Switch(
                          value: isActive,
                          activeColor: Colors.blue,
                          onChanged: (value) {
                            setState(() => active[day] = value);
                          },
                        ),
                        Text(
                          day,
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (!isActive)
                          Text(
                            "Unavailable",
                            style: TextStyle(
                              fontSize: fontSize - 1,
                              color: Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ),

                    if (isActive) const SizedBox(height: 14),

                    if (isActive)
                      Row(
                        children: [
                          _timeField(
                            label: startTime[day]!,
                            width: timeFieldWidth,
                            onTap: () async {
                              final t = await _pickTime(
                                context,
                                startTime[day]!,
                              );
                              if (t != null) setState(() => startTime[day] = t);
                            },
                          ),
                          const SizedBox(width: 10),
                          const Text("to"),
                          const SizedBox(width: 10),
                          _timeField(
                            label: endTime[day]!,
                            width: timeFieldWidth,
                            onTap: () async {
                              final t = await _pickTime(context, endTime[day]!);
                              if (t != null) setState(() => endTime[day] = t);
                            },
                          ),
                        ],
                      ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Switch(
                          value: isActive,
                          activeColor: Colors.blue,
                          onChanged: (value) {
                            setState(() => active[day] = value);
                          },
                        ),
                        Text(
                          day,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (!isActive)
                          Text(
                            "Unavailable",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ),

                    if (isActive)
                      Row(
                        children: [
                          _timeField(
                            label: startTime[day]!,
                            width: timeFieldWidth,
                            onTap: () async {
                              final t = await _pickTime(
                                context,
                                startTime[day]!,
                              );
                              if (t != null) setState(() => startTime[day] = t);
                            },
                          ),
                          const SizedBox(width: 10),
                          const Text("to"),
                          const SizedBox(width: 10),
                          _timeField(
                            label: endTime[day]!,
                            width: timeFieldWidth,
                            onTap: () async {
                              final t = await _pickTime(context, endTime[day]!);
                              if (t != null) setState(() => endTime[day] = t);
                            },
                          ),
                        ],
                      ),
                  ],
                ),
        );
      },
    );
  }

  // ----------------------------------------------------
  //  TIME FIELD
  // ----------------------------------------------------
  Widget _timeField({
    required String label,
    required VoidCallback onTap,
    required double width,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Icon(Icons.access_time, size: 16, color: Colors.grey.shade700),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------
  //  TIME PICKER
  // ----------------------------------------------------
  Future<String?> _pickTime(BuildContext context, String initial) async {
    final parts = initial.split(":");
    final initialTime = TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked == null) return null;

    return "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
  }
}
