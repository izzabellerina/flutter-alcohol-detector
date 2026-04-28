import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/app_buttons.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/common/app_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      header: const AppHeader(
        greetingName: 'DEMO',
        licenseNumber: '59xxx00',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          AppButton.danger(
            label: 'เลิกเชื่อมต่ออุปกรณ์',
            icon: Icons.bluetooth_disabled,
            onPressed: () {
              // TODO: ตัดการเชื่อมต่ออุปกรณ์ใน Phase 3
            },
          ),
          const SizedBox(height: 12),
          AppButton.secondary(
            label: 'ดึงข้อมูลเครื่องอ่านใบขับขี่',
            onPressed: () {
              // TODO: ดึงข้อมูลใบขับขี่ใน Phase 4
            },
          ),
          const SizedBox(height: 12),
          AppButton.primary(
            label: 'เริ่มการทดสอบ',
            onPressed: () => context.push(AppRoutes.testReady),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => context.go(AppRoutes.login),
            child: const Text('ออกจากระบบ'),
          ),
        ],
      ),
    );
  }
}
