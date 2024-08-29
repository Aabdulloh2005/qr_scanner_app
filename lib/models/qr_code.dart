import 'package:hive/hive.dart';

part 'qr_code.g.dart';


@HiveType(typeId: 0)
class QrCodeModel extends HiveObject {
  @HiveField(0)
  final String content;

  @HiveField(1)
  final DateTime createdAt;

  @HiveField(2)
  final bool isScanned;

  QrCodeModel({
    required this.content,
    required this.createdAt,
    required this.isScanned,
  });

  String get formattedDate {
    return "${createdAt.day} ${_getMonthName(createdAt.month)} ${createdAt.year}, ${createdAt.hour}:${createdAt.minute} ${createdAt.hour >= 12 ? 'pm' : 'am'}";
  }

  String _getMonthName(int month) {
    const monthNames = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return monthNames[month - 1];
  }
}