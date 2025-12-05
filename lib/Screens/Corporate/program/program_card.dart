import 'package:flutter/material.dart';

class ProgramCard extends StatelessWidget {
  final String title;
  final String category;
  final String status; // Added status field
  final Color categoryColor;
  final IconData categoryIcon;
  final String description;
  final String instructor;
  final String duration;
  final String enrolled;
  final String totalSpots;
  final String cost;
  final double enrollmentProgress;
  final double completionRate;

  const ProgramCard({
    super.key,
    required this.title,
    required this.category,
    required this.status, // Required in constructor
    required this.categoryColor,
    required this.categoryIcon,
    required this.description,
    required this.instructor,
    required this.duration,
    required this.enrolled,
    required this.totalSpots,
    required this.cost,
    required this.enrollmentProgress,
    required this.completionRate,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header Section ---
              if (isMobile)
                _buildMobileHeader()
              else
                _buildDesktopHeader(),

              const SizedBox(height: 12),
              
              // --- Description ---
              Text(
                description,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              const SizedBox(height: 24),

              // --- Info Grid ---
              if (isMobile)
                _buildMobileInfoGrid()
              else
                _buildDesktopInfoRow(),

              const SizedBox(height: 24),
              const Divider(height: 1),
              const SizedBox(height: 24),

              // --- Progress Bars ---
              _buildProgressBar("Enrollment Progress", enrollmentProgress),
              const SizedBox(height: 16),
              _buildProgressBar("Completion Rate", completionRate),
              
              // --- Mobile Actions (Bottom) ---
              if (isMobile) ...[
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _buildActionButton("Duplicate")),
                    const SizedBox(width: 12),
                    Expanded(child: _buildActionButton("View Details")),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // --- Sub-widgets for Layouts ---

  Widget _buildDesktopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              _buildCategoryBadge(),
              const SizedBox(width: 8),
              _buildStatusBadge(), // Uses dynamic status
            ],
          ),
        ),
        Row(
          children: [
            _buildActionButton("Duplicate"),
            const SizedBox(width: 8),
            _buildActionButton("View Details"),
          ],
        )
      ],
    );
  }

  Widget _buildMobileHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildCategoryBadge(),
            _buildStatusBadge(), // Uses dynamic status
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoItem("Instructor", instructor),
        _buildInfoItem("Duration", duration),
        _buildInfoItem("Enrollment", "$enrolled/$totalSpots"),
        _buildInfoItem("Cost", cost),
      ],
    );
  }

  Widget _buildMobileInfoGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildInfoItem("Instructor", instructor)),
            Expanded(child: _buildInfoItem("Duration", duration)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildInfoItem("Enrollment", "$enrolled/$totalSpots")),
            Expanded(child: _buildInfoItem("Cost", cost)),
          ],
        ),
      ],
    );
  }

  // --- Components ---

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
      ],
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: categoryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(categoryIcon, size: 14, color: categoryColor),
          const SizedBox(width: 4),
          Text(
            category,
            style: TextStyle(
                fontSize: 12, color: categoryColor, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    // Determine colors based on status text
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'active':
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        break;
      case 'draft':
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
        break;
      case 'inactive':
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        break;
      default:
        bgColor = Colors.grey.shade50;
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status, // Dynamic text
        style: TextStyle(
            fontSize: 12, color: textColor, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildProgressBar(String label, double progress) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            Text("${(progress * 100).toInt()}%",
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey.shade100,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.grey.shade700,
        side: BorderSide(color: Colors.grey.shade300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 13)),
    );
  }
}