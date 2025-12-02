import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../utils/app_responsive.dart';
import 'Navbar/left_sidebar.dart';
import 'Navbar/left_sidebar_values.dart';
import 'Navbar/top_navbar.dart';

class DashboardPage extends StatefulWidget {
  final String userRole;
  final String userKey;

  const DashboardPage({
    super.key,
    required this.userRole,
    required this.userKey,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  SidebarItem? activeItem;
  bool isCollapsed = false;

  String userName = "";
  bool isLoading = true;

  // Pick correct sidebar
  List<SidebarItem> get sidebarItems {
    if (widget.userRole.toLowerCase() == "patient") {
      return patientSidebar;
    } else if(widget.userRole.toLowerCase() == "corporate") {
      return corporateSidebar;}
    else if(widget.userRole.toLowerCase() == "admin") {
      return adminSidebar;
    } else {
      return healthProviderSidebar;
    }
  }

  @override
  void initState() {
    super.initState();
    activeItem = sidebarItems[0];
    _loadUserDetails();
  }

  // 🔥 Fetch user name from Firebase by userKey
  Future<void> _loadUserDetails() async {
    final ref = FirebaseDatabase.instance.ref(
      "healthcare/users/${widget.userKey}",
    );

    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;

      setState(() {
        userName = "${data['first_name']} ${data['last_name']}";
        isLoading = false;
      });
    } else {
      setState(() {
        userName = "Unknown User";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isWeb = AppResponsive.isDesktop(context);

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      key: _key,
      backgroundColor: const Color(0xFFF5F7FB),

      // MOBILE NAVBAR
      appBar: !isWeb
          ? PreferredSize(
              preferredSize: Size.fromHeight(AppResponsive.navbarHeight),
              child: SafeArea(
                child: PerfectNavbar(
                  onMenuPressed: () => _key.currentState?.openDrawer(),
                ),
              ),
            )
          : null,

      // MOBILE DRAWER
      drawer: !isWeb
          ? Drawer(
              child: PerfectSidebar(
                collapsed: false,
                items: sidebarItems,
                activeItem: activeItem,
                onTap: (item) {
                  setState(() => activeItem = item);
                  Navigator.pop(context);
                },
                userName: userName,
                userRole: widget.userRole,
              ),
            )
          : null,

      // WEB LAYOUT
      body: Row(
        children: [
          if (isWeb)
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: isCollapsed
                    ? AppResponsive.sidebarCollapsed
                    : AppResponsive.sidebarExpanded,
                maxWidth: isCollapsed
                    ? AppResponsive.sidebarCollapsed
                    : AppResponsive.sidebarExpanded,
              ),
              child: PerfectSidebar(
                collapsed: isCollapsed,
                items: sidebarItems,
                activeItem: activeItem,
                onTap: (item) {
                  setState(() => activeItem = item);
                },
                userName: userName,
                userRole: widget.userRole,
              ),
            ),

          Expanded(
            child: Column(
              children: [
                if (isWeb)
                  PerfectNavbar(
                    onMenuPressed: () =>
                        setState(() => isCollapsed = !isCollapsed),
                  ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: AppResponsive.pagePadding(context),
                    child:
                        activeItem?.page ??
                        const Center(
                          child: Text(
                            "No page selected",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
