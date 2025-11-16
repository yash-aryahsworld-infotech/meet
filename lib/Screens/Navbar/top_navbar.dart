import 'package:flutter/material.dart';
import '../../utils/app_responsive.dart';

class PerfectNavbar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;

  const PerfectNavbar({
    super.key,
    required this.onMenuPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final bool isWeb = AppResponsive.isDesktop(context);

    return Container(
      height: preferredSize.height,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            offset: Offset(0, 2),
            color: Color(0x22000000),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 24 : 12),
      child: Row(
        children: [

          /// ----------------------------------------------------
          /// SIDEBAR MENU BUTTON (Always)
          /// ----------------------------------------------------
          IconButton(
            onPressed: onMenuPressed,
            icon: const Icon(Icons.menu, size: 26),
            color: Colors.black87,
          ),

          const SizedBox(width: 15),

          /// ----------------------------------------------------
          /// SEARCH BAR (Always)
          /// ----------------------------------------------------
          Expanded(
            flex: isWeb ? 4 : 6,
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9FB),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.grey.shade300),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey.shade600),
                  const SizedBox(width: 10),

                  /// CENTERED TEXT FIELD ★★★★★
                  const Expanded(
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: "Search...",
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          /// ----------------------------------------------------
          /// LANGUAGE ICON + TEXT
          /// ----------------------------------------------------
          Row(
            children: [
              const Icon(Icons.language, size: 22, color: Colors.black87),
              if (isWeb) ...[
                const SizedBox(width: 6),
                Text(
                  "GB English",
                  style: TextStyle(
                    fontSize: AppResponsive.fontSM(context),
                    fontWeight: AppResponsive.medium,
                  ),
                ),
              ]
            ],
          ),

          const SizedBox(width: 20),

          /// ----------------------------------------------------
          /// PATIENT BADGE (Web only)
          /// ----------------------------------------------------
          if (isWeb)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: [
                  const Icon(Icons.people, size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(
                    "Patient",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppResponsive.fontSM(context),
                    ),
                  ),
                ],
              ),
            ),

          if (isWeb) const SizedBox(width: 25),

          /// ----------------------------------------------------
          /// NOTIFICATION BELL
          /// ----------------------------------------------------
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none,
                  color: Colors.black87,
                ),
              ),

              /// Notification dot
              Positioned(
                right: 4,
                top: 4,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.red,
                  child: Text(
                    "2",
                    style: TextStyle(
                      fontSize: AppResponsive.fontXS(context),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
