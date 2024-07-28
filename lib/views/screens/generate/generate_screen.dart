import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:qr_scanner/utils/app_color.dart';
import 'package:qr_scanner/utils/app_route.dart';
import 'package:qr_scanner/utils/extensions.dart';
import 'package:qr_scanner/views/widgets/custom_appbar.dart';
import 'package:qr_scanner/views/widgets/custom_text.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateScreen extends StatelessWidget {
  final String icon;
  final String label;
  final String baseUrl;
  GenerateScreen({
    super.key,
    required this.icon,
    required this.label,
    required this.baseUrl,
  });

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3D3D3D),
      appBar: CustomAppbar(
        title: icon.toUpper(),
        leading: true,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.transparent.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: const Border.symmetric(
              horizontal: BorderSide(
                color: AppColor.yellow,
                width: 2,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SvgPicture.asset(
                  "assets/categories/$icon.svg",
                  height: 60,
                  width: 60,
                ),
                const Gap(50),
                CustomText(
                  text: label,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                ),
                const Gap(10),
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    hintText: "Enter...",
                  ),
                ),
                const Gap(40),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 10),
                  child: FloatingActionButton(
                    backgroundColor: AppColor.yellow,
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AppRoute.resultScreen,
                        arguments: "$baseUrl${textController.text}",
                      );
                      // showDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     return Dialog(
                      //       backgroundColor: Colors.white,
                      //       child: QrImageView(
                      //         data: "$baseUrl${textController.text}",
                      //         version: QrVersions.auto,
                      //       ),
                      //     );
                      //   },
                      // );
                    },
                    child: CustomText(
                      text: "Generate QR Code",
                      color: AppColor.black,
                      fontWeight: FontWeight.bold,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
