import 'dart:math';
import 'package:flutter/material.dart';
import 'theme.dart';

class AirConditionerScreen extends StatefulWidget {
  const AirConditionerScreen({super.key});

  @override
  State<AirConditionerScreen> createState() => _AirConditionerScreenState();
}

class _AirConditionerScreenState extends State<AirConditionerScreen> {
  double _currentTemp = 24.0;

  void _updateTemp(DragUpdateDetails details) {
    setState(() {
      // Vuốt ngang để thay đổi nhiệt độ cho đơn giản (có thể nâng cấp thành tính toán góc)
      _currentTemp += details.delta.dx * 0.08;
      if (_currentTemp < 10) _currentTemp = 10;
      if (_currentTemp > 30) _currentTemp = 30;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SmartHomeTheme.backgroundColor,
      body: SafeArea(
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
                const SizedBox(height: 30),
                _buildCircularDial(),
                const SizedBox(height: 30),
                _buildModeSelector(),
                const SizedBox(height: 30),
                _buildBottomActions(),
                const SizedBox(height: 40), // Padding đáy
              ],
            ),
          ),
        ),
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
          "Air Conditioner",
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
      onPanUpdate: _updateTemp,
      child: Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: SmartHomeTheme.backgroundColor,
          boxShadow: [
            // Hiệu ứng Neumorphism cho vòng quay
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
          painter: _DialPainter(
            percentage: (_currentTemp - 10) / 20, // 10 -> 30 độ
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentTemp.toInt().toString(),
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: SmartHomeTheme.primaryAccent,
                        height: 1.0,
                      ),
                    ),
                    const Text(
                      "°C",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                  "Cooler",
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

  Widget _buildModeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActiveModeButton(Icons.ac_unit_rounded, "Cooling"),
        _buildInactiveModeButton(Icons.air_rounded),
        _buildInactiveModeButton(Icons.wb_sunny_rounded),
        _buildInactiveModeButton(Icons.eco_rounded),
      ],
    );
  }

  Widget _buildActiveModeButton(IconData icon, String label) {
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
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInactiveModeButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [SmartHomeTheme.softShadow],
      ),
      child: Icon(icon, color: Colors.grey, size: 22),
    );
  }

  Widget _buildBottomActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionCard(
          icon: Icons.timer_outlined,
          title: "8 Hours",
          subtitle: "Timer",
          isActive: true,
        ),
        _buildActionCard(
          icon: Icons.dashboard_customize_outlined,
          title: "Scenes",
          subtitle: "Morning",
          isActive: false,
        ),
        _buildActionCard(
          icon: Icons.sync_rounded,
          title: "Swing",
          subtitle: "Auto",
          isActive: false,
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isActive,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive ? SmartHomeTheme.primaryAccent : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [SmartHomeTheme.softShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : SmartHomeTheme.primaryAccent,
              size: 32,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : SmartHomeTheme.primaryAccent,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: isActive ? Colors.white.withValues(alpha: 0.7) : Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialPainter extends CustomPainter {
  final double percentage;

  _DialPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 25;

    // --- 1. Draw Tick Marks ---
    final tickPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final activeTickPaint = Paint()
      ..color = SmartHomeTheme.primaryAccent
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const int totalTicks = 40;
    const double startAngle = 135 * (pi / 180);
    const double sweepAngle = 270 * (pi / 180);
    const double anglePerTick = sweepAngle / totalTicks;

    for (int i = 0; i <= totalTicks; i++) {
      final double currentAngle = startAngle + (i * anglePerTick);
      final double innerRadius = radius + 10;
      final double outerRadius = i % 5 == 0 ? radius + 22 : radius + 16;

      final Offset innerPoint = Offset(
        center.dx + innerRadius * cos(currentAngle),
        center.dy + innerRadius * sin(currentAngle),
      );
      final Offset outerPoint = Offset(
        center.dx + outerRadius * cos(currentAngle),
        center.dy + outerRadius * sin(currentAngle),
      );

      bool isActiveTick = (i / totalTicks) <= percentage;
      canvas.drawLine(
          innerPoint, outerPoint, isActiveTick ? activeTickPaint : tickPaint);
    }

    // --- 2. Draw Track (Light Gray) ---
    final trackPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    final Rect arcRect = Rect.fromCircle(center: center, radius: radius - 15);
    canvas.drawArc(arcRect, startAngle, sweepAngle, false, trackPaint);

    // --- 3. Draw Progress Bar (Deep Navy Blue) ---
    final progressPaint = Paint()
      ..color = SmartHomeTheme.primaryAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(arcRect, startAngle, sweepAngle * percentage, false, progressPaint);

    // --- 4. Draw Knob ---
    final knobAngle = startAngle + (sweepAngle * percentage);
    final knobCenter = Offset(
      center.dx + (radius - 15) * cos(knobAngle),
      center.dy + (radius - 15) * sin(knobAngle),
    );

    final knobPaint = Paint()..color = Colors.white;
    final knobShadow = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    canvas.drawCircle(knobCenter, 14, knobShadow);
    canvas.drawCircle(knobCenter, 14, knobPaint);
    canvas.drawCircle(knobCenter, 5, Paint()..color = SmartHomeTheme.primaryAccent);
  }

  @override
  bool shouldRepaint(covariant _DialPainter oldDelegate) {
    return oldDelegate.percentage != percentage;
  }
}
