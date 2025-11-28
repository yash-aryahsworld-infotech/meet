import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/Corporate/employee/employee_model.dart';
import 'package:healthcare_plus/Screens/Corporate/employee/employeelistsection.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';
// Assuming your PageHeader is here:
import '../../widgets/custom_header.dart';
import './employee/stat_section.dart';
class EmployeeManagementPage extends StatelessWidget {
  const EmployeeManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Calculate stats dynamically based on the dummy list

    final bool isMobile = AppResponsive.isMobile(context);
    final totalEmployees = allEmployees.length;
    final activeEmployees = allEmployees.where((e) => e.isActive).length;
    final totalHealthScore = allEmployees.fold(0, (sum, e) => sum + e.healthScore);
    final avgHealthScore = (totalHealthScore / totalEmployees).toStringAsFixed(0);
    final totalPrograms = allEmployees.fold(0, (sum, e) => sum + e.programs);

    return Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header (Imported Component)
            PageHeader(
              title: 'Employee Management',
              button1Icon: Icons.add,
              button1Text: isMobile ? 'Employee' : 'Add Employee',
              button1OnPressed: () {},
              button2Text: isMobile ? 'Export' : 'Export Report',
              button2OnPressed: () {},
            ),
            // 2. Stats Section (Updated labels to match image)
            StatsSection(
              total: totalEmployees,
              active: activeEmployees,
              avgScore: avgHealthScore,
              programs: totalPrograms,
            ),

            const SizedBox(height: 24),

            // 3. Employee List Section (Search, Filter, List)
            const EmployeeListSection(),
          ],
        ),
      );
  }
}