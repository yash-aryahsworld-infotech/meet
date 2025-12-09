import 'package:flutter/material.dart';

class TimeSlotGrid extends StatelessWidget {
  final List<Map<String, dynamic>> slots; // Changed from List<String> to List<Map>
  final Set<String> bookedSlots;
  final String? selectedTime;
  final ValueChanged<String> onTimeSelected;

  const TimeSlotGrid({
    super.key,
    required this.slots,
    required this.bookedSlots,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return Center(
        child: Text("No slots available", style: TextStyle(color: Colors.grey.shade500)),
      );
    }

    // Helper to filter slots
    List<Map<String, dynamic>> getSlotsByPeriod(int startHour, int endHour) {
      return slots.where((slot) {
        final timeStr = slot['time'] as String;
        final parts = timeStr.split(' ');
        final hm = parts[0].split(':');
        int h = int.parse(hm[0]);
        if (parts[1] == 'PM' && h != 12) h += 12;
        if (parts[1] == 'AM' && h == 12) h = 0;
        return h >= startHour && h < endHour;
      }).toList();
    }

    final morning = getSlotsByPeriod(0, 12);
    final afternoon = getSlotsByPeriod(12, 17);
    final evening = getSlotsByPeriod(17, 24);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLegend(),
          if (morning.isNotEmpty) _buildSection("Morning", Icons.wb_sunny_outlined, morning),
          if (afternoon.isNotEmpty) _buildSection("Afternoon", Icons.wb_sunny, afternoon),
          if (evening.isNotEmpty) _buildSection("Evening", Icons.nightlight_round, evening),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Map<String, dynamic>> timeSlots) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
            ],
          ),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: timeSlots.map((slotData) {
            final time = slotData['time'] as String;
            final duration = slotData['duration']; // Get Duration
            
            final isBooked = bookedSlots.contains(time);
            final isSelected = selectedTime == time;
            
            return InkWell(
              onTap: isBooked ? null : () => onTimeSelected(time),
              child: Container(
                width: 90, // Fixed width for consistent look
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isBooked 
                      ? Colors.grey.shade200 
                      : (isSelected ? Colors.green : Colors.white),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isBooked 
                        ? Colors.transparent 
                        : (isSelected ? Colors.green : Colors.grey.shade300),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // TIME TEXT
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 13,
                        color: isBooked 
                            ? Colors.grey.shade400 
                            : (isSelected ? Colors.white : Colors.black87),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        decoration: isBooked ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // DURATION TEXT
                    Text(
                      "$duration min",
                      style: TextStyle(
                        fontSize: 10,
                        color: isBooked 
                            ? Colors.grey.shade400 
                            : (isSelected ? Colors.white70 : Colors.grey.shade500),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(Colors.white, Colors.grey.shade300, "Available"),
        const SizedBox(width: 15),
        _legendItem(Colors.green, Colors.transparent, "Selected", textColor: Colors.white),
        const SizedBox(width: 15),
        _legendItem(Colors.grey.shade200, Colors.transparent, "Booked", textColor: Colors.grey),
      ],
    );
  }

  Widget _legendItem(Color bg, Color border, String label, {Color textColor = Colors.black}) {
    return Row(
      children: [
        Container(
          width: 16, height: 16,
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}