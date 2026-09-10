import 'package:flutter/material.dart';

/// Paper Pop tokens from the Sharekhan rewards mock.
/// Change palette here; screens should not hard-code hex.
abstract final class AppColors {
  static const bg = Color(0xFFFAF8F3);
  static const cream = Color(0xFFFFFDF8);
  static const ink = Color(0xFF17150F);
  static const coral = Color(0xFFFF4D2E);
  static const deep = Color(0xFFB32A12);
  static const blush = Color(0xFFFFE9E3);
  static const sand = Color(0xFFF1EFE7);
  static const overlay = Color(0x7317150F);

  static const mute = Color(0xAD17150F);
  static const muteSoft = Color(0x9E17150F);
  static const line = Color(0x1F17150F);
  static const lineStrong = Color(0x2417150F);
  static const lineHeavy = Color(0x3317150F);
  static const coralLine = Color(0x66FF4D2E);
  static const locked = Color(0x9E17150F);

  static const gain = Color(0xFF188A42);
  static const loss = Color(0xFFE03131);

  static Color delta(bool up) => up ? gain : loss;
}
