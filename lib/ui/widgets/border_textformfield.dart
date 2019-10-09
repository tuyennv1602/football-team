import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/fonts.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/utils/ui_helper.dart';

class BorderTextFormField extends StatelessWidget {
  final String initValue;
  final Function(String) validator;
  final bool obscureText;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final String errorText;
  final String labelText;
  final Function(String) onSaved;
  final TextStyle textStyle;

  BorderTextFormField(
      {Key key,
      this.initValue,
      this.validator,
      this.obscureText = false,
      this.inputType,
      this.inputAction,
      this.errorText,
      this.labelText,
      this.onSaved,
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      cursorColor: PRIMARY,
      cursorWidth: 1,
      maxLines: 1,
      initialValue: initValue,
      validator: validator,
      obscureText: obscureText,
      keyboardType: inputType ?? TextInputType.text,
      textInputAction: inputAction ?? TextInputAction.done,
      onSaved: onSaved,
      style: textStyle ?? textStyleInput(color: Colors.white),
      decoration: InputDecoration(
        helperText: ' ',
        contentPadding: EdgeInsets.symmetric(
            horizontal: UIHelper.size25, vertical: UIHelper.size(14)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0.5, color: Colors.white),
            borderRadius: BorderRadius.circular(UIHelper.size30)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0.5, color: Colors.red),
            borderRadius: BorderRadius.circular(UIHelper.size30)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.2, color: Colors.white),
            borderRadius: BorderRadius.circular(UIHelper.size30)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.2, color: Colors.white),
            borderRadius: BorderRadius.circular(UIHelper.size30)),
        errorText: errorText,
        labelText: labelText,
        counter: SizedBox(),
        errorStyle: TextStyle(
            fontFamily: REGULAR,
            color: Colors.red,
            fontSize: UIHelper.size(12)),
        labelStyle: textStyleInput(color: Colors.white),
      ),
    );
  }
}
