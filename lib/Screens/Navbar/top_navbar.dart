
import 'package:flutter/material.dart';
import '../../utils/app_responsive.dart';
import './notification_dropdown.dart'; // Make sure this file exists

class PerfectNavbar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;

  const PerfectNavbar({
    super.key,
    required this.onMenuPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  State<PerfectNavbar> createState() => _PerfectNavbarState();
}

class _PerfectNavbarState extends State<PerfectNavbar> {
  // ---------------------------------------------------------
  // 1. LANGUAGE MENU STATE
  // ---------------------------------------------------------
  Map<String, String> selectedLang = {"name": "English", "code": "EN"};
  bool _isLangMenuOpen = false; // Renamed for clarity

  final List<Map<String, String>> languages = [
    {"name": "English", "code": "EN"},
    {"name": "हिंदी", "code": "HI"},
    {"name": "मराठी", "code": "MR"},
    {"name": "বাংলা", "code": "BN"},
    {"name": "తెలుగు", "code": "TE"},
    {"name": "தமிழ்", "code": "TA"},
    {"name": "ગુજરાતી", "code": "GU"},
    {"name": "ಕನ್ನಡ", "code": "KN"},
    {"name": "മലയാളം", "code": "ML"},
    {"name": "ਪੰਜਾਬੀ", "code": "PA"},
  ];

  // ---------------------------------------------------------
  // 2. NOTIFICATION OVERLAY STATE & LOGIC
  // ---------------------------------------------------------
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isNotificationOpen = false;

  void _toggleNotification() {
    if (_isNotificationOpen) {
      _closeNotification();
    } else {
      _showNotification();
    }
  }

  void _showNotification() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Transparent detector to close when clicking outside
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeNotification,
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
          // The Dropdown positioned relative to the Bell Icon
          Positioned(
            width: 320, // Width of the notification box
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              // Adjust this offset to align the box perfectly
              // X: -280 moves it left to align with the bell
              // Y: 50 moves it down below the navbar
              offset: const Offset(-280, 50), 
              child: const NotificationDropdown(),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isNotificationOpen = true);
  }

  void _closeNotification() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isNotificationOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final bool isWeb = AppResponsive.isDesktop(context);

    return Container(
      height: widget.preferredSize.height,
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
          // ----------------------------------------------------
          // SIDEBAR MENU BUTTON
          // ----------------------------------------------------
          IconButton(
            onPressed: widget.onMenuPressed,
            icon: const Icon(Icons.menu, size: 26),
            color: Colors.black87,
          ),

          const SizedBox(width: 15),

          // ----------------------------------------------------
          // SEARCH BAR
          // ----------------------------------------------------
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

          // ----------------------------------------------------
          // 🌐 LANGUAGE DROPDOWN
          // ----------------------------------------------------
          PopupMenuButton<Map<String, String>>(
            offset: const Offset(0, 55),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onOpened: () => setState(() => _isLangMenuOpen = true),
            onCanceled: () => setState(() => _isLangMenuOpen = false),
            onSelected: (value) {
              setState(() {
                selectedLang = value;
                _isLangMenuOpen = false;
              });
            },
            child: Row(
              children: [
                const Icon(Icons.language, size: 22, color: Colors.black87),
                const SizedBox(width: 6),
                Text(
                  isWeb ? selectedLang['name']! : selectedLang['code']!,
                  style: TextStyle(
                    fontSize: AppResponsive.fontSM(context),
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Icon(
                  _isLangMenuOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 20,
                ),
              ],
            ),
            itemBuilder: (context) => languages.map((lang) {
              final bool isSelected = lang['name'] == selectedLang['name'];
              return PopupMenuItem<Map<String, String>>(
                value: lang,
                child: Row(
                  children: [
                    Icon(
                      Icons.flag,
                      size: 16,
                      color: isSelected ? Colors.blue : Colors.grey[700],
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "${lang['name']} (${lang['code']})",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.blue : Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(width: 20),

          // ----------------------------------------------------
          // PATIENT BADGE (Web only)
          // ----------------------------------------------------
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

          // ----------------------------------------------------
          // 🔔 NOTIFICATION BELL (With Overlay Logic)
          // ----------------------------------------------------
          CompositedTransformTarget(
            link: _layerLink, // This links the popup to this specific icon location
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: _toggleNotification, 
                  icon: Icon(
                    _isNotificationOpen ? Icons.notifications : Icons.notifications_none,
                    color: _isNotificationOpen ? Colors.blue : Colors.black87,
                  ),
                ),
                // Only show red badge if notification box is CLOSED
                if (!_isNotificationOpen)
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
          ),
        ],
      ),
    );
  }
}