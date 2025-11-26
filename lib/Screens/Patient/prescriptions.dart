import 'package:flutter/material.dart';
import 'package:healthcare_plus/widgets/custom_header.dart';
import 'package:healthcare_plus/widgets/custom_tab.dart';
import "./prescriptioncomponents/statscard.dart";

class Prescriptions extends StatefulWidget {
  const Prescriptions({super.key});

  @override
  State<Prescriptions> createState() => _PrescriptionsState();
}

class _PrescriptionsState extends State<Prescriptions> {
  final TextEditingController searchController = TextEditingController();

  int selectedTab = 0;

  final List<String> tabs = [
    "Active",
    "Completed",
    "Expired",
    "All Prescriptions"
  ];

  final List<int> tabCounts = [12, 45, 2, 0];

  @override
  Widget build(BuildContext context) {
    const double maxWidth = 1100;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Material(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: maxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------- HEADER ----------------
                LayoutBuilder(
                  builder: (context, c) {
                    bool small = c.maxWidth < 460;
                    return PageHeader(
                      title: "My Prescriptions",
                      subtitle: "Track your medications and prescriptions",
                      button1Icon: Icons.file_upload_outlined,
                      button1Text: small ? "Upload" : "Upload Prescription",
                      button1OnPressed: () {},
                      button2Icon: Icons.download_outlined,
                      button2Text: small ? "Export" : "Export Records",
                      button2OnPressed: () {},
                      padding: const EdgeInsets.only(bottom: 32),
                    );
                  },
                ),

                // ---------------- SEARCH BAR ----------------
                SizedBox(
                  height: 50,
                  width: screenWidth < 600 ? double.infinity : maxWidth * 0.6,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search medications...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ---------------- STATS SECTION ----------------
                const StatsSection(),

                const SizedBox(height: 28),

                // ---------------- TAB TOGGLE ----------------
                TabToggle(
                  options: tabs,
                  counts: tabCounts,
                  selectedIndex: selectedTab,
                  onSelected: (i) => setState(() => selectedTab = i),               
                ),

                const SizedBox(height: 24),

                // ---------------- LIST INLINE (NO FUNCTIONS) ----------------
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          // icon box
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.description,
                                color: Colors.blue),
                          ),
                          const SizedBox(width: 16),

                          // text
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Prescription #${1000 + index}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                "Dr. Smith • Cardiologist",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),

                          const Spacer(),

                          const Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.grey),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
