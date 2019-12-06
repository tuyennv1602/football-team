import 'package:flutter/material.dart';

const Color PRIMARY = Color(0xFF03be31);
const Color WHITE_OPACITY = Color(0xCCF9F9F9);
const Color LINE_COLOR = Color(0xFFE0E0E0);
const Color GREY_BACKGROUND = Color(0xFFF2F3F4);
const Color BLACK_TRANSPARENT = Color(0x66000000);
const Color RED_ERROR = Color(0xFFC01D04);
const Color GREEN_SUCCESS = Color(0xFF01A028);
const Color BLACK_TEXT = Colors.black87;
const Color SHADOW_GREEN = Color(0xFFA1FAB7);
const Color SHADOW_GREY = Color(0xFFE8E8E8);
const Color GREEN_TEXT = Color(0xFF03be31);
const Color LIGHT_GREEN = Color(0xFFF4FFF4);

const List<Color> BLACK_GRADIENT = [
  Color(0xCC000000),
  Color(0xBF000000),
  Color(0xB3000000),
  Color(0xA6000000),
  Color(0x99000000),
  Color(0x8C000000),
  Color(0x80000000),
  Color(0x73000000),
  Color(0x66000000),
  Color(0x59000000),
  Color(0x4D000000),
  Color(0x40000000),
  Color(0x33000000),
  Color(0x26000000),
  Color(0x1A000000),
  Color(0x0D000000),
  Color(0x00000000),
];

const List<Color> GREEN_GRADIENT = [
  Color(0xFF01A028),
  Color(0xFF057C21),
];

const List<Color> LIGHT_GREEN_GRADIENT = [
  Color(0xFF02DC37),
  Color(0xFF04B22F),
  Color(0xFF04B22F),
  Color(0xFF02DC37),
];

const List<Color> RED_GRADIENT = [
  Color(0xFFC01D04),
  Color(0xFF831605),
];

const List<Color> DRESS_COLORS = [
  Color(0xFFF6D2D1),
  Color(0xFFF3615D),
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Color(0xFFBEF471),
  Colors.lime,
  Colors.blue,
  Color(0xFF96C9E7),
  Colors.purple,
  Color(0xFF5219B0),
  Colors.grey,
  Color(0xFF738589),
  Color(0xFF1B2D54),
  Colors.black,
  Colors.white
];

String getColorValue(String color) {
  return color.split('(0x')[1].split(')')[0];
}

Color parseColor(String code) {
  int value = int.parse(code, radix: 16);
  return Color(value);
}

Color getPositionColor(String position) {
  switch (position) {
    case 'FW':
      return Colors.red;
    case 'MF':
      return Colors.lightGreen;
      break;
    case 'DF':
      return Colors.blueAccent;
    case 'GK':
      return Colors.orange;
  }
  return Colors.white;
}
