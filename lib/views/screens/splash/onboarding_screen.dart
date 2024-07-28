import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:qr_scanner/utils/app_color.dart';
import 'package:qr_scanner/utils/app_route.dart';
import '../homepage.dart';
import 'package:qr_scanner/views/widgets/custom_text.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CustomText(
                textAlign: TextAlign.center,
                text:
                    "Go and enjoy our features for free and make your life easy with us.",
                fontWeight: FontWeight.bold,
                size: 16,
              ),
            ),
            const Gap(20),
            FloatingActionButton(
              backgroundColor: AppColor.yellow,
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(AppRoute.homeScreen);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 50,
                  ),
                  CustomText(
                    text: "Let's Start",
                    size: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.black,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.keyboard_arrow_right,
                      color: AppColor.black,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
