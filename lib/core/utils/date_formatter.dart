import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static const List<String> _thaiMonths = [
    'มกราคม',
    'กุมภาพันธ์',
    'มีนาคม',
    'เมษายน',
    'พฤษภาคม',
    'มิถุนายน',
    'กรกฎาคม',
    'สิงหาคม',
    'กันยายน',
    'ตุลาคม',
    'พฤศจิกายน',
    'ธันวาคม',
  ];

  /// Format: "01 มกราคม 2569 เวลา 17.00 น."
  static String formatThaiDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = _thaiMonths[dateTime.month - 1];
    final buddhistYear = dateTime.year + 543;
    final time = DateFormat('HH.mm').format(dateTime);
    return '$day $month $buddhistYear เวลา $time น.';
  }

  /// Format: "01/01/2569"
  static String formatThaiDate(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final buddhistYear = dateTime.year + 543;
    return '$day/$month/$buddhistYear';
  }

  /// Format: "01/01/2569 17:00:00"
  static String formatThaiDateTimeFull(DateTime dateTime) {
    final date = formatThaiDate(dateTime);
    final time = DateFormat('HH:mm:ss').format(dateTime);
    return '$date $time';
  }

  /// Format: "HH:mm:ss" → ใช้กับนาฬิกานับถอยหลัง OTP
  static String formatCountdown(int seconds) {
    final minutes = (seconds ~/ 60).toString();
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }
}
