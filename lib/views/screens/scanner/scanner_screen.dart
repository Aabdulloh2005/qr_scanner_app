import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_scanner/utils/app_color.dart';

import '../../../cubit/cutoutsize_cubit.dart';

class ScannerScreen extends StatelessWidget {
  final Function(QRViewController) onQRViewCreated;
  final Key qrKey;
  const ScannerScreen(
      {super.key, required this.onQRViewCreated, required this.qrKey});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CutoutsizeCubit, double>(
      builder: (context, state) {
        return GestureDetector(
          onPanUpdate: (details) {
            context.read<CutoutsizeCubit>().onPanUpdate(
                  details: details,
                  context: context,
                );
          },
          child: QRView(
            key: qrKey,
            onQRViewCreated: onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: AppColor.yellow,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: state,
            ),
          ),
        );
      },
    );
  }
}
