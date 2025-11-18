import 'package:flutter/material.dart';
import './consultationscomponents/consultation_header.dart';
import './consultationscomponents/consultation_tabs.dart';
import './consultationscomponents/consultation_empty_state.dart';

class ConsultationsComponent extends StatefulWidget {
  const ConsultationsComponent({super.key});

  @override
  State<ConsultationsComponent> createState() => _ConsultationsComponentState();
}

class _ConsultationsComponentState extends State<ConsultationsComponent> {
  int selectedTab = 0;

  final List<int> tabCounts = [0, 0, 0];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ConsultationHeader(),

          const SizedBox(height: 25),

          ConsultationTabs(
            selectedIndex: selectedTab,
            counts: tabCounts,
            onChanged: (index) => setState(() => selectedTab = index),
          ),

          const SizedBox(height: 25),

          ConsultationEmptyState(selectedTab: selectedTab),
        ],
      ),
    );
  }
}
