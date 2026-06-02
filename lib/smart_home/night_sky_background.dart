import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NightSkyBackground extends StatelessWidget {
  const NightSkyBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Nền chuyển sắc bầu trời đêm
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF041C2C), Color(0xFF0A3F5C)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // Mặt trăng tỏa sáng
        Positioned(
          top: 80,
          right: 40,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Color(0x60F6F1D5), blurRadius: 40, spreadRadius: 10)
              ],
            ),
            child: const Icon(
              Icons.nightlight_round,
              color: Color(0xFFF6F1D5),
              size: 100,
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 4.seconds, curve: Curves.easeInOut),
        ),
        // Các vì sao lấp lánh
        Positioned(
          top: 120,
          left: 80,
          child: const Icon(Icons.star_rounded, color: Colors.white, size: 16)
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .fade(begin: 0.2, end: 1.0, duration: 2.seconds),
        ),
        Positioned(
          top: 250,
          right: 120,
          child: const Icon(Icons.star_rounded, color: Colors.white, size: 12)
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .fade(begin: 0.1, end: 0.8, duration: 3.seconds),
        ),
        Positioned(
          top: 80,
          left: 200,
          child: const Icon(Icons.star_rounded, color: Colors.white, size: 20)
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .fade(begin: 0.3, end: 1.0, duration: 1.5.seconds),
        ),
        Positioned(
          top: 350,
          left: 50,
          child: const Icon(Icons.star_rounded, color: Colors.white, size: 14)
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .fade(begin: 0.2, end: 0.9, duration: 2.5.seconds),
        ),
        Positioned(
          top: 400,
          right: 80,
          child: const Icon(Icons.star_rounded, color: Colors.white, size: 18)
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .fade(begin: 0.1, end: 1.0, duration: 2.2.seconds),
        ),
        // Mây mờ trôi lững lờ
        Positioned(
          top: 180,
          left: -100,
          child: const Icon(
            Icons.cloud_rounded,
            color: Color(0x20FFFFFF), // Mây mờ
            size: 200,
          )
          .animate(onPlay: (controller) => controller.repeat())
          .moveX(begin: 0, end: 500, duration: 40.seconds, curve: Curves.linear),
        ),
        Positioned(
          top: 320,
          right: -150,
          child: const Icon(
            Icons.cloud_rounded,
            color: Color(0x10FFFFFF),
            size: 250,
          )
          .animate(onPlay: (controller) => controller.repeat())
          .moveX(begin: 0, end: -400, duration: 45.seconds, curve: Curves.linear),
        ),
      ],
    );
  }
}
