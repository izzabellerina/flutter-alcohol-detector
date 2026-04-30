import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../core/constants/app_constants.dart';
import '../core/utils/haptics.dart';
import '../models/test_models.dart';
import '../services/card_reader_service.dart';
import '../services/test_repository.dart';

class TestController extends ChangeNotifier {
  TestController({required TestRepository repository})
      : _repository = repository;

  final TestRepository _repository;
  final Random _random = Random();

  TestPhase _phase = TestPhase.idle;
  double _progress = 0.0;
  bool _faceInFrame = true;
  TestMeasurement? _airMeasurement;
  TestMeasurement? _userMeasurement;
  TestResult? _result;
  bool _isSaving = false;
  Timer? _ticker;

  /// scenario ใช้สำหรับ Mock — สลับผลลัพธ์การทดสอบ
  MockTestScenario nextScenario = MockTestScenario.pass;

  TestPhase get phase => _phase;
  double get progress => _progress;
  bool get faceInFrame => _faceInFrame;
  TestMeasurement? get airMeasurement => _airMeasurement;
  TestMeasurement? get userMeasurement => _userMeasurement;
  TestResult? get result => _result;
  bool get isSaving => _isSaving;

  bool get isRunning =>
      _phase == TestPhase.preparingAir || _phase == TestPhase.blowing;

  /// reset state เพื่อเริ่มทดสอบครั้งใหม่
  void reset() {
    _ticker?.cancel();
    _phase = TestPhase.idle;
    _progress = 0.0;
    _faceInFrame = true;
    _airMeasurement = null;
    _userMeasurement = null;
    _result = null;
    notifyListeners();
  }

  /// สำหรับเดโม — สลับสถานะใบหน้าในกรอบ (จำลอง face detection)
  void setFaceInFrame(bool inFrame) {
    if (_faceInFrame == inFrame) return;
    _faceInFrame = inFrame;
    notifyListeners();
  }

  Future<void> startTest({required DriverInfo driver}) async {
    if (isRunning) return;
    reset();

    // เฟส 1: วัดอากาศ baseline
    _phase = TestPhase.preparingAir;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (_phase == TestPhase.cancelled) return;
    _airMeasurement = TestMeasurement(
      value: _generateAirReading(),
      timestamp: DateTime.now(),
    );

    // เฟส 2: ผู้เป่า — progress 0% → 100% ภายใน ~5 วินาที
    _phase = TestPhase.blowing;
    Haptics.light();
    notifyListeners();
    const totalDurationMs = 5000;
    const tickMs = 100;
    var elapsed = 0;
    final completer = Completer<void>();
    _ticker = Timer.periodic(const Duration(milliseconds: tickMs), (timer) {
      // หยุดนับเวลาเมื่อใบหน้าไม่อยู่ในกรอบ
      if (!_faceInFrame) {
        notifyListeners();
        return;
      }
      elapsed += tickMs;
      _progress = (elapsed / totalDurationMs).clamp(0.0, 1.0);
      notifyListeners();
      if (elapsed >= totalDurationMs) {
        timer.cancel();
        completer.complete();
      }
    });
    await completer.future;
    if (_phase == TestPhase.cancelled) return;

    _userMeasurement = TestMeasurement(
      value: _generateUserReading(),
      timestamp: DateTime.now(),
    );

    final outcome = _decideOutcome();
    _result = TestResult(
      outcome: outcome,
      airMeasurement: _airMeasurement!,
      userMeasurement: _userMeasurement!,
      threshold: AppConstants.alcoholThreshold,
    );
    _phase = TestPhase.complete;
    notifyListeners();

    if (outcome == TestOutcome.passed) {
      Haptics.success();
    } else {
      Haptics.failure();
    }

    await _saveSession(driver);
  }

  void cancelTest() {
    _ticker?.cancel();
    _phase = TestPhase.cancelled;
    notifyListeners();
  }

  TestOutcome _decideOutcome() {
    switch (nextScenario) {
      case MockTestScenario.pass:
        return TestOutcome.passed;
      case MockTestScenario.failAlcohol:
        return TestOutcome.failedAlcohol;
      case MockTestScenario.failFaceMismatch:
        return TestOutcome.failedFaceMismatch;
    }
  }

  double _generateAirReading() => 0.0;

  double _generateUserReading() {
    switch (nextScenario) {
      case MockTestScenario.pass:
        return 0.0;
      case MockTestScenario.failAlcohol:
      case MockTestScenario.failFaceMismatch:
        // เครื่องเป่าวัดได้แม้ใบหน้าจะไม่ตรง
        return 15.0 + _random.nextInt(75).toDouble();
    }
  }

  Future<void> _saveSession(DriverInfo driver) async {
    if (_result == null) return;
    _isSaving = true;
    notifyListeners();
    final session = TestSession(
      driver: driver,
      result: _result!,
      completedAt: DateTime.now(),
    );
    await _repository.save(session);
    _isSaving = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
