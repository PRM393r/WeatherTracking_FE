import 'dart:math';
import 'package:flutter/material.dart';
import 'theme.dart';
import 'custom_bottom_bar.dart';

class SmartLampScreen extends StatefulWidget {
  const SmartLampScreen({super.key});

  @override
  State<SmartLampScreen> createState() => _SmartLampScreenState();
}

class _SmartLampScreenState extends State<SmartLampScreen> {
  double _intensity = 74.0;

  void _updateIntensity(DragUpdateDetails details) {
    setState(() {
      _intensity += details.delta.dx * 0.5;
      if (_intensity < 0) _intensity = 0;
      if (_intensity > 100) _intensity = 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SmartHomeTheme.backgroundColor,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    _buildHeader(context),
                    const SizedBox(height: 30),
                    _buildRoomTabs(),
                    const SizedBox(height: 40),
                    _buildCircularDial(),
                    const SizedBox(height: 20),
                    _buildScheduleBanner(),
                    const SizedBox(height: 40),
                    _buildModeSelector(),
                    const SizedBox(height: 130), // Padding đáy để tránh Bottom Nav
                  ],
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: _buildCircularButton(Icons.arrow_back_ios_new_rounded),
        ),
        const Text(
          "Smart Lamp",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: SmartHomeTheme.primaryAccent,
          ),
        ),
        _buildCircularButton(Icons.more_vert_rounded),
      ],
    );
  }

  Widget _buildCircularButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [SmartHomeTheme.softShadow],
      ),
      child: Icon(icon, color: SmartHomeTheme.primaryAccent, size: 20),
    );
  }

  Widget _buildRoomTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildRoomTab("Kitchen", false),
          const SizedBox(width: 15),
          _buildRoomTab("Living Room", true),
          const SizedBox(width: 15),
          _buildRoomTab("Bedroom", false),
        ],
      ),
    );
  }

  Widget _buildRoomTab(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isActive ? const [SmartHomeTheme.softShadow] : [],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          color: isActive ? SmartHomeTheme.primaryAccent : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildCircularDial() {
    return GestureDetector(
      onPanUpdate: _updateIntensity,
      child: Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: SmartHomeTheme.backgroundColor,
          boxShadow: [
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-10, -10),
              blurRadius: 20,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              offset: const Offset(10, 10),
              blurRadius: 20,
            ),
          ],
        ),
        child: CustomPaint(
          painter: _LampDialPainter(
            percentage: _intensity / 100,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${_intensity.toInt()}%",
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: SmartHomeTheme.primaryAccent,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Intensity",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [SmartHomeTheme.softShadow],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.access_time_rounded, color: Colors.orangeAccent, size: 18),
          SizedBox(width: 8),
          Text(
            "Set Automatic Schedule",
            style: TextStyle(
              color: SmartHomeTheme.primaryAccent,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 4),
          Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 18),
        ],
      ),
    );
  }

  Widget _buildModeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActiveModeButton("Warm"),
        _buildInactiveModeButton("Color"),
        _buildInactiveModeButton("Romantic"),
      ],
    );
  }

  Widget _buildActiveModeButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [SmartHomeTheme.primaryAccent, SmartHomeTheme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [SmartHomeTheme.softShadow],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildInactiveModeButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [SmartHomeTheme.softShadow],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _LampDialPainter extends CustomPainter {
  final double percentage;

  _LampDialPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 25;

    const double startAngle = 135 * (pi / 180);
    const double sweepAngle = 270 * (pi / 180);
    final Rect arcRect = Rect.fromCircle(center: center, radius: radius - 15);

    // --- 1. Draw Track (Light Gray) ---
    final bgTrackPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(arcRect, startAngle, sweepAngle, false, bgTrackPaint);

    // --- 2. Draw Progress Bar (Rainbow SweepGradient) ---
    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: const [
          Colors.red,
          Colors.orange,
          Colors.yellow,
          Colors.green,
          Colors.blue,
          Colors.purple,
          Colors.red,
        ],
        stops: const [0.0, 0.16, 0.33, 0.5, 0.66, 0.83, 1.0],
        transform: GradientRotation(startAngle - pi / 2),
      ).createShader(arcRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(arcRect, startAngle, sweepAngle * percentage, false, progressPaint);

    // --- 3. Draw Knob ---
    final knobAngle = startAngle + (sweepAngle * percentage);
    final knobCenter = Offset(
      center.dx + (radius - 15) * cos(knobAngle),
      center.dy + (radius - 15) * sin(knobAngle),
    );

    final knobPaint = Paint()..color = Colors.white;
    final knobShadow = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    canvas.drawCircle(knobCenter, 14, knobShadow);
    canvas.drawCircle(knobCenter, 14, knobPaint);
    canvas.drawCircle(knobCenter, 5, Paint()..color = SmartHomeTheme.primaryAccent);
  }

  @override
  bool shouldRepaint(covariant _LampDialPainter oldDelegate) {
    return oldDelegate.percentage != percentage;
  }
}
