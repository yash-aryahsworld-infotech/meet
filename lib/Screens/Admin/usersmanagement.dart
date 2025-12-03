import 'package:flutter/material.dart';
import 'package:healthcare_plus/widgets/custom_header.dart';
 // 1. Import Model
import './user_management/stats_section.dart'; // 2. Import Stats
import './user_management/filter_bar.dart'; // 3. Import Filter Bar
import './user_management/users_card.dart'; // 4. Import User Card



class UsersManagementPage extends StatefulWidget {
  const UsersManagementPage({super.key});

  @override
  State<UsersManagementPage> createState() => _UsersManagementPageState();
}

class _UsersManagementPageState extends State<UsersManagementPage> {
  // 1. State Variables for Filtering
  String _searchQuery = '';
  String _selectedRole = 'All Roles';
  String _selectedStatus = 'All Status';

  // 2. Dummy Data (Using Named Parameters now)
  final List<UserModel> _allUsers = [
    UserModel(
      name: "Alice Johnson",
      email: "alice@example.com",
      role: "Admin",
      status: "Active",
      location: "New York, USA",
      joinedDate: "Oct 24, 2023",
      isVerified: true,
    ),
    UserModel(
      name: "Dr. Smith",
      email: "smith@clinic.com",
      role: "Provider",
      status: "Active",
      location: "London, UK",
      joinedDate: "Nov 12, 2023",
      isVerified: true,
      extraInfo: "1250 appointments",
    ),
    UserModel(
      name: "John Doe",
      email: "john.d@gmail.com",
      role: "Patient",
      status: "Inactive",
      location: "Berlin, Germany",
      joinedDate: "Dec 01, 2023",
    ),
  ];

  // 3. Filtering Logic
  List<UserModel> get _filteredUsers {
    return _allUsers.where((user) {
      final matchesSearch = user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.email.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesRole = _selectedRole == 'All Roles' || user.role == _selectedRole;
      final matchesStatus = _selectedStatus == 'All Status' || user.status == _selectedStatus;

      return matchesSearch && matchesRole && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          PageHeader(
            title: "User Management",
            button1Text: "Export Users",
            button1OnPressed: () {},
            button2Text: "Add User",
            button2OnPressed: () {},
          ),

          // Stats Section
          const Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: StatsSection(),
          ),

          // Search and Filters (From filter_bar.dart)
          SearchAndFilters(
            onSearchChanged: (value) => setState(() => _searchQuery = value),
            selectedRole: _selectedRole,
            onRoleChanged: (val) => setState(() => _selectedRole = val!),
            selectedStatus: _selectedStatus,
            onStatusChanged: (val) => setState(() => _selectedStatus = val!),
          ),

          const SizedBox(height: 16),

          // User List Table (From users_card.dart)
          UserListTable(users: _filteredUsers),
          
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}