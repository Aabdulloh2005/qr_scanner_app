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
import 'package:qr_scanner/utils/helpers.dart';
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
  QRViewController? controller;
  bool isCameraInitialized = false;
  bool isFlashOn = false;
  bool isFrontCamera = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _scanImage(File image) async {
    try {
      final qrCodeResult = await BarcodeFinder.scanFile(path: image.path);
      if (qrCodeResult != null) {
        await _handleQrResult(qrCodeResult);
      }
    } catch (e) {
      _showErrorSnackBar('Error scanning image: $e');
    }
  }

  Future<void> _handleQrResult(String result) async {
    await _pauseCamera();
    final qrCode = QrCodeModel(
      content: result,
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

  Future<void> _pauseCamera() async {
    if (isCameraInitialized && controller != null) {
      try {
        await controller!.pauseCamera();
      } catch (e) {
        debugPrint('Error pausing camera: $e');
      }
    }
  }

  Future<void> _resumeCamera() async {
    if (isCameraInitialized && controller != null) {
      try {
        await controller!.resumeCamera();
      } catch (e) {
        debugPrint('Error resuming camera: $e');
      }
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      isCameraInitialized = true;
    });

    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code != null) {
        await _handleQrResult(scanData.code!);
      }
    });
  }

  void _showErrorSnackBar(String message) {
    Helpers.showSnackBar(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ScreenCubit, int>(
        builder: (context, state) {
          return Stack(
            children: [
              _buildCenterWidget(state),
              Align(
                alignment: Alignment.topCenter,
                child: _buildTopBar(state),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildBottomBar(state),
              ),
              _buildScanButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCenterWidget(int state) {
    switch (state) {
      case 0:
        return GenerateCategoryScreen();
      case 1:
        return ScannerScreen(onQRViewCreated: _onQRViewCreated, qrKey: qrKey);
      case 2:
        return const HistoryScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTopBar(int state) {
    if (state == 1) {
      return CustomContainer(
        isShadow: true,
        widget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTopButton(Icons.image, _pickImage, false),
            _buildTopButton(Icons.flash_on, _toggleFlash, isFlashOn),
            _buildTopButton(
                Icons.cameraswitch_rounded, _flipCamera, isFrontCamera),
          ],
        ),
      );
    }

    String title = state == 0 ? "Generate QR" : "History";
    return CustomContainer(
      isColor: true,
      widget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: title,
            size: 20,
            fontWeight: FontWeight.bold,
          ),
          const ButtonWidget(icon: Icons.menu),
        ],
      ),
    );
  }

  Widget _buildBottomBar(int currentState) {
    return CustomContainer(
      isShadow: false,
      widget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildButton(Icons.qr_code, "Generate", () => _changeScreen(0),
              currentState == 0),
          _buildButton(Icons.history, "History", () => _changeScreen(2),
              currentState == 2),
        ],
      ),
    );
  }

  Widget _buildScanButton() {
    return Positioned(
      bottom: 70,
      left: MediaQuery.of(context).size.width / 2.5,
      child: GestureDetector(
        onTap: () => _changeScreen(1),
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
          child: SvgPicture.asset("assets/images/scan2.svg"),
        ),
      ),
    );
  }

  void _changeScreen(int index) {
    if (index != 1) {
      controller?.stopCamera();
    } else {
      controller?.resumeCamera();
    }
    context.read<ScreenCubit>().onScreenChanged(index);
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await _scanImage(File(pickedFile.path));
    }
  }

  void _toggleFlash() {
    controller?.toggleFlash();
    isFlashOn = !isFlashOn;
  }

  void _flipCamera() {
    controller?.flipCamera();
    isFrontCamera = !isFrontCamera;
  }

  Color _getActiveColor(bool isActive) {
    return isActive ? AppColor.yellow : Colors.grey;
  }

  Widget _buildButton(
      IconData icon, String text, VoidCallback onTap, bool isActive) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 30, color: _getActiveColor(isActive)),
          CustomText(
            text: text,
            fontWeight: FontWeight.bold,
            color: _getActiveColor(isActive),
          ),
        ],
      ),
    );
  }

  Widget _buildTopButton(IconData icon, VoidCallback onTap, bool isActive) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColor.yellow.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ]
            : [],
        shape: BoxShape.circle,
      ),
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          size: 30,
          color: _getActiveColor(isActive),
        ),
      ),
    );
  }
}
