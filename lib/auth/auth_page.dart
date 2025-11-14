import 'package:flutter/material.dart';
import 'signin_page.dart';
import 'signup_page.dart';
import '../widgets/custom_toggle_switch.dart';
import '../utils/responsive.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  int selectedIndex = 0; // 0 = Sign In, 1 = Sign Up

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: responsive.defaultPadding,
            vertical: responsive.defaultPadding * 1.5,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (responsive.isDesktop) {
                // 🖥 Web/Desktop layout
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Left side panel / illustration area
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.health_and_safety,
                              size: 100,
                              color: Colors.blueAccent,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Your Health, Our Priority",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Access comprehensive healthcare services\nand manage your health journey effortlessly.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Right side login/signup card
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: _buildAuthCard(responsive),
                      ),
                    ),
                  ],
                );
              } else if (responsive.isTablet) {
                // 💻 Tablet layout
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: _buildAuthCard(responsive),
                  ),
                );
              } else {
                // 📱 Mobile layout
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: _buildAuthCard(responsive),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  // 🔹 Extracted reusable auth card builder
  Widget _buildAuthCard(Responsive responsive) {
    return Container(
      padding: EdgeInsets.all(responsive.isDesktop ? 40 : 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Welcome to HealthCare Platform",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: responsive.scale(20),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Access comprehensive healthcare services\nand manage your health journey",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: responsive.scale(13),
            ),
          ),
          const SizedBox(height: 30),

          // 🔹 Reusable toggle
          CustomToggleSwitch(
            options: const ["Sign In", "Sign Up"],
            selectedIndex: selectedIndex,
            onSelected: (index) {
              setState(() => selectedIndex = index);
            },
          ),

          const SizedBox(height: 30),

          // 🔹 Animated form switcher
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: selectedIndex == 0
              ? const SignInForm(key: ValueKey('signIn'))
              : SignUpForm(
            key: const ValueKey('signUp'),g
            onSwitchToSignIn: () {
              setState(() => selectedIndex = 0); // switch tab
            },
          ),

          ),
        ],
      ),
    );
  }
}
