import 'package:package_info_plus/package_info_plus.dart';

/// **อัปเดตค่านี้ทุกครั้งที่บัมป์ `version` ใน `pubspec.yaml`**
/// ใช้แสดง "อัปเดตเมื่อ ..." ใน footer ของแอป
final DateTime _versionUpdatedAt = DateTime(2026, 4, 30, 11, 30);

class AppInfo {
  const AppInfo({
    required this.appName,
    required this.version,
    required this.buildNumber,
    required this.versionUpdatedAt,
  });

  final String appName;
  final String version;
  final String buildNumber;
  final DateTime versionUpdatedAt;

  /// รูปแบบที่ใช้แสดงใน footer เช่น "1.0.0+1"
  String get displayVersion =>
      buildNumber.isEmpty ? version : '$version+$buildNumber';

  static Future<AppInfo> load() async {
    final info = await PackageInfo.fromPlatform();
    return AppInfo(
      appName: info.appName,
      version: info.version,
      buildNumber: info.buildNumber,
      versionUpdatedAt: _versionUpdatedAt,
    );
  }
}
