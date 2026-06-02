import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AuthTheme {
  static const Color backgroundColor = Color(0xFFF7F9FC);
  static const Color primaryAccent = Color(0xFF0A3F5C);
  static const Color hintColor = Color(0xFF8B9CB0);

  static const BoxShadow softShadow = BoxShadow(
    color: Color(0x10000000),
    blurRadius: 24,
    offset: Offset(0, 8),
  );

  static final BorderRadius borderRadius = BorderRadius.circular(24.0);
}

class SoftTextField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? controller;

  const SoftTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AuthTheme.borderRadius,
        boxShadow: const [AuthTheme.softShadow], // Giữ shadow nhẹ ở viền
      ),
      child: ClipRRect(
        borderRadius: AuthTheme.borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5), // Nền kính mờ
              borderRadius: AuthTheme.borderRadius,
              border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.2), // Viền sáng
            ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(
          color: AuthTheme.primaryAccent,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: AuthTheme.hintColor,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(prefixIcon, color: AuthTheme.primaryAccent),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
          ),
        ),
      ),
    );
  }
}

class AnimatedWeatherBackground extends StatelessWidget {
  const AnimatedWeatherBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Mặt trời sáng hơn (alpha 0.5 thay vì 0.15)
        Positioned(
          top: -30,
          right: -30,
          child: const Icon(
            Icons.wb_sunny_rounded,
            color: Color(0x80FFA726), // Đậm hơn
            size: 300,
          )
          .animate(onPlay: (controller) => controller.repeat())
          .rotate(duration: 40.seconds, curve: Curves.linear)
          .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 3.seconds, curve: Curves.easeInOut)
          .then()
          .scale(begin: const Offset(1.1, 1.1), end: const Offset(1, 1), duration: 3.seconds, curve: Curves.easeInOut),
        ),
        // Mây trắng rõ hơn
        Positioned(
          top: 80,
          left: -100,
          child: const Icon(
            Icons.cloud_rounded,
            color: Color(0x70FFFFFF), // Đậm hơn
            size: 150,
          )
          .animate(onPlay: (controller) => controller.repeat())
          .moveX(begin: 0, end: 500, duration: 30.seconds, curve: Curves.linear),
        ),
        // Mây xanh rõ hơn
        Positioned(
          top: 250,
          right: -150,
          child: const Icon(
            Icons.cloud_queue_rounded,
            color: Color(0x6081D4FA), // Đậm hơn
            size: 100,
          )
          .animate(onPlay: (controller) => controller.repeat())
          .moveX(begin: 0, end: -400, duration: 25.seconds, curve: Curves.linear),
        ),
      ],
    );
  }
}

class MountainSeaBackground extends StatefulWidget {
  const MountainSeaBackground({super.key});
  @override
  State<MountainSeaBackground> createState() => _MountainSeaBackgroundState();
}

class _MountainSeaBackgroundState extends State<MountainSeaBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 250, // Chiều cao của núi và biển
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _MountainSeaPainter(_controller.value),
          );
        },
      ),
    );
  }
}

class _MountainSeaPainter extends CustomPainter {
  final double wavePhase;
  _MountainSeaPainter(this.wavePhase);

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Mountains (Soft UI style)
    final mountainPaint1 = Paint()..color = const Color(0xFFE6EEF8); // Rất nhạt
    final mountainPaint2 = Paint()..color = const Color(0xFFD6E4F4);

    final pathM1 = Path()
      ..moveTo(-50, size.height)
      ..lineTo(size.width * 0.35, size.height - 130)
      ..lineTo(size.width * 0.75, size.height)
      ..close();
    canvas.drawPath(pathM1, mountainPaint1);

    final pathM2 = Path()
      ..moveTo(size.width * 0.15, size.height)
      ..lineTo(size.width * 0.7, size.height - 90)
      ..lineTo(size.width + 50, size.height)
      ..close();
    canvas.drawPath(pathM2, mountainPaint2);

    // 2. Draw Sea Waves (Animated)
    final wavePaint1 = Paint()..color = const Color(0x5081D4FA); // Lớp sóng mờ phía sau
    final wavePaint2 = Paint()..color = const Color(0x704FC3F7); // Lớp sóng giữa
    final wavePaint3 = Paint()..color = const Color(0xFF0A3F5C).withValues(alpha: 0.8); // Lớp sóng trước đậm màu primary

    void drawWave(Paint paint, double heightOffset, double amplitude, double frequency, double phaseShift) {
      final path = Path();
      path.moveTo(0, size.height);
      for (double x = 0; x <= size.width; x++) {
        double y = size.height - heightOffset + sin((x / size.width * pi * frequency) + (wavePhase * 2 * pi) + phaseShift) * amplitude;
        if (x == 0) {
          path.lineTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.lineTo(size.width, size.height);
      path.close();
      canvas.drawPath(path, paint);
    }

    drawWave(wavePaint1, 70, 12, 1.5, 0);
    drawWave(wavePaint2, 50, 10, 2.0, pi / 2);
    drawWave(wavePaint3, 20, 8, 2.5, pi);
  }

  @override
  bool shouldRepaint(covariant _MountainSeaPainter oldDelegate) {
    return oldDelegate.wavePhase != wavePhase;
  }
}

class LiquidGlassLogo extends StatelessWidget {
  const LiquidGlassLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x15000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          )
        ],
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.3),
              border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.5),
            ),
            child: Stack(
              children: [
                // Sun with glow
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Color(0x60FF9800), blurRadius: 10, spreadRadius: 1)
                      ],
                    ),
                    child: const Icon(Icons.wb_sunny_rounded, color: Color(0xFFFFB74D), size: 30),
                  ),
                ),
                // Glassy Cloud
                Positioned(
                  bottom: 12,
                  left: 10,
                  child: const Icon(
                    Icons.cloud_rounded, 
                    color: Colors.white, 
                    size: 38,
                    shadows: [
                      Shadow(color: Color(0x20000000), blurRadius: 8, offset: Offset(0, 4))
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
}

class PrimarySoftButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const PrimarySoftButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: AuthTheme.borderRadius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x400A3F5C), // Hào quang glow màu primary
            blurRadius: 16,
            offset: Offset(0, 8),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: AuthTheme.borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: AuthTheme.primaryAccent.withValues(alpha: 0.75), // Trong suốt nhẹ nhưng vẫn rực rỡ
              borderRadius: AuthTheme.borderRadius,
              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: AuthTheme.borderRadius,
                onTap: onPressed,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SocialAuthButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Widget icon;

  const SocialAuthButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: AuthTheme.borderRadius,
        boxShadow: const [AuthTheme.softShadow],
      ),
      child: ClipRRect(
        borderRadius: AuthTheme.borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6), // Nền kính mờ trắng
              borderRadius: AuthTheme.borderRadius,
              border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: AuthTheme.borderRadius,
                onTap: onPressed,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon,
                      const SizedBox(width: 12),
                      Text(
                        title,
                        style: const TextStyle(
                          color: AuthTheme.primaryAccent,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
