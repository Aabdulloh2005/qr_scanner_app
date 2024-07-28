import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class QrCode {
  @HiveField(0)
  String url;
  @HiveField(1)
  DateTime date;
  QrCode({
    required this.url,
    required this.date,
  });
}
