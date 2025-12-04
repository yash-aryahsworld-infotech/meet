import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/Corporate/employee/employee_model.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;

  const EmployeeCard({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppResponsive.isDesktop(context);

    // If it's Desktop, show the horizontal row layout.
    // If it's Mobile or Tablet, show the stacked vertical layout.
    return Container(
      padding: const EdgeInsets.all(20),
      child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
    );
  }

  // --- Layouts ---

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Header: Avatar + Details
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Avatar(name: employee.name),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _NameAndBadges(employee: employee),
                  const SizedBox(height: 4),
                  _EmailAndRole(employee: employee),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // 2. Stats
        _StatsRow(employee: employee),

        const SizedBox(height: 20),

        // 3. Stacked Buttons (Full Width)
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _InviteButton(),
            const SizedBox(height: 12),
            _ViewDetailsButton(isFullWidth: true),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _Avatar(name: employee.name),
        const SizedBox(width: 16),
        
        // Middle Section: Info + Stats
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NameAndBadges(employee: employee),
              const SizedBox(height: 4),
              _EmailAndRole(employee: employee, isDesktop: true),
              const SizedBox(height: 8),
              _StatsRow(employee: employee),
            ],
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Right Section: Buttons Side-by-Side
        Row(
          children: [
            const _InviteButton(),
            const SizedBox(width: 8),
            const _ViewDetailsButton(isFullWidth: false),
          ],
        ),
      ],
    );
  }
}

// --- Sub-Widgets (Private to this file to keep code clean) ---

class _Avatar extends StatelessWidget {
  final String name;
  const _Avatar({required this.name});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: Colors.grey.shade100,
      child: Text(
        name.split(' ').map((n) => n[0]).take(2).join(),
        style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _NameAndBadges extends StatelessWidget {
  final Employee employee;
  const _NameAndBadges({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(employee.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        _Badge(text: employee.status, color: employee.status == "Excellent" ? Colors.green : Colors.orange),
        _Badge(text: employee.risk, color: employee.risk == "Low Risk" ? Colors.green : (employee.risk == "Medium Risk" ? Colors.amber : Colors.red)),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _EmailAndRole extends StatelessWidget {
  final Employee employee;
  final bool isDesktop;
  const _EmailAndRole({required this.employee, this.isDesktop = false});

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return Text.rich(
        TextSpan(
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          children: [
            WidgetSpan(child: Icon(Icons.email_outlined, size: 14, color: Colors.grey.shade400)),
            TextSpan(text: " ${employee.email}   "),
            WidgetSpan(child: Icon(Icons.work_outline, size: 14, color: Colors.grey.shade400)),
            TextSpan(text: " ${employee.department} - ${employee.role}"),
          ],
        ),
      );
    }
    // Mobile View
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(employee.email, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        const SizedBox(height: 2),
        Text("${employee.department} - ${employee.role}", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  final Employee employee;
  const _StatsRow({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16, // Desktop spacing
      runSpacing: 8,
      children: [
        _StatText(label: "Health Score", value: "${employee.healthScore}/100"),
        _StatText(label: "Programs", value: "${employee.programs}"),
        _StatText(label: "Last Checkup", value: employee.lastCheckup),
      ],
    );
  }
}

class _StatText extends StatelessWidget {
  final String label;
  final String value;
  const _StatText({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
        children: [
          TextSpan(text: "$label: ", style: const TextStyle(fontWeight: FontWeight.w600)),
          TextSpan(text: value, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

class _InviteButton extends StatelessWidget {
  const _InviteButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        foregroundColor: Colors.grey.shade700,
      ),
      child: const Text("Invite to Programs", style: TextStyle(color: Colors.black87)),
    );
  }
}

class _ViewDetailsButton extends StatelessWidget {
  final bool isFullWidth;
  const _ViewDetailsButton({required this.isFullWidth});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2962FF),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: isFullWidth ? 0 : 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      child: const Text("View Details", style: TextStyle(color: Colors.white)),
    );
  }
}