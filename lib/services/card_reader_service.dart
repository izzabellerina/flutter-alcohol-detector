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

  /// แสดงเลขใบขับขี่แบบ mask: "591100" → "59xxx00"
  String get maskedLicenseNumber {
    if (licenseNumber.length < 4) return licenseNumber;
    final prefix = licenseNumber.substring(0, 2);
    final suffix = licenseNumber.substring(licenseNumber.length - 2);
    return '${prefix}xxx$suffix';
  }
}

enum CardReadErrorType {
  notFound,
  invalidNumber,
  mismatch,
}

class CardReadException implements Exception {
  CardReadException({required this.type, required this.message, this.detail});

  final CardReadErrorType type;
  final String message;
  final String? detail;

  @override
  String toString() => 'CardReadException($type): $message';
}

abstract class CardReaderService {
  Future<List<DeviceInfo>> scan();
  Future<DeviceInfo> connect(DeviceInfo device);
  Future<void> disconnect();
  Future<DriverInfo> readCard();
}

/// Mock — รองรับการสลับ scenario เพื่อทดสอบ flow ต่าง ๆ
enum MockCardReadScenario {
  success,
  notFound,
  invalidNumber,
  mismatch,
}

class MockCardReaderService implements CardReaderService {
  static const _mockDevice = DeviceInfo(
    id: 'CR-001',
    name: 'Card Reader',
    kind: DeviceKind.cardReader,
  );

  bool _connected = false;
  MockCardReadScenario nextScenario = MockCardReadScenario.success;

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
      throw CardReadException(
        type: CardReadErrorType.notFound,
        message: 'ยังไม่ได้เชื่อมต่อเครื่องอ่านบัตร',
      );
    }
    await Future<void>.delayed(const Duration(milliseconds: 800));

    switch (nextScenario) {
      case MockCardReadScenario.success:
        return const DriverInfo(
          licenseNumber: '591100',
          fullName: 'นายสมชาย ขับดี',
          vehiclePlate: '70-1234',
          province: 'กรุงเทพมหานคร',
        );
      case MockCardReadScenario.notFound:
        throw CardReadException(
          type: CardReadErrorType.notFound,
          message: 'ไม่พบใบขับขี่ กรุณารูดบัตรใหม่อีกครั้ง',
        );
      case MockCardReadScenario.invalidNumber:
        throw CardReadException(
          type: CardReadErrorType.invalidNumber,
          message: 'ข้อมูลใบขับขี่ไม่ถูกต้อง',
          detail: '65xxx00',
        );
      case MockCardReadScenario.mismatch:
        throw CardReadException(
          type: CardReadErrorType.mismatch,
          message: 'ข้อมูลใบขับขี่ไม่ตรงกับระบบ',
        );
    }
  }
}
