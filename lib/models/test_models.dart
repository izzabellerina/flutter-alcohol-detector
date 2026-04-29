import '../services/card_reader_service.dart';

enum TestPhase {
  idle,
  preparingAir,
  blowing,
  complete,
  cancelled,
}

enum TestOutcome {
  passed,
  failedAlcohol,
  failedFaceMismatch,
}

/// สำหรับ Mock — สลับ scenario เพื่อทดสอบผลลัพธ์ต่าง ๆ
enum MockTestScenario {
  pass,
  failAlcohol,
  failFaceMismatch,
}

class TestMeasurement {
  const TestMeasurement({required this.value, required this.timestamp});

  /// ค่าที่วัดได้ (mg%)
  final double value;
  final DateTime timestamp;
}

class TestResult {
  const TestResult({
    required this.outcome,
    required this.airMeasurement,
    required this.userMeasurement,
    required this.threshold,
  });

  final TestOutcome outcome;
  final TestMeasurement airMeasurement;
  final TestMeasurement userMeasurement;
  final double threshold;

  bool get passed => outcome == TestOutcome.passed;
  bool get failedFaceMismatch => outcome == TestOutcome.failedFaceMismatch;
}

class TestSession {
  const TestSession({
    required this.driver,
    required this.result,
    required this.completedAt,
  });

  final DriverInfo driver;
  final TestResult result;
  final DateTime completedAt;
}
