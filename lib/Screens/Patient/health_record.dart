import 'package:flutter/material.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';
import 'package:healthcare_plus/widgets/custom_header.dart';
import 'package:healthcare_plus/widgets/custom_tab.dart';
import 'package:healthcare_plus/widgets/stat_card_vertical.dart';

class HealthRecord extends StatefulWidget {
  const HealthRecord({super.key});

  @override
  State<HealthRecord> createState() => _HealthRecordState();
}

class _HealthRecordState extends State<HealthRecord> {
  final int _lab = 0;
  final int _imaging = 0;
  final int _vitals = 0;
  final int _medHistory = 0;
  final int _consultNotes = 0;

  int _selectedTab = 0;

  final List<String> _tabs = ['All Records', 'Verified Only', 'Timeline View'];

  final List<int> _tabCounts = [0, 0, 0];

  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'All Types';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onAddRecord() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Add Record pressed')));
  }

  void _onExportAll() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Export All pressed')));
  }

  @override
  Widget build(BuildContext context) {
    const double pageMaxWidth = 1200;
    final bool isMobile = AppResponsive.isMobile(context);

    return Material(
      color: const Color(0xFFF6F7FB), // same background as before
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: pageMaxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------- HEADER ----------------
                PageHeader(
                  title: 'Health Records',
                  subtitle: 'Manage and view your medical records',
                  button1Icon: Icons.add,
                  button1Text:  isMobile ? 'Record' : 'Add Record',
                  button1OnPressed: _onAddRecord,
                  button2Icon: Icons.download_outlined,
                  button2Text:  isMobile ? 'Export' : 'Export All',
                  button2OnPressed: _onExportAll,
                  padding: const EdgeInsets.only(bottom: 20),
                ),

                // ---------------- SEARCH + DROPDOWN ----------------
                LayoutBuilder(
                  builder: (context, constraints) {
                    final bool narrow = constraints.maxWidth < 720;

                    if (narrow) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSearchField(width: constraints.maxWidth),
                          const SizedBox(height: 12),
                          _buildTypeDropdown(width: constraints.maxWidth),
                          const SizedBox(height: 20),
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildSearchField(
                              width: constraints.maxWidth * 0.6,
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 160,
                            child: _buildTypeDropdown(width: 160),
                          ),
                        ],
                      );
                    }
                  },
                ),

                const SizedBox(height: 12),

                // ---------------- STAT CARDS ----------------
                LayoutBuilder(
                  builder: (context, constraints) {
                    double maxW = constraints.maxWidth;
                    double cardWidth = _cardWidthForRecords(maxW);

                    return Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              setState(() => _selectedType = 'Lab Results'),
                          child: VerticalStatCard(
                            title: 'Lab Results',
                            count: _lab,
                            icon: Icons.science_outlined,
                            iconColor: Colors.blue,
                            width: cardWidth,
                          ),
                        ),

                        GestureDetector(
                          onTap: () =>
                              setState(() => _selectedType = 'Medical Imaging'),
                          child: VerticalStatCard(
                            title: 'Medical Imaging',
                            count: _imaging,
                            icon: Icons.camera_alt_outlined,
                            iconColor: Colors.blue,
                            width: cardWidth,
                          ),
                        ),

                        GestureDetector(
                          onTap: () =>
                              setState(() => _selectedType = 'Vital Signs'),
                          child: VerticalStatCard(
                            title: 'Vital Signs',
                            count: _vitals,
                            icon: Icons.show_chart,
                            iconColor: Colors.blue,
                            width: cardWidth,
                          ),
                        ),

                        GestureDetector(
                          onTap: () => setState(
                            () => _selectedType = 'Medication History',
                          ),
                          child: VerticalStatCard(
                            title: 'Medication History',
                            count: _medHistory,
                            icon: Icons.favorite_border,
                            iconColor: Colors.blue,
                            width: cardWidth,
                          ),
                        ),

                        GestureDetector(
                          onTap: () => setState(
                            () => _selectedType = 'Consultation Notes',
                          ),
                          child: VerticalStatCard(
                            title: 'Consultation Notes',
                            count: _consultNotes,
                            icon: Icons.medical_services_outlined,
                            iconColor: Colors.blue,
                            width: cardWidth,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),

                // ---------------- TABS ----------------
                TabToggle(
                  options: _tabs,
                  counts: _tabCounts,
                  selectedIndex: _selectedTab,
                  onSelected: (index) => setState(() => _selectedTab = index),
  
                ),

                const SizedBox(height: 28),

                Center(
                  child: Text(
                    'No records yet. Add a record to get started.',
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                  ),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- SEARCH FIELD ----------------
  Widget _buildSearchField({required double width}) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search records...',
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 14,
          ),
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
    );
  }

  // ---------------- DROPDOWN ----------------
  Widget _buildTypeDropdown({required double width}) {
    return SizedBox(
      width: width,
      height: 48,
      child: DropdownButtonFormField<String>(
        value: _selectedType,
        isExpanded: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        items: <String>[
          'All Types',
          'Lab Results',
          'Medical Imaging',
          'Vital Signs',
          'Medication History',
          'Consultation Notes',
        ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
        onChanged: (v) => setState(() => _selectedType = v ?? 'All Types'),
      ),
    );
  }

  // ---------------- CARD WIDTH LOGIC ----------------
 double _cardWidthForRecords(double maxWidth) {
  if (maxWidth >= 1200) {
    return (maxWidth - 20 * 4) / 5;   // 5 per row
  } else if (maxWidth >= 900) {
    return (maxWidth - 20 * 3) / 4;   // 4 per row
  } else if (maxWidth >= 650) {
    return (maxWidth - 20 * 2) / 3;   // 3 per row
  } else if (maxWidth >= 420) {
    return (maxWidth - 20) / 2;       // 2 per row (MOBILE)
  } else {
    return maxWidth;                  // 1 per row (small screen)
  }
}

}
