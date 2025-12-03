import 'package:flutter/material.dart';
import 'package:healthcare_plus/widgets/custom_header.dart';
import './providers/stats_card.dart';
class ProvidersPage extends StatelessWidget {
  const ProvidersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          PageHeader(
            title: "Provider Management",
            button1Text: "Export Data",
            button1OnPressed: () {},
            button2Text: "Send invitation",
            button2OnPressed: () {},
          ),

          // Stats Section
       
          const SizedBox(height: 50),

           StatsSection(),

         const SizedBox(height: 20),
            ProvidersPage(),
        ],
      ),
    );
  }
}