import 'package:flutter/material.dart';

class CalendarPanel extends StatefulWidget {
  const CalendarPanel({super.key});

  @override
  State<CalendarPanel> createState() => _CalendarPanelState();
}

class _CalendarPanelState extends State<CalendarPanel> {
  DateTime _focusedMonth = DateTime.now();
  DateTime? _selectedDate;

  // ---------- Month Names (No intl) ----------
  final List<String> monthNames = const [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    bool isMobile = width < 600;
    bool isTablet = width >= 600 && width < 1024;

    double padding = isMobile ? 16 : isTablet ? 20 : 24;
    double titleSize = isMobile ? 18 : isTablet ? 19 : 20;
    double subtitleSize = isMobile ? 13 : 14;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: isMobile ? 6 : 10,
            offset: const Offset(0, 4),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- HEADER ----------------
          Text(
            "Calendar",
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "View appointments by date",
            style: TextStyle(color: Colors.grey.shade600, fontSize: subtitleSize),
          ),
          const SizedBox(height: 20),

          // ---------------- MONTH HEADER ----------------
          _buildMonthHeader(),

          const SizedBox(height: 16),

          // ---------------- WEEKDAY LABELS ----------------
          _buildWeekdayLabels(),

          const SizedBox(height: 10),

          // ---------------- DATES GRID ----------------
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Month Header Row
  // ---------------------------------------------------------------------
  Widget _buildMonthHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _arrowButton(Icons.chevron_left, -1),
          Text(
            "${monthNames[_focusedMonth.month - 1]} ${_focusedMonth.year}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          _arrowButton(Icons.chevron_right, 1),
        ],
      ),
    );
  }

  // Arrow Button
  Widget _arrowButton(IconData icon, int offset) {
    return InkWell(
      onTap: () {
        setState(() {
          _focusedMonth = DateTime(
            _focusedMonth.year,
            _focusedMonth.month + offset,
            1,
          );
        });
      },
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Weekday labels (Sun - Sat)
  // ---------------------------------------------------------------------
  Widget _buildWeekdayLabels() {
    const days = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days
          .map((d) => Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  // ---------------------------------------------------------------------
  // Calendar Grid (Dates)
  // ---------------------------------------------------------------------
  Widget _buildCalendarGrid() {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDay = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);

    int firstWeekday = (firstDay.weekday % 7); // Sunday = 0
    int numberOfDays = lastDay.day;

    List<Widget> dayWidgets = [];

    // ---- Empty slots before the first day ----
    for (int i = 0; i < firstWeekday; i++) {
      dayWidgets.add(const SizedBox());
    }

    // ---- Actual days ----
    for (int day = 1; day <= numberOfDays; day++) {
      DateTime date = DateTime(_focusedMonth.year, _focusedMonth.month, day);

      bool isSelected = _selectedDate != null &&
          _selectedDate!.year == date.year &&
          _selectedDate!.month == date.month &&
          _selectedDate!.day == date.day;

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date;
            });
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.blue : Colors.transparent,
              border: isSelected
                  ? Border.all(color: Colors.blue.shade700, width: 3)
                  : null,
            ),
            child: Center(
              child: Text(
                day.toString(),
                style: TextStyle(
                  fontSize: 15,
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // ---- Calendar Grid ----
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: dayWidgets,
    );
  }
}
