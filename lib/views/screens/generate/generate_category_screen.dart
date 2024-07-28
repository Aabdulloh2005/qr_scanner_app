import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_scanner/utils/app_color.dart';
import 'package:qr_scanner/utils/app_route.dart';
import 'package:qr_scanner/utils/extensions.dart';
import 'package:qr_scanner/views/widgets/custom_text.dart';

class GenerateCategoryScreen extends StatelessWidget {
  GenerateCategoryScreen({super.key});
  final List<String> svgIcons = [
    'telegram',
    'instagram',
    'email',
    'location',
    'twitter',
    'wathsApp',
    'website',
    // 'wifi',
    'telephone',
    'text',
  ];
  final List<String> lablels = [
    "Username",
    "Username",
    "Email",
    "Location",
    "Username",
    "WhatsApp Number",
    "Website URL",
    // "Network",
    "Phone Number",
    "Text",
  ];
  List<String> baseUrls = [
    'https://t.me/',
    'https://www.instagram.com/',
    'MAILTO:',
    'https://www.google.com/maps/search/',
    'https://x.com/',
    'https://web.whatsapp.com/',
    'https://',
    'tel:',
    ' '
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 120),
        child: GridView.builder(
          itemCount: svgIcons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 30,
            crossAxisSpacing: 30,
          ),
          itemBuilder: (context, i) {
            final icon = svgIcons[i];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoute.generateScreen,
                  arguments: {
                    "icon": icon,
                    "label": lablels[i],
                    'baseUrl': baseUrls[i],
                  },
                );
              },
              child: Stack(
                children: [
                  Container(
                    height: 86,
                    width: 82,
                    decoration: BoxDecoration(
                      color: AppColor.grey,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColor.yellow,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset('assets/categories/$icon.svg'),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(-0.1, -1.4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppColor.yellow,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: CustomText(
                        text: icon.toUpper(),
                        color: AppColor.black,
                        size: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
