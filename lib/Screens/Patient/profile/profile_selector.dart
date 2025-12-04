import 'package:flutter/material.dart';

class ProfileSelector extends StatelessWidget {
  final Map<String, dynamic>? mainUser;
  final List<Map<String, dynamic>> familyMembers;
  
  // This variable determines which circle gets the Green Border
  final String? selectedKey; 
  
  final Function(String?) onSelect;
  final VoidCallback onAddFamily;

  const ProfileSelector({
    super.key,
    required this.mainUser,
    required this.familyMembers,
    required this.selectedKey, // <--- This is what keeps it "Chosen"
    required this.onSelect,
    required this.onAddFamily,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView(
        // Key added here: Ensures scroll position stays put when screen updates
        key: const PageStorageKey('profile_selector_list'), 
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // 1. Main User Avatar
          _buildAvatarItem(
            name: mainUser?['first_name'] ?? "Me",
            // If selectedKey is null, "Me" is selected
            isSelected: selectedKey == null, 
            onTap: () => onSelect(null),
            isMain: true,
          ),

          // 2. Family Members
          ...familyMembers.map((member) {
            return _buildAvatarItem(
              name: member['name'] ?? "Fam",
              // If selectedKey matches this member's ID, they are selected
              isSelected: selectedKey == member['key'], 
              onTap: () => onSelect(member['key']),
              isMain: false,
            );
          }),

          // 3. Add Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: onAddFamily,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[200],
                    child: const Icon(Icons.add, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 8),
                const Text("Add New", style: TextStyle(fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }

 Widget _buildAvatarItem({
    required String name, 
    required bool isSelected, 
    required VoidCallback onTap, 
    required bool isMain
  }) {
    // 1. URL Encode the name to handle spaces (e.g. "John Doe" -> "John%20Doe")
    final String safeName = Uri.encodeComponent(name);
    
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: isSelected 
                    ? Border.all(color: Colors.teal, width: 3) 
                    : Border.all(color: Colors.transparent, width: 3),
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: isMain ? Colors.teal[100] : Colors.orange[100],
                // 2. Add Text Child as a fallback if image fails to load
                child: Text(
                  isMain ? "Me" : name.isNotEmpty ? name[0].toUpperCase() : "?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isMain ? Colors.teal[900] : Colors.orange[900],
                  ),
                ),
                // 3. Load Image over the text
                foregroundImage: NetworkImage(
                  "https://ui-avatars.com/api/?name=$safeName&background=random&size=128",
                ),
                // This handler prevents crashes if the image fails
                onForegroundImageError: (_, __) {
                  debugPrint("Could not load avatar for $name");
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isMain ? "Me" : name.split(" ")[0],
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.teal : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}