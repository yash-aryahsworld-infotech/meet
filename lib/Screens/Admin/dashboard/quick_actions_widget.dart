import 'package:flutter/material.dart';

// --- DATA MODEL ---
class QuickActionItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  QuickActionItem(this.label, this.icon, this.onTap);
}

// --- WIDGET ---
class QuickActionsWidget extends StatelessWidget {
  final List<QuickActionItem> actions;

  const QuickActionsWidget({Key? key, required this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: actions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final action = actions[index];
                return OutlinedButton(
                  onPressed: action.onTap,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    alignment: Alignment.centerLeft,
                    foregroundColor: Colors.black87,
                  ),
                  child: Row(
                    children: [
                      Icon(action.icon, size: 20, color: Colors.grey.shade700),
                      const SizedBox(width: 12),
                      Text(
                        action.label,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}