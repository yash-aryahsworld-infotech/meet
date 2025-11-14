import 'package:flutter/material.dart';
import 'package:healthcare_plus/Screens/HealthProvider/consultations_component.dart';
import 'package:healthcare_plus/Screens/HealthProvider/dashboard_component.dart';
import 'package:healthcare_plus/Screens/HealthProvider/earnings_compoenent.dart';
import 'package:healthcare_plus/Screens/HealthProvider/patients_component.dart';
import 'package:healthcare_plus/Screens/HealthProvider/payment_links_component.dart';
import 'package:healthcare_plus/Screens/HealthProvider/schedule_component.dart';
import 'package:healthcare_plus/Screens/HealthProvider/settings_component.dart';
import 'package:healthcare_plus/Screens/HealthProvider/verification_component.dart';
import 'package:healthcare_plus/Screens/Patient/analytics.dart';
import 'package:healthcare_plus/Screens/Patient/appointments.dart';
import 'package:healthcare_plus/Screens/Patient/health_record.dart';
import 'package:healthcare_plus/Screens/Patient/help_and_support.dart';
import 'package:healthcare_plus/Screens/Patient/insurance.dart';
import 'package:healthcare_plus/Screens/Patient/payments.dart';
import 'package:healthcare_plus/Screens/Patient/prescriptions.dart';
import 'package:healthcare_plus/Screens/Patient/privacy_and_consent.dart';
import 'package:healthcare_plus/Screens/Patient/security.dart';
import 'package:healthcare_plus/Screens/Patient/upload_documents.dart';
import 'package:healthcare_plus/Screens/Patient/wallet.dart';
import 'package:healthcare_plus/Screens/Patient/wellness.dart';

import '../Corporate/analytics_page.dart';
import '../Corporate/billing_page.dart';
import '../Corporate/corporate_home_page.dart';
import '../Corporate/employee_page.dart';
import '../Corporate/programs_page.dart';
import '../Corporate/settings_page.dart';
import '../Patient/book_consultation.dart';
import '../Patient/patient_dashboard.dart';

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
    route: '/patientdashboard',
    page: PatientDashboard(),
  ),
  SidebarItem(
    icon: Icons.video_call,
    title: 'Book Consultation',
    route: '/bookconsultation',
    page: BookConsultation(),
  ),
  SidebarItem(
    icon: Icons.calendar_today_outlined,
    title: 'Appointments',
    route: '/appointments',
    page: Appointments(),
  ),
  SidebarItem(
    icon: Icons.medication_outlined,
    title: 'Prescriptions',
    route: '/prescriptions',
    page: Prescriptions(),
  ),
  SidebarItem(
    icon: Icons.folder_shared,
    title: 'Health Records',
    route: '/health-records',
    page: HealthRecord(),
  ),
  SidebarItem(
    icon: Icons.upload_file,
    title: 'Upload Documents',
    route: '/upload-docs',
    page: UploadDocuments(),
  ),
  SidebarItem(
    icon: Icons.shield_outlined,
    title: 'Insurance',
    route: '/insurance',
    page: Insurance(),
  ),
  SidebarItem(
    icon: Icons.favorite,
    title: 'Wellness',
    route: '/wellness',
    page: Wellness(),
  ),
  SidebarItem(
    icon: Icons.show_chart,
    title: 'Analytics',
    route: '/analytics',
    page: Analytics(),
  ),
  SidebarItem(
    icon: Icons.shield,
    title: 'Security',
    route: '/security',
    page: Security(),
  ),
  SidebarItem(
    icon: Icons.payment,
    title: 'Payments',
    route: '/payments',
    page: Payments(),
  ),
  SidebarItem(
    icon: Icons.wallet,
    title: 'Wallet',
    route: '/wallet',
    page: Wallet(),
  ),
  SidebarItem(
    icon: Icons.privacy_tip_outlined,
    title: 'Privacy & Consent',
    route: '/privacyconsent',
    page: PrivacyAndConsent(),
  ),
  SidebarItem(
    icon: Icons.help_outline,
    title: 'Help & Support',
    route: '/help',
    page: HelpAndSupport(),
  ),
];

/// Example Sidebar for DOCTOR role
final List<SidebarItem> healthProviderSidebar = [
  SidebarItem(
      icon: Icons.home_rounded,
      title: 'Dashboard',
      route: '/doctor/dashboard',
      page: HealthProviderDashboard(),

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

final List<SidebarItem> corporateSidebar = [
  SidebarItem(
      icon: Icons.home_rounded,
      title: 'Dashboard',
      route: '/corporate/dashboard',
      page: CorporateDashboard(),
      notificationCount: 2 // blue selected item
  ),

  SidebarItem(
    icon: Icons.people_alt_outlined,
    title: 'Employees',
    route: '/corporate/employees',
    page: CorporateEmployeesPage(),
  ),

  SidebarItem(
    icon: Icons.favorite,
    title: 'Programs',
    route: '/corporate/programs',
    notificationCount: 12,
    page: CorporateProgramsPage(), // badge like image
  ),

  SidebarItem(
    icon: Icons.chat_bubble_outline,
    title: 'Analytics',
    route: '/corporate/analytics',
    page: CorporateAnalyticsPage(),
  ),

  SidebarItem(
    icon: Icons.monitor_heart_outlined,
    title: 'Billings',
    route: '/corporate/billings',
    page: CorporateBillingPage(),
  ),

  SidebarItem(
    icon: Icons.link,
    title: 'Settings',
    route: '/corporate/settings',
    page: CorporateSettingsPage(),
  ),
];