import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  final List<DateTime> dates;
  final int selectedIndex;
  final Function(int) onDateSelected;

  const DateSelector({
    super.key, 
    required this.dates, 
    required this.selectedIndex, 
    required this.onDateSelected
  });

  String _getDayAbbr(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1]; 
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(dates.length, (index) {
          final date = dates[index];
          final isSelected = selectedIndex == index;
          
          return GestureDetector(
            onTap: () => onDateSelected(index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300),
                boxShadow: isSelected ? [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2))] : [],
              ),
              child: Column(
                children: [
                  Text(_getDayAbbr(date.weekday), style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text("${date.day}", style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}