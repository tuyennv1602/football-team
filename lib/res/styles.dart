import 'package:flutter/material.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'fonts.dart';

textStyleTitle({Color color}) => TextStyle(
    fontSize: UIHelper.size(18),
    fontFamily: SEMI_BOLD,
    color: color ?? Colors.white,
    letterSpacing: 0.1);

textStyleAppName({Color color}) => TextStyle(
    fontSize: UIHelper.size(25),
    fontFamily: BOLD,
    color: color ?? Colors.white,
    letterSpacing: 0.1);

textStyleButton({double size, Color color}) => TextStyle(
    fontSize: UIHelper.size(size ?? 16),
    fontFamily: MEDIUM,
    color: color ?? Colors.white,
    letterSpacing: 0.1);

textStyleItalic({double size, Color color}) => TextStyle(
    fontSize: UIHelper.size(size ?? 12),
    fontFamily: ITALIC,
    color: color ?? Colors.black,
    letterSpacing: 0.1);

textStyleRegular({double size, Color color}) => TextStyle(
    fontSize: UIHelper.size(size ?? 15),
    fontFamily: REGULAR,
    color: color ?? Colors.black87,
    letterSpacing: 0.1);

textStyleRegularTitle({double size, Color color}) => TextStyle(
    fontSize: UIHelper.size(size ?? 16),
    fontFamily: REGULAR,
    color: color ?? Colors.black,
    letterSpacing: 0.1);

textStyleRegularBody({double size, Color color}) => TextStyle(
    fontSize: UIHelper.size(size ?? 13),
    fontFamily: REGULAR,
    color: color ?? Colors.black87,
    letterSpacing: 0.1);

textStyleSemiBold({double size, Color color}) => TextStyle(
    fontSize: UIHelper.size(size ?? 16),
    fontFamily: SEMI_BOLD,
    color: color ?? Colors.black,
    letterSpacing: 0.1);

textStyleBold({double size, Color color}) => TextStyle(
    fontSize: UIHelper.size(size ?? 18),
    fontFamily: BOLD,
    color: color ?? Colors.black,
    letterSpacing: 0.1);

textStyleInput({double size, Color color}) => TextStyle(
    fontSize: UIHelper.size(size ?? 16),
    fontFamily: REGULAR,
    color: color ?? Colors.black,
    letterSpacing: 0.1);

textStyleAlert({double size, Color color}) => TextStyle(
    fontFamily: MEDIUM,
    fontSize: UIHelper.size(size ?? 18),
    color: color ?? Colors.white,
    letterSpacing: 0.1);
