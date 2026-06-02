import 'dart:ui';
import 'package:flutter/material.dart';
import 'night_sky_background.dart';

class SavedCitiesScreen extends StatefulWidget {
  const SavedCitiesScreen({super.key});

  @override
  State<SavedCitiesScreen> createState() => _SavedCitiesScreenState();
}

class _SavedCitiesScreenState extends State<SavedCitiesScreen> {
  // Dummy data representing saved cities
  final List<Map<String, dynamic>> _savedCities = [
    {
      "city": "Da Nang",
      "time": "10:30 AM",
      "temperature": "28°C",
      "weatherIcon": Icons.wb_sunny_rounded,
      "iconColor": const Color(0xFFFFCA28),
    },
    {
      "city": "Tokyo",
      "time": "12:30 PM",
      "temperature": "15°C",
      "weatherIcon": Icons.cloud_rounded,
      "iconColor": const Color(0xFF90CAF9),
    },
    {
      "city": "London",
      "time": "03:30 AM",
      "temperature": "8°C",
      "weatherIcon": Icons.umbrella_rounded,
      "iconColor": const Color(0xFFB0BEC5),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF041C2C), // Nền tối matching bầu trời đêm
      body: Stack(
        children: [
          // Backgrounds to make Glassmorphism pop!
          const NightSkyBackground(),
          
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAppBar(context),
                
                // Tiêu đề & Thanh tìm kiếm
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Thời tiết",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: Colors.white, // Chuyển sang trắng để nổi bật trên nền đêm
                          letterSpacing: -1,
                        ),
                      ),
                      SizedBox(height: 20),
                      GlassSearchBar(),
                    ],
                  ),
                ),
                
                const SizedBox(height: 10),
                
                // Danh sách thành phố đã lưu
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                    itemCount: _savedCities.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final data = _savedCities[index];
                      return SavedCityCard(
                        city: data['city'],
                        time: data['time'],
                        temperature: data['temperature'],
                        weatherIcon: data['weatherIcon'],
                        iconColor: data['iconColor'],
                        onDismissed: () {
                          setState(() {
                            _savedCities.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${data['city']} removed"),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
            onPressed: () {
              // TODO: Navigate to Add City Screen or Focus Search
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// UI COMPONENTS - MODULAR & REUSABLE (NO AI SLOP)
// ---------------------------------------------------------

class GlassSearchBar extends StatefulWidget {
  const GlassSearchBar({super.key});

  @override
  State<GlassSearchBar> createState() => _GlassSearchBarState();
}

class _GlassSearchBarState extends State<GlassSearchBar> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15), // Kính tối màu
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3), // Viền sáng nhẹ
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: _controller,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              hintText: "Tìm tên thành phố...",
              hintStyle: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontWeight: FontWeight.w600,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: Colors.white,
              ),
              suffixIcon: _hasText
                  ? IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _controller.clear();
                      },
                    )
                  : const SizedBox.shrink(),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            ),
          ),
        ),
      ),
    );
  }
}

class SavedCityCard extends StatelessWidget {
  final String city;
  final String time;
  final String temperature;
  final IconData weatherIcon;
  final Color iconColor;
  final VoidCallback onDismissed;

  const SavedCityCard({
    super.key,
    required this.city,
    required this.time,
    required this.temperature,
    required this.weatherIcon,
    required this.iconColor,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(city),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismissed(),
      background: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFF5252).withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.only(right: 24),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 32,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15), // Kính tối màu
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3), // Viền sáng nhẹ
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      city,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      weatherIcon,
                      color: iconColor,
                      size: 40,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      temperature,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
