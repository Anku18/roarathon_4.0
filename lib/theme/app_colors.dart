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

  // Family wealth (4e) and the connectivity bubble.
  static const gold = Color(0xFFE0B04A);
  static const online = Color(0xFF1F9D55);
  static const muteStrong = Color(0xB317150F); // ink 70%
  static const chipIdle = Color(0x1417150F); // ink 8%
  static const track = Color(0x1717150F); // ink 9%
  static const lossFill = Color(0x1217150F); // ink 7%
  static const tagNeutral = Color(0x0F17150F); // ink 6%
  static const lineDashed = Color(0x4017150F); // ink 25%
  static const coralAlert = Color(0x73FF4D2E); // coral 45%
  static const coralHalo = Color(0x33FF4D2E); // coral 20%
  static const onlineHalo = Color(0x2E1F9D55); // green 18%

  static const gain = Color(0xFF188A42);
  static const loss = Color(0xFFE03131);

  static Color delta(bool up) => up ? gain : loss;
}
