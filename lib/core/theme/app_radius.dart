import 'package:flutter/widgets.dart';

/// ระบบ border radius tokens
class AppRadius {
  AppRadius._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double pill = 999;

  static BorderRadius all(double r) => BorderRadius.circular(r);
}
