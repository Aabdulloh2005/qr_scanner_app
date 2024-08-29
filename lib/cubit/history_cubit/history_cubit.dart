import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_scanner/cubit/history_cubit/history_state.dart';
import 'package:qr_scanner/models/qr_code.dart';
import 'package:qr_scanner/service/qr_code_service.dart';


class HistoryCubit extends Cubit<HistoryState> {
  final QrCodeService _qrCodeService;

  HistoryCubit(this._qrCodeService) : super(HistoryState(scannedQrCodes: [], createdQrCodes: [])) {
    loadQrCodes();
  }

  Future<void> loadQrCodes() async {
    final qrCodes = await _qrCodeService.getQrCodes();
    final scannedQrCodes = qrCodes.where((qr) => qr.isScanned).toList();
    final createdQrCodes = qrCodes.where((qr) => !qr.isScanned).toList();
    emit(HistoryState(scannedQrCodes: scannedQrCodes, createdQrCodes: createdQrCodes));
  }

  Future<void> deleteQrCode(QrCodeModel qrCode) async {
    await _qrCodeService.deleteQrCode(qrCode);
    await loadQrCodes();
  }
}
