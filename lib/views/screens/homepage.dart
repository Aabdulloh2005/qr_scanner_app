import 'dart:io';
import 'package:barcode_finder/barcode_finder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_scanner/cubit/screen_cubit.dart';
import 'package:qr_scanner/models/qr_code.dart';
import 'package:qr_scanner/service/qr_code_service.dart';
import 'package:qr_scanner/utils/app_color.dart';
import 'package:qr_scanner/utils/app_route.dart';
import 'package:qr_scanner/views/screens/generate/generate_category_screen.dart';
import 'package:qr_scanner/views/screens/history/history_screen.dart';
import 'package:qr_scanner/views/screens/scanner/scanner_screen.dart';
import 'package:qr_scanner/views/widgets/button_widget.dart';
import 'package:qr_scanner/views/widgets/custom_container.dart';
import 'package:qr_scanner/views/widgets/custom_text.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isCameraInitialized = false;

  Future<void> _scanImage(File image) async {
    final qrCodeResult = await BarcodeFinder.scanFile(path: image.path);
    if (qrCodeResult != null) {
      await _pauseCamera();
      final qrCode = QrCodeModel(
        content: qrCodeResult,
        createdAt: DateTime.now(),
        isScanned: true,
      );
      await QrCodeService().addQrCode(qrCode);
      if (mounted) {
        Navigator.of(context).pushNamed(
          AppRoute.resultScreen,
          arguments: qrCode,
        );
      }
      await _resumeCamera();
    }
  }

  Future<void> _pauseCamera() async {
    if (isCameraInitialized && controller != null) {
      try {
        await controller!.pauseCamera();
      } catch (e) {
        print('Error pausing camera: $e');
      }
    }
  }

  Future<void> _resumeCamera() async {
    if (isCameraInitialized && controller != null) {
      try {
        await controller!.resumeCamera();
      } catch (e) {
        print('Error resuming camera: $e');
      }
    }
  }

  Future<void> _stopCamera() async {
    if (isCameraInitialized && controller != null) {
      try {
        await controller!.stopCamera();
        isCameraInitialized = false;
      } catch (e) {
        print('Error stopping camera: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> topbars = [
      const CustomContainer(
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
            _buildtopButton(Icons.image, () async {
              final pickedFile =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                await _scanImage(File(pickedFile.path));
              }
            }),
            _buildtopButton(Icons.flash_on, () {
              controller?.toggleFlash();
            }),
            _buildtopButton(Icons.cameraswitch_rounded, () {
              controller?.flipCamera();
            }),
          ],
        ),
      ),
      const CustomContainer(
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
      const HistoryScreen(),
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
    isCameraInitialized = true;

    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
      if (result != null) {
        await _pauseCamera();
        final urlCode = result!.code.toString();

        final qrCode = QrCodeModel(
          content: urlCode,
          createdAt: DateTime.now(),
          isScanned: true,
        );
        await QrCodeService().addQrCode(qrCode);
        if (mounted) {
          Navigator.of(context).pushNamed(
            AppRoute.resultScreen,
            arguments: qrCode,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _stopCamera();
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
