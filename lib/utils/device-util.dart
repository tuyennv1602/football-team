import 'package:flutter/material.dart';

class DeviceUtil {
  static double width;
  static double height;
  static double paddingTop;
  static double paddingBottom;

  static double getHeight(BuildContext context) {
    if (height == null) {
      height = MediaQuery.of(context).size.height;
    }
    return height;
  }

  static double getWidth(BuildContext context) {
    if (width == null) {
      width = MediaQuery.of(context).size.width;
    }
    return width;
  }

  static double getPaddingTop(BuildContext context) {
    if (paddingTop == null) {
      paddingTop = MediaQuery.of(context).viewPadding.top;
    }
    return paddingTop;
  }

  static double getPaddingBottom(BuildContext context) {
    if (paddingBottom == null) {
      paddingBottom = MediaQuery.of(context).viewPadding.bottom;
    }
    return paddingBottom;
  }
}
