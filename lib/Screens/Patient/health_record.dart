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
    // center and constrain to a comfortable width similar to screenshot
  final bool isMobile = AppResponsive.isMobile(context);
    return Material(
      child: SingleChildScrollView(
        padding: AppResponsive.pagePadding(context),
        child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with two action buttons (PageHeader handles responsive)
                PageHeader(
                  title: 'Health Records',
                  subtitle: 'Manage and view your medical records',
                  button1Icon: Icons.add,
                  button1Text:  isMobile ? 'Record' : 'Add Record' ,
                  button1OnPressed: _onAddRecord,
                  button2Icon: Icons.download_outlined,
                  button2Text: isMobile ? 'Export' : 'Export All',
                  button2OnPressed: _onExportAll,
                ),

                // SEARCH + TYPE DROPDOWN (responsive)
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (isMobile) {
                      // stacked on narrow screens
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
                      // single row on wide screens
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
                          const SizedBox(height: 20),
                        ],
                      );
                    }
                  },
                ),

                const SizedBox(height: 8),

                // Statistic cards (cards layout is responsive)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final double maxW = constraints.maxWidth;
                    final double cardWidth = _cardWidthForRecords(maxW);

                    return Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        // _recordCard('Lab Results', _lab, Icons.science_outlined, Colors.blue, cardWidth),
                        VerticalStatCard(
                          title: 'Lab Results',
                          count: _lab,
                          icon: Icons.science_outlined,
                          iconColor: Colors.blue,
                          width: cardWidth,
                        ),
                        VerticalStatCard(
                          title: 'Medical Imaging',
                          count: _imaging,
                          icon: Icons.camera_alt_outlined,
                          iconColor: Colors.blue,
                          width: cardWidth,
                        ),
                        VerticalStatCard(
                          title: 'Vital Signs',
                          count: _vitals,
                          icon: Icons.show_chart,
                          iconColor: Colors.blue,
                          width: cardWidth,
                        ),
                        VerticalStatCard(
                          title: 'Medication History',
                          count: _medHistory,
                          icon: Icons.favorite_border,
                          iconColor: Colors.blue,
                          width: cardWidth,
                        ),
                        VerticalStatCard(
                          title: 'Consultation Notes',
                          count: _consultNotes,
                          icon: Icons.medical_services_outlined,
                          iconColor: Colors.blue,
                          width: cardWidth,
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),

                TabToggle(
                  options: _tabs,
                  counts: _tabCounts,
                  selectedIndex: _selectedTab,
                  onSelected: (index) => setState(() => _selectedTab = index),
                  height: 42, // tune to match your UI
                  fontSize: 13, // tune to match your UI
                ),

                const SizedBox(height: 28),

                // Simple content placeholder
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
    );
  }

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

  Widget _buildTypeDropdown({required double width}) {
    return SizedBox(
      height: 48,
      child: DropdownButtonFormField<String>(
        value: _selectedType,
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
          'Imaging',
          'Vitals',
          'Medication',
          'Consultation',
        ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
        onChanged: (v) => setState(() => _selectedType = v ?? 'All Types'),
      ),
    );
  }

  /// Calculates a comfortable width to show 5 cards in a single row on large screens,
  /// 3 per row on medium (tablet), 2 per row when narrower, and 1 per row on mobile.
  double _cardWidthForRecords(double maxWidth) {
    // spacing between cards is 20; we want to compute widths that look like screenshot
    if (maxWidth >= 1200) {
      // five cards across
      final totalSpacing = 20.0 * (5 - 1);
      return (maxWidth - totalSpacing) / 5.4;
    } else if (maxWidth >= 900) {
      // four across
      final totalSpacing = 20.0 * (4 - 1);
      return (maxWidth - totalSpacing) / 4;
    } else if (maxWidth >= 640) {
      // three across (tablet)
      final totalSpacing = 20.0 * (3 - 1);
      return (maxWidth - totalSpacing) / 3;
    } else if (maxWidth >= 420) {
      // two across (small tablet / large phone)
      final totalSpacing = 20.0 * (2 - 1);
      return (maxWidth - totalSpacing) / 2;
    } else {
      // mobile: full width
      return maxWidth;
    }
  }
}
