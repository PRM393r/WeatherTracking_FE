import 'dart:ui';
import 'package:flutter/material.dart';
import 'theme.dart';
import 'saved_cities_screen.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({super.key});

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  int _selectedIndex = 0; 

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    
    return SizedBox(
      height: 110,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // 1. Glassmorphism Wavy Background
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _BottomNavClipper(),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  height: 85,
                  width: size.width,
                  color: Colors.blue.shade900.withValues(alpha: 0.15), // Kính màu xanh dương
                ),
              ),
            ),
          ),
          
          // 2. Stroke & Shadow cho Wavy Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(size.width, 85),
              painter: _BottomNavBorderPainter(),
            ),
          ),
          
          // 3. Navigation Icons (Trái & Phải)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 85,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(context, Icons.home_rounded, 'Home', 0),
                  _buildNavItem(context, Icons.search_rounded, 'Search', 1),
                  SizedBox(width: size.width * 0.20), // Khoảng trống cho FAB ở giữa
                  _buildNavItem(context, Icons.bar_chart_rounded, 'Usage', 2),
                  _buildNavItem(context, Icons.settings_rounded, 'Settings', 3),
                ],
              ),
            ),
          ),
          
          // 4. Center Floating Action Button (FAB) (Glass)
          Positioned(
            bottom: 40,
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: SmartHomeTheme.primaryAccent.withValues(alpha: 0.8), // Glass primary
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1.5),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.qr_code_scanner_rounded, 
                      color: Colors.white, 
                      size: 28,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SavedCitiesScreen()),
          );
        } else {
          setState(() => _selectedIndex = index);
        }
      },
      child: SizedBox(
        width: 65,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? SmartHomeTheme.primaryAccent : Colors.grey.shade600, // Đậm hơn xíu để nhìn rõ trên kính mờ
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? SmartHomeTheme.primaryAccent : Colors.grey.shade600,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Logic tính toán Path lượn sóng
Path _getWavyPath(Size size) {
  Path path = Path();
  path.moveTo(0, 20);
  path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 15);
  path.quadraticBezierTo(size.width * 0.40, 22, size.width * 0.40, 30);
  path.arcToPoint(
    Offset(size.width * 0.60, 30),
    radius: const Radius.circular(35), 
    clockwise: false,
  );
  path.quadraticBezierTo(size.width * 0.60, 22, size.width * 0.65, 15);
  path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
  path.lineTo(size.width, size.height);
  path.lineTo(0, size.height);
  path.close();
  return path;
}

class _BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return _getWavyPath(size);
  }
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _BottomNavBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = _getWavyPath(size);
    
    // Draw outer glow/shadow
    canvas.drawShadow(path, SmartHomeTheme.primaryAccent.withValues(alpha: 0.15), 15, true);

    // Draw top border for glass effect
    Paint borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    // Create a path that only traces the top curvy edge, not the sides/bottom
    Path topEdge = Path();
    topEdge.moveTo(0, 20);
    topEdge.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 15);
    topEdge.quadraticBezierTo(size.width * 0.40, 22, size.width * 0.40, 30);
    topEdge.arcToPoint(
      Offset(size.width * 0.60, 30),
      radius: const Radius.circular(35), 
      clockwise: false,
    );
    topEdge.quadraticBezierTo(size.width * 0.60, 22, size.width * 0.65, 15);
    topEdge.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    
    canvas.drawPath(topEdge, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
