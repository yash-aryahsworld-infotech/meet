import 'package:flutter/material.dart';

class TimeSlotGrid extends StatelessWidget {
  final bool isLoading;
  final bool isDayActive;
  final String dayName;
  final List<String> morningSlots;
  final List<String> afternoonSlots;
  final List<String> bookedSlots;
  final int selectedTimeIndex;
  final Function(int) onSlotSelected;

  const TimeSlotGrid({
    super.key,
    required this.isLoading,
    required this.isDayActive,
    required this.dayName,
    required this.morningSlots,
    required this.afternoonSlots,
    required this.bookedSlots,
    required this.selectedTimeIndex,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (!isDayActive) return Center(child: Text("Doctor not available on $dayName", style: const TextStyle(color: Colors.grey)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildLegendDot(Colors.white, Colors.black, "Available"),
            const SizedBox(width: 10),
            _buildLegendDot(Colors.green.shade50, Colors.green, "Selected"),
            const SizedBox(width: 10),
            _buildLegendDot(Colors.grey.shade200, Colors.grey, "Booked"),
          ],
        ),
        const SizedBox(height: 10),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (morningSlots.isNotEmpty) ...[
                  const Text("Morning", style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10, runSpacing: 10,
                    children: List.generate(morningSlots.length, (index) => _buildChip(index, morningSlots[index])),
                  ),
                ],

                if (afternoonSlots.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const Text("Afternoon / Evening", style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10, runSpacing: 10,
                    children: List.generate(afternoonSlots.length, (index) {
                      // Offset index by morning length
                      final actualIndex = index + morningSlots.length;
                      return _buildChip(actualIndex, afternoonSlots[index]);
                    }),
                  ),
                ],

                if (morningSlots.isEmpty && afternoonSlots.isEmpty)
                   const Center(child: Padding(padding: EdgeInsets.all(30), child: Text("No slots available."))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChip(int index, String time) {
    final bool isBooked = bookedSlots.contains(time);
    final bool isSelected = selectedTimeIndex == index;

    return InkWell(
      onTap: isBooked ? null : () => onSlotSelected(index),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isBooked ? Colors.grey.shade200 : (isSelected ? Colors.green.shade50 : Colors.white),
          border: Border.all(color: isBooked ? Colors.grey.shade300 : (isSelected ? Colors.green : Colors.grey.shade300)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isBooked ? Colors.grey : (isSelected ? Colors.green : Colors.black87),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            decoration: isBooked ? TextDecoration.lineThrough : null,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendDot(Color bg, Color border, String label) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: bg, border: Border.all(color: border), borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}