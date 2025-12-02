import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/Corporate/employee/employee_model.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';
import './employee_card.dart'; // Import your new file

class EmployeeListSection extends StatefulWidget {
  const EmployeeListSection({super.key});

  @override
  State<EmployeeListSection> createState() => _EmployeeListSectionState();
}

class _EmployeeListSectionState extends State<EmployeeListSection> {
  String _searchQuery = "";
  String _selectedDepartment = "All Departments";

  List<String> get _departments {
    final depts = allEmployees.map((e) => e.department).toSet().toList();
    return ["All Departments", ...depts];
  }

  List<Employee> get _filteredEmployees {
    return allEmployees.where((employee) {
      final matchesSearch = employee.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          employee.email.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesDept = _selectedDepartment == "All Departments" ||
          employee.department == _selectedDepartment;
      return matchesSearch && matchesDept;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppResponsive.isMobile(context);

    return Column(
      children: [
        // --- Filter Row ---
        Flex(
          direction: isMobile ? Axis.vertical : Axis.horizontal,
          children: [
            Expanded(
              flex: isMobile ? 0 : 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search, color: Colors.grey),
                    hintText: "Search employees...",
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            
            SizedBox(
              width: isMobile ? 0 : 16, 
              height: isMobile ? 16 : 0
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade600, width: 1.5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedDepartment,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: _departments.map((String dept) {
                    return DropdownMenuItem<String>(
                      value: dept,
                      child: Text(dept, style: const TextStyle(fontWeight: FontWeight.w500)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedDepartment = val);
                  },
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // --- Employee List ---
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredEmployees.length,
            separatorBuilder: (ctx, i) => Divider(height: 1, color: Colors.grey.shade100),
            itemBuilder: (ctx, index) {
              // The logic is now inside the Widget itself
              return EmployeeCard(employee: _filteredEmployees[index]);
            },
          ),
        ),
      ],
    );
  }
}