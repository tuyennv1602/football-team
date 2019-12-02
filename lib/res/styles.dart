import 'package:flutter/material.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'fonts.dart';

textStyleTitle({Color color}) => TextStyle(
    fontSize: UIHelper.size(19),
    fontFamily: SEMI_BOLD,
    color: color ?? Colors.white,
    letterSpacing: 0.1);

textStyleAppName({Color color}) => TextStyle(
    fontSize: UIHelper.size(26),
    fontFamily: BOLD,
    color: color ?? Colors.white,
    letterSpacing: 0.1);

textStyleButton({double size, Color color}) => TextStyle(
    fontSize: UIHelper.size(size ?? 17),
    fontFamily: MEDIUM,
    color: color ?? Colors.white,
    letterSpacing: 0.1);

textStyleItalic({double size, Color color}) => TextStyle(
    fontSize: UIHelper.size(size ?? 13),
    fontFamily: ITALIC,
    color: color ?? Colors.black,
    letterSpacing: 0.1);

textStyleRegular({double size, Color color}) => TextStyle(
    fontSize: UIHelper.size(size ?? 16),
    fontFamily: REGULAR,
    color: color ?? Colors.black87,
    letterSpacing: 0.1);

textStyleMediumTitle({double size, Color color}) => TextStyle(
    fontSize: UIHelper.size(size ?? 17),
    fontFamily: MEDIUM,
    color: color ?? Colors.black,
    letterSpacing: 0.1);

textStyleRegularBody({double size, Color color}) => TextStyle(
    fontSize: UIHelper.size(size ?? 14),
    fontFamily: REGULAR,
    color: color ?? Colors.black87,
    letterSpacing: 0.1);

textStyleSemiBold({double size, Color color}) => TextStyle(
    fontSize: UIHelper.size(size ?? 17),
    fontFamily: SEMI_BOLD,
    color: color ?? Colors.black,
    letterSpacing: 0.1);

textStyleBold({double size, Color color}) => TextStyle(
    fontSize: UIHelper.size(size ?? 19),
    fontFamily: BOLD,
    color: color ?? Colors.black,
    letterSpacing: 0.1);

textStyleInput({double size, Color color}) => TextStyle(
    fontSize: UIHelper.size(size ?? 17),
    fontFamily: REGULAR,
    color: color ?? Colors.black,
    letterSpacing: 0.1);

textStyleAlert({double size, Color color}) => TextStyle(
    fontFamily: MEDIUM,
    fontSize: UIHelper.size(size ?? 18),
    color: color ?? Colors.white,
    letterSpacing: 0.1);

textStyleMedium({double size, Color color}) => TextStyle(
    fontFamily: MEDIUM,
    fontSize: UIHelper.size(size ?? 16),
    color: color ?? Colors.black,
    letterSpacing: 0.1);

