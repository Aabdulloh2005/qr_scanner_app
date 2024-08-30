import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_scanner/utils/app_route.dart';
import 'package:qr_scanner/utils/device_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoute.onboardingScreen);
      }
    } else {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoute.homeScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          "assets/lottie/loading.json",
          height: DeviceScreen.w(context) / 2,
        ),
      ),
    );
  }
}
