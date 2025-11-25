import 'package:flutter/material.dart';
import 'package:healthcare_plus/widgets/custom_header.dart';
import 'package:healthcare_plus/widgets/custom_tab.dart';

class Prescriptions extends StatefulWidget {
  const Prescriptions({super.key});

  @override
  State<Prescriptions> createState() => _PrescriptionsState();
}

class _PrescriptionsState extends State<Prescriptions> {
  // Data
  final int _activeCount = 12;
  final int _completedCount = 45;
  final int _expiredCount = 2;
  final int _remindersCount = 3;

  int _selectedTab = 0;
  final List<String> _tabs = [
    "Active",
    "Completed",
    "Expired",
    "All Prescriptions"
  ];
  late List<int> _tabCounts;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabCounts = [_activeCount, _completedCount, _expiredCount, 0];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onUploadPressed() {}
  void _onExportPressed() {}

  @override
  Widget build(BuildContext context) {
    const double maxWidth = 1100;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Material(

      // [FIX 1] SingleChildScrollView gives infinite height.
      // Do NOT use Expanded/Spacer inside its children.
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: maxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // [FIX 2] Shrink to fit content
              children: [
                // HEADER
                LayoutBuilder(
                  builder: (context, constraints) {
                    bool smallScreen = constraints.maxWidth < 460;
                    return PageHeader(
                      title: "My Prescriptions",
                      subtitle: "Track your medications and prescriptions",
                      button1Icon: Icons.file_upload_outlined,
                      button1Text:
                          smallScreen ? "Upload" : "Upload Prescription",
                      button1OnPressed: _onUploadPressed,
                      button2Icon: Icons.download_outlined,
                      button2Text: smallScreen ? "Export" : "Export Records",
                      button2OnPressed: _onExportPressed,
                      padding: const EdgeInsets.only(bottom: 32),
                    
                    );
                  },
                ),

                // SEARCH BAR
                SizedBox(
                  height: 52,
                  width: screenWidth < 600 ? double.infinity : maxWidth * 0.6,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search medications...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // STAT CARDS (Responsive Wrap)
                LayoutBuilder(builder: (context, constraints) {
                  double cardW = _cardWidth(constraints.maxWidth);
                  return Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      _buildStatCard("Active", _activeCount,
                          Icons.medication_rounded, Colors.green, cardW),
                      _buildStatCard("Completed", _completedCount,
                          Icons.check_circle_outline, Colors.blue, cardW),
                      _buildStatCard("Expired", _expiredCount,
                          Icons.error_outline, Colors.red, cardW),
                      _buildStatCard("Reminders", _remindersCount,
                          Icons.notifications_none, Colors.orange, cardW),
                    ],
                  );
                }),

                const SizedBox(height: 28),

                // TABS
                TabToggle(
                  options: _tabs,
                  counts: _tabCounts,
                  selectedIndex: _selectedTab,
                  onSelected: (index) => setState(() => _selectedTab = index),
                  height: 42,
                  fontSize: 12,
                ),

                const SizedBox(height: 28),

                // CONTENT
                // [FIX 3] This ensures the content doesn't crash the scroll view
                _buildTabContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper for Card Width
  double _cardWidth(double totalWidth) {
    if (totalWidth >= 1100) return ((totalWidth - 60) / 4).floorToDouble();
    if (totalWidth >= 700) return ((totalWidth - 20) / 2).floorToDouble();
    return totalWidth.floorToDouble();
  }

  // Helper for Stat Card
  Widget _buildStatCard(
      String title, int count, IconData icon, Color color, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey)),
                Text(count.toString(),
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // [CRITICAL FIX] content builder
  Widget _buildTabContent() {
    // If you use a ListView here, you MUST use shrinkWrap: true
    // and physics: NeverScrollableScrollPhysics() because this is already
    // inside a SingleChildScrollView.

    return ListView.separated(
      itemCount: 5, // Mock data count
      shrinkWrap: true, // <--- CRITICAL: Prevents infinite height error
      physics:
          const NeverScrollableScrollPhysics(), // <--- CRITICAL: Scrolls with page
      padding: EdgeInsets.zero,
      separatorBuilder: (c, i) => const SizedBox(height: 12),
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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.description, color: Colors.blue),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Prescription #${1000 + index}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Text("Dr. Smith • Cardiologist",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        );
      },
    );
  }
}