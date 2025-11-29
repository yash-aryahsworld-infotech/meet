import 'package:flutter/material.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';
import 'package:healthcare_plus/widgets/custom_button.dart';

class CompanyInfoTab extends StatelessWidget {
  const CompanyInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = AppResponsive.isMobile(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.business, size: 20, color: Colors.grey[700]),
              const SizedBox(width: 10),
              const Text(
                "Company Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Row 1: Company Name & Industry
          _buildResponsiveTwoColumn(
            context,
            child1: _buildInput("Company Name", "TechCorp Ltd"),
            child2: _buildDropdown("Industry", "Technology", [
              "Technology",
              "Finance",
              "Healthcare",
            ]),
          ),
          const SizedBox(height: 16),

          // Row 2: Employees & Timezone
          _buildResponsiveTwoColumn(
            context,
            child1: _buildInput("Number of Employees", "200"),
            child2: _buildDropdown("Timezone", "Asia/Kolkata (IST)", [
              "Asia/Kolkata (IST)",
              "UTC",
              "PST",
            ]),
          ),
          const SizedBox(height: 16),

          // Row 3: Address (Full Width)
          _buildInput(
            "Address",
            "123 Business Park, Bangalore, Karnataka 560001",
            maxLines: 2,
          ),
          const SizedBox(height: 16),

          // Row 4: Phone, Email, Website (3 Columns)
          _buildResponsiveThreeColumn(
            context,
            child1: _buildInput("Phone", "+91 80 1234 5678"),
            child2: _buildInput("Email", "hr@techcorp.com"),
            child3: _buildInput("Website", "https://techcorp.com"),
          ),
          const SizedBox(height: 16),

          // Row 5: Working Hours & Currency
          _buildResponsiveTwoColumn(
            context,
            child1: _buildInput("Working Hours", "09:00-18:00"),
            child2: _buildDropdown("Currency", "INR (₹)", [
              "INR (₹)",
              "USD (\$)",
              "EUR (€)",
            ]),
          ),
          const SizedBox(height: 30),

          // Save Button
          CustomButton(text: "Save Company Setting", width: isMobile ? double.infinity: 210, onPressed: () => {}),
        ],
      ),
    );
  }

  // --- Helpers to make code direct and responsive ---

  // Helper for Text Inputs
  Widget _buildInput(String label, String value, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: value,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFF2563EB)),
            ),
          ),
        ),
      ],
    );
  }

  // Helper for Dropdowns
  Widget _buildDropdown(String label, String value, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: Colors.grey,
          ),
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          items: items.map((String val) {
            return DropdownMenuItem(value: val, child: Text(val));
          }).toList(),
          onChanged: (val) {},
        ),
      ],
    );
  }

  // Responsive Layout: 2 Columns on Desktop, 1 Column on Mobile
  Widget _buildResponsiveTwoColumn(
    BuildContext context, {
    required Widget child1,
    required Widget child2,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile: Stack vertically
          return Column(children: [child1, const SizedBox(height: 16), child2]);
        } else {
          // Desktop: Side by side
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: child1),
              const SizedBox(width: 24), // Gap
              Expanded(child: child2),
            ],
          );
        }
      },
    );
  }

  // Responsive Layout: 3 Columns on Desktop, 1 Column on Mobile
  Widget _buildResponsiveThreeColumn(
    BuildContext context, {
    required Widget child1,
    required Widget child2,
    required Widget child3,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 800) {
          // Mobile/Small Tablet: Stack vertically
          return Column(
            children: [
              child1,
              const SizedBox(height: 16),
              child2,
              const SizedBox(height: 16),
              child3,
            ],
          );
        } else {
          // Desktop: 3 Side by side
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: child1),
              const SizedBox(width: 24),
              Expanded(child: child2),
              const SizedBox(width: 24),
              Expanded(child: child3),
            ],
          );
        }
      },
    );
  }
}
