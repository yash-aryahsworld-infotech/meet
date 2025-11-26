import 'package:flutter/material.dart';
import 'package:healthcare_plus/widgets/custom_tab.dart';
import './insurancecomponents/statscard.dart';
import '../../widgets/custom_header.dart';
import '../../utils/app_responsive.dart';

class Insurance extends StatefulWidget {
  const Insurance({super.key});

  @override
  State<Insurance> createState() => _InsuranceState();
}
class _InsuranceState extends State<Insurance> {
  // State for the TabToggle
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = AppResponsive.isMobile(context);

    return Material(
      color: const Color(0xFFF5F6FA), // Background color
      child: SingleChildScrollView(
        padding: AppResponsive.pagePadding(context),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header
                PageHeader(
                  title: 'Insurance Management',
                  subtitle: 'Manage your insurance policies and claims',
                  button1Icon: Icons.add,
                  button1Text: isMobile ? 'Add' : 'Add Policy',
                  button1OnPressed: () {},
                  button2Icon: Icons.description_outlined,
                  button2Text: isMobile ? 'Claim' : 'File Claim',
                  button2OnPressed: () {},
                ),

                const SizedBox(height: 24),

                // 2. Stats Section
                const StatsSection(),

                const SizedBox(height: 24),

                // 3. Tab Toggle Section
                // Implemented exactly like the image with counts inside parens
                Align(
                  alignment: Alignment.centerLeft,
                  child: TabToggle(
                    options: const [
                      'Insurance Policies',
                      'Claims',
                      'Coverage Details',
                    ],
                    counts: const [0, 0, 0], 
                    selectedIndex: _selectedTabIndex,
                    onSelected: (index) {
                      setState(() {
                        _selectedTabIndex = index;
                      });
                    },
                  ),
             
                ),

                const SizedBox(height: 20),
                
                // Content Switcher based on Tab
                _buildTabContent()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return const Center(child: Text("Policy List Content"));
      case 1:
        return const Center(child: Text("Claims List Content"));
      case 2:
        return const Center(child: Text("Coverage Details Content"));
      default:
        return const SizedBox.shrink();
    }
  }
}