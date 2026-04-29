import '../models/device_models.dart';

class DriverInfo {
  const DriverInfo({
    required this.licenseNumber,
    required this.fullName,
    required this.vehiclePlate,
    required this.province,
  });

  final String licenseNumber;
  final String fullName;
  final String vehiclePlate;
  final String province;
}

class CardReadException implements Exception {
  CardReadException(this.message);
  final String message;
  @override
  String toString() => 'CardReadException: $message';
}

abstract class CardReaderService {
  Future<List<DeviceInfo>> scan();
  Future<DeviceInfo> connect(DeviceInfo device);
  Future<void> disconnect();
  Future<DriverInfo> readCard();
}

class MockCardReaderService implements CardReaderService {
  static const _mockDevice = DeviceInfo(
    id: 'CR-001',
    name: 'Card Reader',
    kind: DeviceKind.cardReader,
  );

  bool _connected = false;

  @override
  Future<List<DeviceInfo>> scan() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return const [_mockDevice];
  }

  @override
  Future<DeviceInfo> connect(DeviceInfo device) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _connected = true;
    return device;
  }

  @override
  Future<void> disconnect() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _connected = false;
  }

  @override
  Future<DriverInfo> readCard() async {
    if (!_connected) {
      throw CardReadException('ยังไม่ได้เชื่อมต่อเครื่องอ่านบัตร');
    }
    await Future<void>.delayed(const Duration(milliseconds: 800));
    return const DriverInfo(
      licenseNumber: '591100',
      fullName: 'นายสมชาย ขับดี',
      vehiclePlate: '70-1234',
      province: 'กรุงเทพมหานคร',
    );
  }
}
