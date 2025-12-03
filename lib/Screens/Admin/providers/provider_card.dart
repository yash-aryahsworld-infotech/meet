import 'package:flutter/material.dart';

// --- 1. DATA MODEL ---
class ProviderModel {
  final String name;
  final String email;
  final String location;
  final String status; // 'Verified', 'Pending', 'Rejected'
  final List<String> specialties;
  final double rating;
  final int consultations;
  final int fee;

  ProviderModel({
    required this.name,
    required this.email,
    required this.location,
    required this.status,
    required this.specialties,
    required this.rating,
    required this.consultations,
    required this.fee,
  });
}

// --- 2. MAIN PAGE WIDGET ---
class ProviderManagementSection extends StatefulWidget {
  const ProviderManagementSection({super.key});

  @override
  State<ProviderManagementSection> createState() => _ProviderManagementSectionState();
}

class _ProviderManagementSectionState extends State<ProviderManagementSection> {
  // State for active tab
  String _selectedTab = 'All Providers';
  
  // Dummy Data
  final List<ProviderModel> _providers = [
    ProviderModel(
      name: "Dr. Rajesh Kumar",
      email: "rajesh.kumar@healthcare.com",
      location: "Mumbai, Maharashtra",
      status: "Verified",
      specialties: ["Cardiology", "Internal Medicine"],
      rating: 4.8,
      consultations: 1250,
      fee: 800,
    ),
    ProviderModel(
      name: "Dr. Priya Sharma",
      email: "priya.sharma@healthcare.com",
      location: "Delhi, Delhi",
      status: "Verified",
      specialties: ["Pediatrics", "Neonatology"],
      rating: 4.9,
      consultations: 980,
      fee: 700,
    ),
    ProviderModel(
      name: "Dr. Amit Patel",
      email: "amit.patel@healthcare.com",
      location: "Bangalore, Karnataka",
      status: "Pending",
      specialties: ["Orthopedics"],
      rating: 4.6,
      consultations: 650,
      fee: 900,
    ),
    ProviderModel(
      name: "Dr. Vikram Singh",
      email: "vikram.singh@healthcare.com",
      location: "Pune, Maharashtra",
      status: "Rejected",
      specialties: ["Neurology"],
      rating: 4.2,
      consultations: 300,
      fee: 1200,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Filter logic
    List<ProviderModel> displayedProviders;
    if (_selectedTab == 'All Providers') {
      displayedProviders = _providers;
    } else if (_selectedTab == 'Verified') {
      displayedProviders = _providers.where((p) => p.status == 'Verified').toList();
    } else if (_selectedTab == 'Pending') {
      displayedProviders = _providers.where((p) => p.status == 'Pending').toList();
    } else {
      displayedProviders = _providers.where((p) => p.status == 'Rejected').toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Search Bar Component ---
        const ProviderSearchBar(),
        
        const SizedBox(height: 20),

        // --- Tab Toggle Component ---
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTab('All Providers', 5),
              const SizedBox(width: 12),
              _buildTab('Verified', 3),
              const SizedBox(width: 12),
              _buildTab('Pending', 1),
              const SizedBox(width: 12),
              _buildTab('Rejected', 1),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // --- Provider Cards List ---
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayedProviders.length,
          separatorBuilder: (ctx, index) => const SizedBox(height: 16),
          itemBuilder: (ctx, index) {
            return ProviderCard(provider: displayedProviders[index]);
          },
        ),
      ],
    );
  }

  // Helper to build Tab Buttons
  Widget _buildTab(String title, int count) {
    bool isSelected = _selectedTab == title || (_selectedTab == 'All Providers' && title.startsWith('All'));
    // Simple logic for "All Providers" matching, adjust as needed for strict matching
    if (title == 'All Providers') isSelected = _selectedTab == 'All Providers';
    else isSelected = _selectedTab == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))]
              : [],
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.black87 : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              "($count)",
              style: TextStyle(
                color: isSelected ? Colors.black87 : Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 3. SEARCH BAR COMPONENT ---
class ProviderSearchBar extends StatelessWidget {
  const ProviderSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Search providers by name, specialty, or location...",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

// --- 4. PROVIDER CARD COMPONENT ---
class ProviderCard extends StatelessWidget {
  final ProviderModel provider;

  const ProviderCard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade100,
            child: Text(
              _getInitials(provider.name),
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Info Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name Row
                Row(
                  children: [
                    Text(
                      provider.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusBadge(provider.status),
                  ],
                ),
                const SizedBox(height: 4),
                
                // Email
                Text(
                  provider.email,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 8),

                // Metrics Row (Location, Rating, Fee)
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    _buildIconMeta(Icons.location_on_outlined, provider.location),
                    _buildIconMeta(Icons.star_outline_rounded, "${provider.rating} (${provider.consultations} consultations)"),
                    _buildIconMeta(Icons.currency_rupee, "${provider.fee}"),
                  ],
                ),
                const SizedBox(height: 12),

                // Specialty Chips
                Wrap(
                  spacing: 8,
                  children: provider.specialties.map((spec) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      spec,
                      style: TextStyle(color: Colors.grey.shade800, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),

          // Action Column (Dynamic buttons based on status)
          const SizedBox(width: 12),
          _buildActionButtons(provider.status),
        ],
      ),
    );
  }

  // --- Logic for Buttons based on Images provided ---
  Widget _buildActionButtons(String status) {
    if (status == 'Pending') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Approve Button (Blue)
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2), // Blue
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text("Approve"),
          ),
          const SizedBox(width: 8),
          // Reject Button (Red)
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F), // Red
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text("Reject"),
          ),
        ],
      );
    } else if (status == 'Rejected') {
      // Rejected Badge (Red)
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFD32F2F),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cancel_outlined, color: Colors.white, size: 16),
            SizedBox(width: 4),
            Text("Rejected", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      );
    } else {
      // Default / Verified: View Details
      return OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.grey.shade700,
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        child: const Text("View Details"),
      );
    }
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color text;
    IconData icon;
    String label = status;

    if (status == 'Verified') {
      bg = const Color(0xFFE8F5E9); // Green 50
      text = const Color(0xFF2E7D32); // Green 800
      icon = Icons.check_circle_outline;
    } else if (status == 'Pending') {
      bg = const Color(0xFFFFF3E0); // Orange 50
      text = const Color(0xFFEF6C00); // Orange 800
      icon = Icons.access_time;
    } else {
      bg = const Color(0xFFFFEBEE); // Red 50
      text = const Color(0xFFC62828); // Red 800
      icon = Icons.cancel_outlined;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: text),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: text, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildIconMeta(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
      ],
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return "?";
    List<String> names = name.split(" ");
    String initials = "";
    if (names.isNotEmpty) initials += names[0][0];
    if (names.length > 1) initials += names[names.length - 1][0];
    return initials.toUpperCase();
  }
}