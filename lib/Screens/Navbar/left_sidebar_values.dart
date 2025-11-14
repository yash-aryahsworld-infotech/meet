import 'package:flutter/material.dart';

/// Dynamic Sidebar model and role-based lists.
/// Edit these arrays to change icons, titles, routes and notification counts.

class SidebarItem {
  final IconData icon;
  final String title;
  final String route;
  final int notificationCount;
  final List<SidebarItem>? children; // optional sub-items (for nested menus)

  SidebarItem({
    required this.icon,
    required this.title,
    required this.route,
    this.notificationCount = 0,
    this.children,
  });
}

/// Example Sidebar for PATIENT role
final List<SidebarItem> patientSidebar = [
  SidebarItem(
    icon: Icons.dashboard,
    title: 'Dashboard',
    route: '/dashboard',
  ),
  SidebarItem(
    icon: Icons.folder_shared,
    title: 'Health Records',
    route: '/health-records',
  ),
  SidebarItem(
    icon: Icons.upload_file,
    title: 'Upload Documents',
    route: '/upload-docs',
  ),
  SidebarItem(
    icon: Icons.shield,
    title: 'Insurance',
    route: '/insurance',
    notificationCount: 0,
  ),
  SidebarItem(
    icon: Icons.favorite,
    title: 'Wellness',
    route: '/wellness',
  ),
  SidebarItem(
    icon: Icons.show_chart,
    title: 'Analytics',
    route: '/analytics',
  ),
  SidebarItem(
    icon: Icons.settings,
    title: 'Security',
    route: '/security',
  ),
  SidebarItem(
    icon: Icons.help_outline,
    title: 'Help & Support',
    route: '/help',
    notificationCount: 2,
  ),
];

/// Example Sidebar for DOCTOR role
final List<SidebarItem> healthProviderSidebar = [
  SidebarItem(
    icon: Icons.dashboard,
    title: 'Dashboard',
    route: '/doctor/dashboard',
  ),
  SidebarItem(
    icon: Icons.calendar_month,
    title: 'Appointments',
    route: '/doctor/appointments',
    notificationCount: 5,
  ),
  SidebarItem(
    icon: Icons.person_search,
    title: 'Patients',
    route: '/doctor/patients',
  ),
  SidebarItem(
    icon: Icons.note,
    title: 'Prescriptions',
    route: '/doctor/prescriptions',
  ),
  SidebarItem(
    icon: Icons.analytics_outlined,
    title: 'Reports',
    route: '/doctor/reports',
  ),
  SidebarItem(
    icon: Icons.settings,
    title: 'Settings',
    route: '/doctor/settings',
  ),
];
