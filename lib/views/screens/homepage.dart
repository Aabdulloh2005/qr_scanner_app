import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_scanner/cubit/screen_cubit.dart';
import 'package:qr_scanner/utils/app_color.dart';
import 'package:qr_scanner/views/screens/generate/generate_category_screen.dart';
import 'package:qr_scanner/views/screens/history/history_screen.dart';
import 'package:qr_scanner/views/screens/scanner/scanner_screen.dart';
import 'package:qr_scanner/views/widgets/button_widget.dart';
import 'package:qr_scanner/views/widgets/custom_container.dart';
import 'package:qr_scanner/views/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    List<Widget> topbars = [
      CustomContainer(
        isColor: true,
        widget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: "Generate QR",
              size: 20,
              fontWeight: FontWeight.bold,
            ),
            ButtonWidget(icon: Icons.menu),
          ],
        ),
      ),
      CustomContainer(
        isShadow: true,
        widget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildtopButton(Icons.image, () {}),
            _buildtopButton(Icons.flash_on, () {
              controller?.toggleFlash();
            }),
            _buildtopButton(Icons.cameraswitch_rounded, () {
              controller?.flipCamera();
            }),
          ],
        ),
      ),
      CustomContainer(
        isColor: true,
        widget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: "History",
              size: 20,
              fontWeight: FontWeight.bold,
            ),
            ButtonWidget(icon: Icons.menu),
          ],
        ),
      ),
    ];

    List<Widget> centerWidgets = [
      GenerateCategoryScreen(),
      ScannerScreen(onQRViewCreated: _onQRViewCreated, qrKey: qrKey),
      HistoryScreen(),
    ];
    return Scaffold(
      body: BlocBuilder<ScreenCubit, int>(
        builder: (context, state) {
          return Stack(
            children: [
              centerWidgets[state],
              Align(
                alignment: Alignment.topCenter,
                child: topbars[state],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CustomContainer(
                  isShadow: false,
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildButton(
                        Icons.qr_code,
                        "Generate",
                        () {
                          controller?.stopCamera();
                          context.read<ScreenCubit>().onScreenChanged(0);
                        },
                      ),
                      _buildButton(
                        Icons.history,
                        "History",
                        () {
                          controller?.stopCamera();
                          context.read<ScreenCubit>().onScreenChanged(2);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 70,
                left: MediaQuery.of(context).size.width / 2.5,
                child: GestureDetector(
                  onTap: () {
                    controller?.resumeCamera();
                    context.read<ScreenCubit>().onScreenChanged(1);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: AppColor.yellow,
                          blurRadius: 20,
                          blurStyle: BlurStyle.solid,
                        ),
                      ],
                      color: AppColor.yellow,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: SvgPicture.asset(
                      "assets/images/scan2.svg",
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      if (result != null) {
        controller.stopCamera();
        final urlCode = result!.code.toString();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Result"),
              content: Text(urlCode),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel"),
                    ),
                    const Gap(10),
                    FilledButton(
                      onPressed: () async {
                        Clipboard.setData(ClipboardData(text: urlCode))
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  duration: Duration(seconds: 1),
                                  content: Text("Url copied to Clipboard")));
                        });
                      },
                      child: const Text("Copy"),
                    ),
                    const Gap(10),
                    FilledButton(
                      onPressed: () async {
                        Uri url = Uri.parse(urlCode);

                        if (await launchUrl(url)) {
                          print("Wrong url");
                        }
                      },
                      child: const Text("Open"),
                    )
                  ],
                )
              ],
            );
          },
        ).then(
          (value) {
            controller.resumeCamera();
          },
        );
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget _buildButton(IconData icon, String text, Function() function) {
    return GestureDetector(
      onTap: function,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
          ),
          CustomText(
            text: text,
            fontWeight: FontWeight.bold,
          )
        ],
      ),
    );
  }

  Widget _buildtopButton(IconData icon, Function() function) {
    return InkWell(
      onTap: function,
      child: Icon(
        icon,
        size: 30,
      ),
    );
  }
}
