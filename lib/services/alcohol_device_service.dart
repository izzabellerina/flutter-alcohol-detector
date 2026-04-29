import '../models/device_models.dart';

/// อินเทอร์เฟซเครื่องเป่าแอลกอฮอล์ — รองรับทั้ง Bluetooth และ USB Serial
/// ในอนาคต (Phase 5+) implementation จริงจะเข้ามาแทนที่ Mock
abstract class AlcoholDeviceService {
  Future<List<DeviceInfo>> scan();
  Future<DeviceInfo> connect(DeviceInfo device);
  Future<void> disconnect();
  Stream<double> readMeasurements();
}

class MockAlcoholDeviceService implements AlcoholDeviceService {
  static const _mockDevice = DeviceInfo(
    id: 'S2SF5KSJ',
    name: 'Alcohol Analyzer S2',
    kind: DeviceKind.alcoholAnalyzer,
  );

  bool _connected = false;

  @override
  Future<List<DeviceInfo>> scan() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    return const [_mockDevice];
  }

  @override
  Future<DeviceInfo> connect(DeviceInfo device) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    _connected = true;
    return device;
  }

  @override
  Future<void> disconnect() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _connected = false;
  }

  @override
  Stream<double> readMeasurements() async* {
    if (!_connected) return;
    // Mock: คืนค่า 0 ทุก 200ms
    while (_connected) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      yield 0.0;
    }
  }
}
