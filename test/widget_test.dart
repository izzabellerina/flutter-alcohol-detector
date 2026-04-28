import 'package:flutter_test/flutter_test.dart';

import 'package:alcohol_detector/main.dart';

void main() {
  testWidgets('App starts at login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const AlcoholDetectorApp());
    await tester.pumpAndSettle();

    expect(find.text('เข้าสู่ระบบ'), findsOneWidget);
    expect(find.text('ลืมรหัสผ่าน'), findsOneWidget);
  });
}
