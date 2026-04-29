import 'package:flutter/services.dart';

/// Centralized haptic feedback patterns
/// ใช้แทนการเรียก `HapticFeedback` ตรง ๆ เพื่อให้รูปแบบสม่ำเสมอ
class Haptics {
  Haptics._();

  /// สำหรับการกดปุ่มทั่วไป
  static Future<void> light() => HapticFeedback.lightImpact();

  /// สำหรับ confirmation actions (เชื่อมต่อ/ยืนยัน)
  static Future<void> medium() => HapticFeedback.mediumImpact();

  /// สำหรับ error / failure / destructive
  static Future<void> heavy() => HapticFeedback.heavyImpact();

  /// สำหรับเลือก/สลับ (selection)
  static Future<void> selection() => HapticFeedback.selectionClick();

  /// สำหรับ success outcome (test pass)
  static Future<void> success() async {
    await HapticFeedback.mediumImpact();
    await Future<void>.delayed(const Duration(milliseconds: 80));
    await HapticFeedback.lightImpact();
  }

  /// สำหรับ failure outcome (test fail)
  static Future<void> failure() async {
    await HapticFeedback.heavyImpact();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
  }
}
