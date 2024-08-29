import 'package:hive_flutter/adapters.dart';
import 'package:qr_scanner/models/qr_code.dart';

class QrCodeService {
  String qrBoxName = "qrCodes";

  Future<Box<QrCodeModel>> get _box async {
    return await Hive.openBox<QrCodeModel>(qrBoxName);
  }

  Future<void> addQrCode(QrCodeModel qrCode) async {
    final box = await _box;
    await box.add(qrCode);
  }

  Future<List<QrCodeModel>> getQrCodes() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<void> deleteQrCode(QrCodeModel qrCode) async {
    await qrCode.delete();
  }
}
