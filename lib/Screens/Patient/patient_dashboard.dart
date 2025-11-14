import 'package:flutter/material.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';

class PatientDashboard extends StatelessWidget {
  const PatientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = AppResponsive.isMobile(context);
    final isTablet = AppResponsive.isTablet(context);
    final isDesktop = AppResponsive.isDesktop(context);

    return MaxWidthContainer(
      child: Padding(
        padding: AppResponsive.pagePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HEADER SECTION
            _PatientHeader(),

            const SizedBox(height: 20),

            /// QUICK STATS
            _QuickStats(),

            const SizedBox(height: 20),

            /// MAIN SECTIONS — RESPONSIVE
            if (isMobile) ...[
              _UpcomingAppointments(),
              const SizedBox(height: 20),
              _HealthRecords(),
            ]
            else if (isTablet) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(child: _UpcomingAppointments()),
                  SizedBox(width: 20),
                  Expanded(child: _HealthRecords()),
                ],
              )
            ]
            else if (isDesktop) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(flex: 7, child: _UpcomingAppointments()),
                    SizedBox(width: 20),
                    Expanded(flex: 5, child: _HealthRecords()),
                  ],
                ),
              ]
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
/// WIDGETS BELOW
///////////////////////////////////////////////////////////////////////////////

/// ---------------------- HEADER ---------------------------
class _PatientHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 35,
          backgroundImage: AssetImage("assets/images/user.png"),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Welcome Back, Aryah!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.circle, size: 12, color: Colors.green),
                SizedBox(width: 6),
                Text("Online", style: TextStyle(color: Colors.green)),
              ],
            )
          ],
        )
      ],
    );
  }
}

/// ---------------------- QUICK STATS ---------------------------
class _QuickStats extends StatelessWidget {
  const _QuickStats();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: const [
        _StatCard(
          title: "Upcoming",
          value: "02",
          icon: Icons.calendar_today,
        ),
        _StatCard(
          title: "Prescriptions",
          value: "06",
          icon: Icons.medication_outlined,
        ),
        _StatCard(
          title: "Health Score",
          value: "89",
          icon: Icons.favorite,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue.shade50,
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14)),
              Text(
                value,
                style:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}

/// ---------------------- UPCOMING APPOINTMENTS ---------------------------
class _UpcomingAppointments extends StatelessWidget {
  const _UpcomingAppointments();

  @override
  Widget build(BuildContext context) {
    return _CardContainer(
      title: "Upcoming Appointments",
      child: Column(
        children: [
          _AppointmentTile(
            doctor: "Dr. Priya",
            date: "15 Nov, 2025",
            time: "10:00 AM",
            type: "Video Consultation",
          ),
          const Divider(),
          _AppointmentTile(
            doctor: "Dr. Amit",
            date: "20 Nov, 2025",
            time: "4:30 PM",
            type: "Clinic Visit",
          ),
        ],
      ),
    );
  }
}

class _AppointmentTile extends StatelessWidget {
  final String doctor;
  final String date;
  final String time;
  final String type;

  const _AppointmentTile({
    required this.doctor,
    required this.date,
    required this.time,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(doctor, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("$date • $time\n$type"),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}

/// ---------------------- HEALTH RECORDS ---------------------------
class _HealthRecords extends StatelessWidget {
  const _HealthRecords();

  @override
  Widget build(BuildContext context) {
    return _CardContainer(
      title: "Health Records",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ListTile(
            leading: Icon(Icons.folder, color: Colors.orange),
            title: Text("Blood Test Report"),
            subtitle: Text("Uploaded: 10 Nov 2025"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.folder, color: Colors.orange),
            title: Text("X-Ray Report"),
            subtitle: Text("Uploaded: 07 Nov 2025"),
          ),
        ],
      ),
    );
  }
}

/// Reusable white card container
class _CardContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const _CardContainer({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
