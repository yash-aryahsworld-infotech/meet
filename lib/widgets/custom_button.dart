import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.numpadEnter): const ActivateIntent(),
      },

      child: Actions(
        actions: {
          ActivateIntent: CallbackAction(
            onInvoke: (intent) {
              onPressed();
              return null;
            },
          ),
        },

        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2196F3),
                  Color(0xFF1565C0),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),

            child: ElevatedButton(
              onPressed: onPressed,
              style: ButtonStyle(
                elevation: WidgetStatePropertyAll(0),
                backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
                shadowColor: const WidgetStatePropertyAll(Colors.transparent),
                overlayColor: const WidgetStatePropertyAll(
                  Color.fromRGBO(255, 255, 255, 0.1),
                ),
              ),

              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
