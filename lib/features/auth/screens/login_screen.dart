import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/auth_widgets.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _LoginHeader(),
                    const SizedBox(height: 24),
                    _buildForm(),
                    const SizedBox(height: 16),
                    _buildActions(),
                    const SizedBox(height: 24),
                    const _LoginFooter(),
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
      ],
    );
  }

  Widget _buildActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AuthTheme.primaryAccent,
            ),
            child: const Text(
              "Forgot Password?",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 16),
        PrimarySoftButton(
          title: "Sign In",
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
          title: "Continue with Google",
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

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LiquidGlassLogo(),
        const SizedBox(height: 16),
        const Text(
          "Welcome Back",
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
          "Sign in to check your weather",
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

class _LoginFooter extends StatelessWidget {
  const _LoginFooter();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(color: AuthTheme.hintColor, fontWeight: FontWeight.w500),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterScreen()),
            );
          },
          child: const Text(
            "Sign Up",
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
