import 'package:flutter/material.dart';
import '../../../widgets/custom_toggle_switch.dart';

class ConsultationTabs extends StatelessWidget {
  final int selectedIndex;
  final List<int> counts;
  final Function(int) onChanged;

  const ConsultationTabs({
    super.key,
    required this.selectedIndex,
    required this.counts,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomToggleSwitch(
      options: [
        "Active (${counts[0]})",
        "Completed (${counts[1]})",
        "All Consultations (${counts[2]})",
      ],
      selectedIndex: selectedIndex,
      onSelected: onChanged,
    );
  }
}
