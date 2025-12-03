import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/Admin/providers/providerstatusbadge.dart';

class Provider {
  final String id;
  final String name;
  final String email;
  final String location;
  final double rating;
  final int consultationCount;
  final int price;
  final List<String> specialties;
  final String status; // 'Verified', 'Pending', 'Rejected'
  final String initials;

  Provider({
    required this.id,
    required this.name,
    required this.email,
    required this.location,
    required this.rating,
    required this.consultationCount,
    required this.price,
    required this.specialties,
    required this.status,
    required this.initials,
  });
}

class ProviderCard extends StatelessWidget {
  final Provider provider;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onViewDetails;

  const ProviderCard({
    super.key,
    required this.provider,
    this.onApprove,
    this.onReject,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(),
          const SizedBox(width: 16),
          Expanded(child: _buildMainInfo()),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Text(
          provider.initials,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildMainInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            ProviderStatusBadge(status: provider.status),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          provider.email,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
        ),
        const SizedBox(height: 8),
        _buildStatsRow(),
        const SizedBox(height: 12),
        _buildSpecialties(),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(provider.location,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        const SizedBox(width: 12),
        const Icon(Icons.star_outline, size: 16, color: Colors.amber),
        const SizedBox(width: 4),
        Text('${provider.rating} (${provider.consultationCount})',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        const SizedBox(width: 12),
        Text('₹${provider.price}',
            style: TextStyle(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w600,
                fontSize: 13)),
      ],
    );
  }

  Widget _buildSpecialties() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: provider.specialties
          .map((specialty) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  specialty,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (provider.status == 'Pending') ...[
          ElevatedButton(
            onPressed: onApprove,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Approve', style: TextStyle(fontSize: 13)),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: onReject,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.transparent),
              backgroundColor: Colors.red.shade50,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Reject', style: TextStyle(fontSize: 13)),
          ),
        ] else if (provider.status == 'Rejected') ...[
           // Status is already shown in badge, but if you want a specific red tag here:
           const SizedBox.shrink() 
        ] else ...[
          OutlinedButton(
            onPressed: onViewDetails,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black87,
              side: BorderSide(color: Colors.grey.shade300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('View Details', style: TextStyle(fontSize: 13)),
          ),
        ],
      ],
    );
  }
}