import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/auth_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthTheme.backgroundColor,
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! > 10) {
            Navigator.pop(context);
          }
        },
        child: Stack(
          children: [
            const AnimatedWeatherBackground(),
            const MountainSeaBackground(),
            SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _RegisterHeader(),
                    const SizedBox(height: 24),
                    _buildForm(),
                    const SizedBox(height: 16),
                    _buildActions(),
                    const SizedBox(height: 24),
                    const _RegisterFooter(),
                  ].animate(interval: 100.ms).fade(duration: 500.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 16),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AuthTheme.primaryAccent),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        SoftTextField(
          controller: _nameController,
          hintText: 'Full Name',
          prefixIcon: Icons.person_outline_rounded,
        ),
        const SizedBox(height: 16),
        SoftTextField(
          controller: _emailController,
          hintText: 'Email',
          prefixIcon: Icons.mail_outline_rounded,
        ),
        const SizedBox(height: 16),
        SoftTextField(
          controller: _passwordController,
          hintText: 'Password',
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: AuthTheme.hintColor,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        SoftTextField(
          controller: _confirmPasswordController,
          hintText: 'Confirm Password',
          prefixIcon: Icons.lock_reset_rounded,
          obscureText: _obscureConfirmPassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: AuthTheme.hintColor,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimarySoftButton(
          title: "Sign Up",
          onPressed: () {},
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Expanded(child: Divider(color: Colors.black12)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Or",
                style: TextStyle(
                  color: AuthTheme.hintColor, 
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Expanded(child: Divider(color: Colors.black12)),
          ],
        ),
        const SizedBox(height: 24),
        SocialAuthButton(
          title: "Sign Up with Google",
          onPressed: () {},
          icon: Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg',
            height: 24,
            errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata_rounded, color: Colors.blue, size: 32),
          ),
        ),
      ],
    );
  }
}

class _RegisterHeader extends StatelessWidget {
  const _RegisterHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LiquidGlassLogo(),
        const SizedBox(height: 16),
        const Text(
          "Create Account",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AuthTheme.primaryAccent,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Join the community",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: AuthTheme.hintColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _RegisterFooter extends StatelessWidget {
  const _RegisterFooter();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: TextStyle(color: AuthTheme.hintColor, fontWeight: FontWeight.w500),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context); // typically pop back to login
          },
          child: const Text(
            "Sign In",
            style: TextStyle(
              color: AuthTheme.primaryAccent,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
