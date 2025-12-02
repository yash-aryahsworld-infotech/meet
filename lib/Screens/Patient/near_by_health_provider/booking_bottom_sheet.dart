import 'package:flutter/material.dart';

class BookingBottomSheet extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const BookingBottomSheet({super.key, required this.doctor});

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = -1;

  // Generate next 7 days dynamically
  final List<DateTime> _dates = List.generate(
    7, 
    (index) => DateTime.now().add(Duration(days: index))
  );

  // Mock Time Slots
  final List<String> _morningSlots = ["09:00 AM", "09:30 AM", "10:00 AM", "11:15 AM"];
  final List<String> _afternoonSlots = ["02:00 PM", "03:45 PM", "04:30 PM", "06:00 PM"];

  // Helper for Date Name (Mon, Tue)
  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
               CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.doctor['image']),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Booking: ${widget.doctor['name']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(widget.doctor['specialty'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),

          // 1. DATE SELECTOR
          const Text("Select Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_dates.length, (index) {
                final date = _dates[index];
                final isSelected = _selectedDateIndex == index;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedDateIndex = index;
                    _selectedTimeIndex = -1; // Reset time
                  }),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _getDayName(date.weekday),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${date.day}",
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),

          // 2. TIME SLOT SELECTOR
          const Text("Select Time Slot", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Morning", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(_morningSlots.length, (index) {
                      return _buildTimeChip(index, _morningSlots[index]);
                    }),
                  ),
                  const SizedBox(height: 15),
                  const Text("Afternoon & Evening", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(_afternoonSlots.length, (index) {
                      return _buildTimeChip(index + _morningSlots.length, _afternoonSlots[index]);
                    }),
                  ),
                ],
              ),
            ),
          ),

          // 3. PAY BUTTON
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _selectedTimeIndex == -1 
                ? null 
                : () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Booking Successful!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child: Text(
                "Pay ₹${widget.doctor['price']}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeChip(int index, String time) {
    final isSelected = _selectedTimeIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedTimeIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : Colors.white,
          border: Border.all(color: isSelected ? Colors.green : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isSelected ? Colors.green : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}