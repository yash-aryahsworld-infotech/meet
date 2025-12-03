import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/auth_page.dart';
import '../../utils/app_responsive.dart';
import 'left_sidebar_values.dart';

class PerfectSidebar extends StatelessWidget {
  final List<SidebarItem> items;
  final SidebarItem? activeItem;
  final Function(SidebarItem) onTap;
  final bool collapsed;

  final String userName;
  final String userRole;

  const PerfectSidebar({
    super.key,
    required this.items,
    required this.activeItem,
    required this.onTap,
    this.collapsed = false,
    required this.userName,
    required this.userRole,
  });

  // --------------------------------------------------------
  // LOGOUT CONFIRMATION POPUP
  // --------------------------------------------------------
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to sign out?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text(
                "Sign Out",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.pop(context);

                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthPage()),
                      (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  // --------------------------------------------------------
  // MAIN BUILD
  // --------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        width: collapsed
            ? AppResponsive.sidebarCollapsed
            : AppResponsive.sidebarExpanded,
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 24),

            // --------------------------------------------------------
            // LOGO
            // --------------------------------------------------------
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: collapsed ? 0 : 20,
              ),
              child: Row(
                mainAxisAlignment:
                collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/logo/only_logo.png',
                    width: 50,
                    height: 50,
                  ),

                  if (!collapsed) ...[
                    const SizedBox(width: 10),
                    Text(
                      "HealthCare+",
                      style: TextStyle(
                        fontSize: AppResponsive.fontLG(context),
                        fontWeight: AppResponsive.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --------------------------------------------------------
            // SIDEBAR MENU ITEMS
            // --------------------------------------------------------
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final bool isActive = activeItem?.route == item.route;

                  return Tooltip(
                    message: collapsed ? item.title : "",
                    child: InkWell(
                      onTap: () => onTap(item),

                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: collapsed ? 0 : 15,
                        ),
                        decoration: BoxDecoration(
                          color:
                          isActive ? const Color(0xFF006DFF) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: collapsed
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                          children: [
                            Icon(
                              item.icon,
                              color: isActive ? Colors.white : Colors.grey[800],
                            ),

                            if (!collapsed) ...[
                              const SizedBox(width: 14),

                              Expanded(
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    color: isActive ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              if (item.notificationCount > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "${item.notificationCount}",
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

        if (userRole == "Admin")
          Padding(
            // Adds 16px space to the TOP and BOTTOM of this section
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Account Role",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),

                // Space between Label and Dropdown
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: "Admin",
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                      items: [
                        "Admin",
                        "Healthcare Provider",
                        "Patient",
                        "Corporate",
                      ].map((role) {
                        return DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      onChanged: (newRole) {
                        print("Role changed to: $userRole");
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
            
            // --------------------------------------------------------
            // PROFILE SECTION (DYNAMIC)
            // --------------------------------------------------------
            if (!collapsed)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.grey.shade300, width: 1)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        userName.isNotEmpty
                            ? userName[0].toUpperCase()
                            : "U",
                        style: const TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          userRole,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              
              

            // --------------------------------------------------------
            // LOGOUT BUTTON
            // --------------------------------------------------------
            if (!collapsed)
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () => _showLogoutDialog(context),
              ),

            if (collapsed)
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.red),
                onPressed: () => _showLogoutDialog(context),
              ),
          ],
        ),
      ),
    );
  }
}
