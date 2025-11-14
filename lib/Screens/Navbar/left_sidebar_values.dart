import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/HealthProvider/consultations_component.dart';
import 'package:healthcare_plus/Screens/HealthProvider/dashboard_component.dart';
import 'package:healthcare_plus/Screens/HealthProvider/earnings_compoenent.dart';
import 'package:healthcare_plus/Screens/HealthProvider/patients_component.dart';
import 'package:healthcare_plus/Screens/HealthProvider/payment_links_component.dart';
import 'package:healthcare_plus/Screens/HealthProvider/schedule_component.dart';
import 'package:healthcare_plus/Screens/HealthProvider/settings_component.dart';
import 'package:healthcare_plus/Screens/HealthProvider/verification_component.dart';

/// Dynamic Sidebar model and role-based lists.
/// Edit these arrays to change icons, titles, routes and notification counts.

class SidebarItem {
  final IconData icon;
  final String title;
  final String route;
  final int notificationCount;
  final Widget? page; // ⬅ add this
  final List<SidebarItem>? children; // optional sub-items (for nested menus)

  SidebarItem({
    required this.icon,
    required this.title,
    required this.route,
    this.notificationCount = 0,
    this.page, // ⬅ add this
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
    icon: Icons.home_rounded,
    title: 'Dashboard',
    route: '/doctor/dashboard',
    page: HealthProviderDashboard(),
    notificationCount: 2 // blue selected item
  ),

  SidebarItem(
    icon: Icons.people_alt_outlined,
    title: 'Patients',
    route: '/doctor/patients',
    page: PatientsComponent(),
  ),

  SidebarItem(
    icon: Icons.calendar_today_rounded,
    title: 'Schedule',
    route: '/doctor/schedule',
    notificationCount: 12,
    page: ScheduleComponent(), // badge like image
  ),

  SidebarItem(
    icon: Icons.chat_bubble_outline,
    title: 'Consultations',
    route: '/doctor/consultations',
    page: ConsultationsComponent(),
  ),

  SidebarItem(
    icon: Icons.monitor_heart_outlined,
    title: 'Earnings',
    route: '/doctor/earnings',
    page: EarningsComponent()
  ),

  SidebarItem(
    icon: Icons.link,
    title: 'Payment Links',
    route: '/doctor/payment-links',
    page: PaymentLinksComponent(),
  ),

  SidebarItem(
    icon: Icons.verified_user_outlined,
    title: 'Verification',
    route: '/doctor/verification', // light-grey selection like image
    page: VerificationComponent(),
  ),

  SidebarItem(
    icon: Icons.settings,
    title: 'Settings',
    route: '/doctor/settings',
    page: SettingsComponent(),
  ),
];
