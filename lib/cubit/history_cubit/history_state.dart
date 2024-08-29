
import 'package:qr_scanner/models/qr_code.dart';

class HistoryState {
  final List<QrCodeModel> scannedQrCodes;
  final List<QrCodeModel> createdQrCodes;

  HistoryState({required this.scannedQrCodes, required this.createdQrCodes});
}