import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider<int>((ref) => 0);
final themeSwitchProvider = StateProvider<bool>((ref) => false);
final colorProvider = StateProvider<MaterialColor>((ref) => const MaterialColor(
  0xFF121E30, 
  <int, Color>{
    50: Color(0xFFE3E5E9),
    100: Color(0xFFB9BCC8),
    200: Color(0xFF8B8E9F),
    300: Color(0xFF5D6076),
    400: Color(0xFF3B3E56),
    500: Color(0xFF121E30),
    600: Color(0xFF101A2B),
    700: Color(0xFF0D1624),
    800: Color(0xFF0A121E),
    900: Color(0xFF060B13),
  },
));