import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
// Updated: 2026-07-02 by Kayla
// Change: Menggunakan Get.offNamed
// Reason: Memperbaiki syntax error karena Get.offReplacementNamed tidak valid di GetX
    Timer(const Duration(seconds: 2), () {
      Get.offNamed(AppRoutes.DASHBOARD);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/logo_borwita.png',
              width: 220,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.business,
                size: 100,
                color: Colors.blue,
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 40.0),
              child: Text(
                "Developed by Kayla Kirani Kusnadi",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}