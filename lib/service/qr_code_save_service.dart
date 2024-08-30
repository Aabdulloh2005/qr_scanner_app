import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

import 'package:share_plus/share_plus.dart';

class QrCodeSaveService {
  static Future<bool> generateAndSaveQRCode({
    required ScreenshotController screenshotController,
  }) async {
    try {
      if (await Permission.mediaLibrary.request().isGranted) {
        final directory = await getApplicationDocumentsDirectory();
        final imageFile = await screenshotController.captureAndSave(
          directory.path,
          fileName: 'qr_code.png',
        );

        if (imageFile != null) {
          final xFile = XFile(imageFile);
          await ImageGallerySaver.saveImage(await xFile.readAsBytes());
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // void shareQR({
  //   required ScreenshotController screenshotController,
  //   required String qrData,
  //   required BuildContext context,
  // }) async {
  //   try {
  //     final directory = await getApplicationDocumentsDirectory();
  //     final imageFile = await screenshotController.captureAndSave(
  //       directory.path,
  //       fileName: 'qr_code.png',
  //     );

  //     if (imageFile != null) {
  //       final xFile = XFile(imageFile);
  //       Share.shareXFiles(
  //         [xFile],
  //         text: 'Created by QuickQR. $qrData. ',
  //       );
  //     } else {
  //       if (context.mounted) {
  //         AppFunctions.showSnackBar(
  //           'Error: Unable to capture QR code image.',
  //           context,
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     if (context.mounted) {
  //       AppFunctions.showSnackBar('Error: $e', context);
  //     }
  //   }
  // }
}
