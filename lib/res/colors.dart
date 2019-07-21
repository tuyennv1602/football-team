import 'package:flutter/material.dart';

class AppColor {
  static const Color WHITE_OPACITY = Color(0xCCF9F9F9);
  static const Color MAIN_BLACK = Colors.black87;
  static const Color SECOND_BLACK = Colors.black54;
  static const Color WHITE = Color(0xFFFFFFFF);
  static const Color LINE_COLOR = Color(0xFFE0E0E0);
  static const Color GREY_BACKGROUND = Color(0xFFF2F3F4);
  static const Color MAIN_BLUE = Color(0xFF448AFF);
  static const Color GREEN = Colors.green;
  static const Color RED = Colors.red;
  static const Color BLACK_TRANSPARENT = Color(0x66000000);
  static const List<Color> BLACK_GRADIENT = [
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

  static const List<Color> DRESS_COLORS = [
    Colors.red,
    Colors.pink,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.lime,
    Colors.purple,
    Colors.black,
    Colors.grey,
    Colors.white
  ];

  static String getColorValue(String color) {
    return color.split('(0x')[1].split(')')[0];
  }

  static Color parseColor(String code) {
    int value = int.parse(code, radix: 16);
    return Color(value);
  }
}
