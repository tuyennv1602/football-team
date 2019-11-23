import 'package:flutter/material.dart';
import 'package:myfootball/res/fonts.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/utils/ui_helper.dart';

class LightInputTextWidget extends StatelessWidget {
  final String initValue;
  final Function(String) validator;
  final bool obscureText;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final String errorText;
  final String labelText;
  final Function(String) onSaved;
  final TextStyle textStyle;
  final int maxLines;

  LightInputTextWidget(
      {Key key,
      this.initValue,
      this.validator,
      this.obscureText = false,
      this.inputType,
      this.inputAction,
      this.errorText,
      this.labelText,
      this.onSaved,
      this.maxLines = 1,
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      cursorColor: Colors.white,
      cursorWidth: 1,
      maxLines: maxLines,
      initialValue: initValue,
      validator: validator,
      obscureText: obscureText,
      keyboardType: inputType ?? TextInputType.text,
      textInputAction: inputAction ?? TextInputAction.done,
      onSaved: onSaved,
      style: textStyle ?? textStyleInput(color: Colors.white),
      decoration: InputDecoration(
        helperText: '',
        alignLabelWithHint: maxLines > 1,
        contentPadding: EdgeInsets.all(UIHelper.size15),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0.5, color: Colors.white),
            borderRadius: BorderRadius.circular(UIHelper.size10)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0.5, color: Colors.red),
            borderRadius: BorderRadius.circular(UIHelper.size10)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.white),
            borderRadius: BorderRadius.circular(UIHelper.size10)),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.white),
          borderRadius: BorderRadius.circular(UIHelper.size10),
        ),
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
