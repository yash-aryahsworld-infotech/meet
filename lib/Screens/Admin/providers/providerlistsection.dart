// Mock Data Model (Same as before)
import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/Admin/providers/genericsearchbar.dart';
import "./provider_card.dart";
import 'package:healthcare_plus/widgets/custom_tab.dart';



class ProviderListSection extends StatefulWidget {
  const ProviderListSection({super.key});

  @override
  State<ProviderListSection> createState() => _ProviderListSectionState();
}

class _ProviderListSectionState extends State<ProviderListSection> {
  // --- Data & State ---
  final List<Provider> _allProviders = [
    Provider(id: '1', name: 'Dr. Rajesh Kumar', email: 'rajesh.kumar@healthcare.com', location: 'Mumbai, Maharashtra', rating: 4.8, consultationCount: 1250, price: 800, specialties: ['Cardiology', 'Internal Medicine'], status: 'Verified', initials: 'DRK'),
    Provider(id: '2', name: 'Dr. Priya Sharma', email: 'priya.sharma@healthcare.com', location: 'Delhi, Delhi', rating: 4.9, consultationCount: 980, price: 700, specialties: ['Pediatrics', 'Neonatology'], status: 'Verified', initials: 'DPS'),
    Provider(id: '3', name: 'Dr. Amit Patel', email: 'amit.patel@healthcare.com', location: 'Bangalore, Karnataka', rating: 4.6, consultationCount: 650, price: 900, specialties: ['Orthopedics'], status: 'Pending', initials: 'DAP'),
    Provider(id: '5', name: 'Dr. Vikram Singh', email: 'vikram.singh@healthcare.com', location: 'Pune, Maharashtra', rating: 4.5, consultationCount: 300, price: 1000, specialties: ['Neurology'], status: 'Rejected', initials: 'DVS'),
  ];

  String _searchQuery = '';
  final List<String> _tabOptions = ['All Providers', 'Verified', 'Pending', 'Rejected'];
  String _selectedTab = 'All Providers';

  // --- Logic ---
  List<Provider> get _filteredProviders {
    return _allProviders.where((provider) {
      // Tab Logic
      bool matchesTab = (_selectedTab == 'All Providers') || (provider.status == _selectedTab);
      
      // Search Logic
      if (_searchQuery.isEmpty) return matchesTab;
      final query = _searchQuery.toLowerCase();
      bool matchesSearch = provider.name.toLowerCase().contains(query) ||
          provider.specialties.any((s) => s.toLowerCase().contains(query)) ||
          provider.location.toLowerCase().contains(query);

      return matchesTab && matchesSearch;
    }).toList();
  }

  int _getCount(String status) {
    if (status == 'All Providers') return _allProviders.length;
    return _allProviders.where((p) => p.status == status).length;
  }

  // --- Handlers ---
  void _handleApprove(Provider p) {
    // API Call logic here
    print("Approved ${p.name}");
  }

  void _handleReject(Provider p) {
    print("Rejected ${p.name}");
  }

  @override
  Widget build(BuildContext context) {
    // Assuming TabToggle is imported from your widgets folder
    // If not, use a standard TabBar or your custom widget
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Reusable Search Bar
        GenericSearchBar(
          hintText: 'Search providers by name, specialty, or location...',
          onChanged: (value) => setState(() => _searchQuery = value),
        ),
        
        const SizedBox(height: 24),

        // 2. Custom Tab Toggle (Your existing widget)
        TabToggle(
          options: _tabOptions,
          counts: _tabOptions.map((opt) => _getCount(opt)).toList(),
          selectedIndex: _tabOptions.indexOf(_selectedTab),
          onSelected: (index) => setState(() => _selectedTab = _tabOptions[index]),
        ),

        const SizedBox(height: 24),

        // 3. Provider List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _filteredProviders.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final provider = _filteredProviders[index];
            
            // 4. Reusable Provider Card
            return ProviderCard(
              provider: provider,
              onApprove: () => _handleApprove(provider),
              onReject: () => _handleReject(provider),
              onViewDetails: () { /* Navigate */ },
            );
          },
        ),
      ],
    );
  }
}