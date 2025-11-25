import 'package:flutter/material.dart';

class Security extends StatefulWidget {
  const Security({super.key});

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  // State variables for switches
  bool _is2FAEnabled = false;
  bool _isBiometricEnabled = false;

  // State variables for password fields
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  final TextEditingController _currentPassController =
      TextEditingController(text: "password123");
  final TextEditingController _newPassController = TextEditingController();

  @override
  void dispose() {
    _currentPassController.dispose();
    _newPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen width for responsive layout adjustments if needed
    // final isMobile = MediaQuery.of(context).size.width < 600;

    return Material(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Security Score Section
                _buildSectionContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(
                        icon: Icons.shield_outlined,
                        title: "Security Score",
                        subtitle: "Your overall account security rating",
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "75/100",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.green, // Match image green
                          height: 1.0,
                        ),
                      ),
                      const Text(
                        "Security Score",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 2. Two-Factor Authentication Section
                _buildSectionContainer(
                  child: Column(
                    children: [
                      _buildHeader(
                        icon: Icons.smartphone_outlined,
                        title: "Two-Factor Authentication",
                        subtitle: "Add an extra layer of security to your account",
                      ),
                      const SizedBox(height: 20),
                      _buildSwitchRow(
                        title: "Enable 2FA",
                        subtitle:
                            "Secure your account with SMS or authenticator app",
                        value: _is2FAEnabled,
                        onChanged: (val) => setState(() => _is2FAEnabled = val),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 3. Biometric Authentication Section
                _buildSectionContainer(
                  child: Column(
                    children: [
                      _buildHeader(
                        icon: Icons.fingerprint,
                        title: "Biometric Authentication",
                        subtitle:
                            "Use fingerprint or face recognition for quick access",
                      ),
                      const SizedBox(height: 20),
                      _buildSwitchRow(
                        title: "Enable Biometric Login",
                        subtitle: "Login with your fingerprint or face",
                        value: _isBiometricEnabled,
                        onChanged: (val) =>
                            setState(() => _isBiometricEnabled = val),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 4. Password Management Section
                _buildSectionContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(
                        icon: Icons.lock_outline, // Implicit in image structure
                        title: "Password Management",
                        subtitle: "Update your password and view strength indicators",
                        hideIcon: true, // Image doesn't clearly show an icon here
                      ),
                      const SizedBox(height: 24),
                      
                      // Current Password
                      _buildLabel("Current Password"),
                      const SizedBox(height: 8),
                      _buildPasswordField(
                        controller: _currentPassController,
                        obscureText: _obscureCurrentPassword,
                        onToggleVisibility: () => setState(() =>
                            _obscureCurrentPassword = !_obscureCurrentPassword),
                      ),

                      const SizedBox(height: 16),

                      // New Password
                      _buildLabel("New Password"),
                      const SizedBox(height: 8),
                      _buildPasswordField(
                        controller: _newPassController,
                        obscureText: _obscureNewPassword,
                        hintText: "Enter new password",
                        onToggleVisibility: () => setState(
                            () => _obscureNewPassword = !_obscureNewPassword),
                      ),

                      const SizedBox(height: 12),

                      // Password Strength Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Password Strength:",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "Weak",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Update Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            // Update password logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6), // Blue
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Update Password",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildSectionContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    bool hideIcon = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!hideIcon) ...[
          Icon(icon, size: 20, color: Colors.grey.shade700),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF3B82F6),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    String? hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6).withOpacity(0.5), // Very light grey/blue
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              size: 18,
              color: Colors.grey,
            ),
            onPressed: onToggleVisibility,
          ),
        ),
      ),
    );
  }
}