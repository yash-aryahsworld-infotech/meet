import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/Corporate/program/programs_section.dart';
import 'package:healthcare_plus/widgets/custom_header.dart';
import './program/stats_section.dart';

class CorporateProgramsPage extends StatelessWidget {
  const CorporateProgramsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: "Program Management",
            button1Text: "Import Program",
            button1OnPressed: () => {},
            button2Icon: Icons.add,
            button2Text: "Create Program",
            button2OnPressed: () => {},
          ),

          const StatsSection(
            total: 5,
            active: 3,
            avgScore: "54%",
            programs: 400,
          ),

          const SizedBox(height: 20),
          const ProgramsSection(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
