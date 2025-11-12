import 'package:flutter/material.dart';
import 'package:healthcare_plus/auth/signin_page.dart';
import 'package:healthcare_plus/auth/signup_page.dart';

class AuthToggle extends StatelessWidget {
  final bool isSignInPage; // true = Sign In selected, false = Sign Up selected

  const AuthToggle({super.key, required this.isSignInPage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB), // light grey background
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _tabButton(
            context,
            "Sign In",
            isSignInPage,
                () {
              if (!isSignInPage) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              }
            },
          ),
          _tabButton(
            context,
            "Sign Up",
            !isSignInPage,
                () {
              if (isSignInPage) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _tabButton(
      BuildContext context,
      String text,
      bool selected,
      VoidCallback onTap,
      ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? Colors.blue : Colors.transparent,
              width: 3,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.black : Colors.grey.shade600,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
