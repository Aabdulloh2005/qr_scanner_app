import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../homepage.dart';

import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (context) => const OnboardingScreen(),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: MediaQuery.of(context).size.height / 4,
          left: MediaQuery.of(context).size.width / 4,
          child: SvgPicture.asset('assets/images/scan.svg'),
        ),
      ],
    ));
  }
}
