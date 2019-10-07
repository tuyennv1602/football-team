import 'package:flutter/material.dart';

const Color PRIMARY = Colors.green;
const Color WHITE_OPACITY = Color(0xCCF9F9F9);
const Color LINE_COLOR = Color(0xFFE0E0E0);
const Color GREY_BACKGROUND = Color(0xFFF2F3F4);
const Color BLACK_TRANSPARENT = Color(0x66000000);
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

const List<Color> DRESS_COLORS = [
  Colors.red,
  Colors.pinkAccent,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.lime,
  Colors.purple,
  Colors.indigoAccent,
  Colors.black,
  Colors.grey,
  Colors.white
];

String getColorValue(String color) {
  return color.split('(0x')[1].split(')')[0];
}

Color parseColor(String code) {
  int value = int.parse(code, radix: 16);
  return Color(value);
}
