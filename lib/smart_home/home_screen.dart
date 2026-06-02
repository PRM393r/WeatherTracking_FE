import 'package:flutter/material.dart';
import 'theme.dart';
import 'custom_bottom_bar.dart';
import 'air_conditioner_screen.dart';
import 'smart_lamp_screen.dart';
import '../features/auth/screens/login_screen.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SmartHomeTheme.backgroundColor,
      body: Stack(
        children: [
          // 1. Semi-transparent Network/Constellation Pattern at the top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 350,
            child: CustomPaint(
              painter: _NetworkPatternPainter(),
            ),
          ),
          
          // Main Content
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const HomeHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          _buildRoutinesCard(),
                          const SizedBox(height: 30),
                          _buildRoomTabsHeader(),
                          const SizedBox(height: 15),
                          _buildRoomTabs(),
                          const SizedBox(height: 25),
                          _buildDevicesGrid(context),
                          // Padding khổng lồ dưới cùng để không bị che bởi BottomNav lượn sóng
                          const SizedBox(height: 130), 
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Custom Bottom Navigation Bar
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

  // --- Sub-widgets ---



  Widget _buildRoutinesCard() {
    return Container(
      width: double.infinity,
      height: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, SmartHomeTheme.secondaryColor.withValues(alpha: 0.6)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: SmartHomeTheme.borderRadiusStandard,
        boxShadow: const [SmartHomeTheme.softShadow],
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildRoutineItem(Icons.wb_twilight_rounded, "Morning\nRoutine", false),
                _buildRoutineItem(Icons.nights_stay_rounded, "Night\nComfort", false),
                _buildRoutineItem(Icons.movie_filter_rounded, "Movie\nNight", true),
              ],
            ),
          ),
          const SizedBox(height: 15),
          // 3-dot indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDot(false),
              const SizedBox(width: 6),
              _buildDot(true),
              const SizedBox(width: 6),
              _buildDot(false),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRoutineItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            color: isActive ? SmartHomeTheme.primaryAccent : Colors.transparent,
            shape: BoxShape.circle,
            boxShadow: isActive ? const [SmartHomeTheme.softShadow] : [],
            border: isActive ? null : Border.all(color: Colors.grey.shade300, width: 1.5),
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.white : SmartHomeTheme.primaryAccent,
            size: 26,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: SmartHomeTheme.primaryAccent,
          ),
        ),
      ],
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      width: isActive ? 20 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? SmartHomeTheme.primaryAccent : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildRoomTabsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text(
              "Connected Devices",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: SmartHomeTheme.primaryAccent),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(8)),
              child: const Text("06", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            )
          ],
        ),
        Row(
          children: const [
            Text("View all", style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.w500)),
            SizedBox(width: 4),
            Icon(Icons.arrow_forward_ios_rounded, size: 10, color: Colors.blue),
          ],
        )
      ],
    );
  }

  Widget _buildRoomTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none, // Để hiện Soft Shadow
      child: Row(
        children: [
          _buildRoomTab("Living Room", Icons.chair_rounded, true),
          const SizedBox(width: 15),
          _buildRoomTab("Kitchen", Icons.kitchen_rounded, false),
          const SizedBox(width: 15),
          _buildRoomTab("Bedroom", Icons.bed_rounded, false),
        ],
      ),
    );
  }

  Widget _buildRoomTab(String label, IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isActive ? const [SmartHomeTheme.softShadow] : [],
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: isActive ? Colors.orange.shade300 : Colors.grey.shade500),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? SmartHomeTheme.primaryAccent : Colors.grey.shade500,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDevicesGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true, // Quan trọng khi nằm trong ScrollView
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 0.85,
      children: [
        _buildActiveAirConCard(context),
        _buildInactiveLampCard(context),
      ],
    );
  }

  Widget _buildActiveAirConCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AirConditionerScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: SmartHomeTheme.primaryAccent, // Deep Navy Blue
          borderRadius: SmartHomeTheme.borderRadiusStandard,
          boxShadow: const [SmartHomeTheme.softShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.air_rounded, color: Colors.white, size: 26),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.cyan.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Turbo",
                    style: TextStyle(color: Colors.cyanAccent, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const Spacer(),
            const Text(
              "Apple\nAir Conditioner",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, height: 1.3),
            ),
            const SizedBox(height: 4),
            Text(
              "Seetha - Bedroom",
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 10),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "014",
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, height: 1.0),
                ),
                Text(
                  " °C",
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Dãy quạt gió mô phỏng Fan speed
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) => Icon(
                Icons.cyclone_rounded, 
                color: index < 3 ? Colors.cyanAccent : Colors.white.withValues(alpha: 0.2),
                size: 16,
              )),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInactiveLampCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SmartLampScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: SmartHomeTheme.borderRadiusStandard,
          boxShadow: const [SmartHomeTheme.softShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.lightbulb_outline_rounded, color: Colors.grey, size: 26),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Low Temp",
                    style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const Spacer(),
            const Text(
              "PHILO\nBed Lamp",
              style: TextStyle(color: SmartHomeTheme.primaryAccent, fontWeight: FontWeight.bold, fontSize: 13, height: 1.3),
            ),
            const SizedBox(height: 4),
            Text(
              "Seetha - Bedroom",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "2700",
                  style: TextStyle(color: SmartHomeTheme.primaryAccent, fontSize: 20, fontWeight: FontWeight.bold, height: 1.1),
                ),
                Text(
                  " K",
                  style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Custom Mini Horizontal Slider
            Container(
              height: 6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 4, // 40% slider
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.orangeAccent, Colors.yellow],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6, // 60% empty
                    child: Container(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Custom Painter cho background mạng lưới/tinh tú (network/constellation)
class _NetworkPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = SmartHomeTheme.primaryAccent.withValues(alpha: 0.15) // Tăng độ sáng (từ 0.04 lên 0.15)
      ..strokeWidth = 1.0;
    
    // Vẽ đại diện một số điểm và đường nối mờ nhạt
    final p1 = Offset(size.width * 0.1, size.height * 0.3);
    final p2 = Offset(size.width * 0.3, size.height * 0.6);
    final p3 = Offset(size.width * 0.8, size.height * 0.4);
    final p4 = Offset(size.width * 0.9, size.height * 0.8);
    final p5 = Offset(size.width * 0.6, size.height * 0.2);
    
    canvas.drawLine(p1, p2, paint);
    canvas.drawLine(p2, p3, paint);
    canvas.drawLine(p3, p4, paint);
    canvas.drawLine(p5, p3, paint);
    canvas.drawLine(p1, p5, paint);
    
    canvas.drawCircle(p1, 3, paint);
    canvas.drawCircle(p2, 4, paint);
    canvas.drawCircle(p3, 3, paint);
    canvas.drawCircle(p4, 5, paint);
    canvas.drawCircle(p5, 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Weather & Energy Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: SmartHomeTheme.borderRadiusLarge,
                boxShadow: const [SmartHomeTheme.softShadow],
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Weather Section
                    Row(
                      children: [
                        const Icon(Icons.wb_sunny_rounded, color: Colors.orangeAccent, size: 28),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Sunday, 15 Feb 2026", style: TextStyle(fontSize: 9, color: Colors.grey)),
                            Text("14°C & Sunny", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: SmartHomeTheme.primaryAccent)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Container(width: 1, height: 28, color: Colors.grey.shade200),
                    const SizedBox(width: 12),
                    // Energy Section
                    Row(
                      children: [
                        const Icon(Icons.eco_rounded, color: Colors.green, size: 28), // Leaf/Eco Icon
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Energy", style: TextStyle(fontSize: 9, color: Colors.grey)),
                            Text("60Kwh", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: SmartHomeTheme.primaryAccent)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          // Notification Bell
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [SmartHomeTheme.softShadow],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none_rounded, color: SmartHomeTheme.primaryAccent, size: 26),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                    child: const Text(
                      "06", 
                      style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Account/Profile Button
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x10000000),
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.person_outline, color: Color(0xFF0A3F5C), size: 26),
            ),
          ),
        ],
      ),
    );
  }
}
