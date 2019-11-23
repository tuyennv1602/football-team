import 'package:flutter/material.dart';

const Color PRIMARY = Color(0xFF01A028);
const Color WHITE_OPACITY = Color(0xCCF9F9F9);
const Color LINE_COLOR = Color(0xFFE0E0E0);
const Color GREY_BACKGROUND = Color(0xFFF2F3F4);
const Color BLACK_TRANSPARENT = Color(0x66000000);
const Color RED_ERROR = Color(0xFFC01D04);
const Color GREEN_SUCCESS = Color(0xFF01A028);
const Color BLACK_TEXT = Colors.black87;
const Color SHADOW_GREEN = Color(0xFFE9F7EF);
const Color FW = Colors.red;
const Color MF = Colors.lightGreen;
const Color DF = Colors.blueAccent;
const Color GK = Colors.orange;

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
  Color(0xFF028B24),
  Color(0xFF027B20),
  Color(0xFF026B1C),
  Color(0xFF025917),
  Color(0xFF024913),
  Color(0xFF02390F),
  Color(0xFF012A0B)
];

const List<Color> RED_GRADIENT = [
  Color(0xFFC01D04),
  Color(0xFFAB1B05),
  Color(0xFF9A1905),
  Color(0xFF8D1705),
  Color(0xFF7B1404),
  Color(0xFF681104),
  Color(0xFF641105),
  Color(0xFF540D03)
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
