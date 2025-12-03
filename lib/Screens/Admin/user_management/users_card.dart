import 'package:flutter/material.dart';
// File: lib/models/user_model.dart

class UserModel {
  final String name;
  final String email;
  final String role; // Admin, Provider, Patient, Corporate
  final String status; // Active, Inactive
  final bool isVerified;
  final String location;
  final String joinedDate;
  final String? extraInfo;

  UserModel({
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    this.isVerified = false,
    required this.location,
    required this.joinedDate,
    this.extraInfo,
  });
}

class UserListTable extends StatelessWidget {
  final List<UserModel> users;

  const UserListTable({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Text("No users found", style: TextStyle(color: Colors.grey[600])),
        ),
      );
    }

    return Card(
      color: Colors.white, // <--- ADDED: Sets the background to White
      surfaceTintColor: Colors.white, // <--- ADDED: Ensures no tint in Material 3
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: users.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade200),
        itemBuilder: (context, index) {
          final user = users[index];
          
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Avatar
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey.shade100,
                  child: Text(
                    _getInitials(user.name),
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // 2. Main Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Top Row: Name + Badges ---
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8.0, // Horizontal gap
                        runSpacing: 8.0, // Vertical gap if it wraps
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          _buildRoleBadge(user.role),
                          _buildStatusBadge(user.status),
                          if (user.isVerified) _buildVerifiedBadge(),
                        ],
                      ),
                      
                      const SizedBox(height: 8),

                      // --- Middle Row: Metadata (Email, Location, Date) ---
                      Wrap(
                        spacing: 16.0, 
                        runSpacing: 6.0,
                        children: [
                          _buildIconText(Icons.email_outlined, user.email),
                          _buildIconText(Icons.location_on_outlined, user.location),
                          _buildIconText(Icons.calendar_today_outlined, "Joined ${user.joinedDate}"),
                        ],
                      ),

                      // --- Bottom Row: Extra Info (Optional) ---
                      if (user.extraInfo != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          user.extraInfo!,
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ]
                    ],
                  ),
                ),

                // 3. View Details Button
                Container(
                  margin: const EdgeInsets.only(left: 16),
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: const Text("View Details"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- Helper: Initials Generator ---
  String _getInitials(String name) {
    if (name.isEmpty) return "?";
    List<String> names = name.split(" ");
    String initials = "";
    if (names.isNotEmpty) initials += names[0][0];
    if (names.length > 1) initials += names[names.length - 1][0];
    return initials.toUpperCase();
  }

  // --- Helper: Icon + Text (Grey style) ---
  Widget _buildIconText(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // --- Helper: Role Badge ---
  Widget _buildRoleBadge(String role) {
    Color bg;
    Color text;
    IconData icon;

    switch (role.toLowerCase()) {
      case 'admin':
        bg = const Color(0xFFF3E5F5); 
        text = const Color(0xFF9C27B0); 
        icon = Icons.admin_panel_settings_outlined;
        break;
      case 'provider':
        bg = const Color(0xFFE3F2FD); 
        text = const Color(0xFF1976D2); 
        icon = Icons.person_outline;
        break;
      case 'patient':
        bg = const Color(0xFFE8F5E9); 
        text = const Color(0xFF388E3C); 
        icon = Icons.person;
        break;
      case 'corporate':
        bg = const Color(0xFFFFF3E0); 
        text = const Color(0xFFE65100); 
        icon = Icons.business;
        break;
      default:
        bg = Colors.grey.shade100;
        text = Colors.grey.shade700;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: text),
          const SizedBox(width: 4),
          Text(role, style: TextStyle(color: text, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // --- Helper: Status Badge ---
  Widget _buildStatusBadge(String status) {
    bool isActive = status.toLowerCase() == 'active';
    Color bg = isActive ? const Color(0xFFE8F5E9) : Colors.grey.shade100;
    Color text = isActive ? Colors.green.shade700 : Colors.grey.shade700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20), 
      ),
      child: Text(
        status,
        style: TextStyle(
          color: text,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // --- Helper: Verified Badge ---
  Widget _buildVerifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "Verified",
        style: TextStyle(color: Colors.grey.shade700, fontSize: 11),
      ),
    );
  }
}