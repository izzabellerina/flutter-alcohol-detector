import 'package:flutter_test/flutter_test.dart';

import 'package:alcohol_detector/main.dart';
import 'package:alcohol_detector/services/app_info.dart';

void main() {
  testWidgets('App starts at login screen', (WidgetTester tester) async {
    final appInfo = AppInfo(
      appName: 'alcohol_detector',
      version: '1.0.0',
      buildNumber: '1',
      versionUpdatedAt: DateTime(2026, 4, 29, 17, 0),
    );
    await tester.pumpWidget(AlcoholDetectorApp(appInfo: appInfo));
    await tester.pumpAndSettle();

    expect(find.text('เข้าสู่ระบบ'), findsOneWidget);
    expect(find.text('ลืมรหัสผ่าน'), findsOneWidget);
    expect(find.text('Version 1.0.0+1'), findsOneWidget);
    expect(
      find.text('อัปเดตเมื่อ 29 เมษายน 2569 เวลา 17.00 น.'),
      findsOneWidget,
    );
  });
}
