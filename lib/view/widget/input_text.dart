import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/utils/ui_helper.dart';

class InputText extends StatelessWidget {
  final String initValue;
  final Function(String) validator;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final String errorText;
  final String labelText;
  final Function(String) onSaved;
  final TextStyle textStyle;
  final TextStyle hintTextStyle;
  final int maxLines;
  final int maxLength;
  final List<TextInputFormatter> formatter;
  final Color focusedColor;
  final bool obscureText;

  InputText(
      {Key key,
      this.initValue,
      this.validator,
      this.inputType,
      this.inputAction,
      this.errorText,
      this.labelText,
      this.onSaved,
      this.obscureText = false,
      this.maxLines = 1,
      this.maxLength = 200,
      this.hintTextStyle,
      this.formatter,
      this.focusedColor = PRIMARY,
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      cursorColor: focusedColor,
      cursorWidth: 1,
      maxLines: maxLines,
      maxLength: maxLength,
      initialValue: initValue,
      validator: validator,
      keyboardType: inputType ?? TextInputType.text,
      textInputAction: inputAction ?? TextInputAction.done,
      onSaved: onSaved,
      obscureText: obscureText,
      style: textStyle ?? textStyleInput(),
      inputFormatters: formatter,
      decoration: InputDecoration(
        helperText: '',
        contentPadding: EdgeInsets.symmetric(vertical: UIHelper.size(7)),
        alignLabelWithHint: maxLines > 1,
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 0.5, color: Colors.grey)),
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 0.5, color: Colors.red)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 1.2, color: focusedColor)),
        focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 1.2, color: focusedColor)),
        labelText: labelText,
        errorText: errorText,
        counter: SizedBox(),
        errorStyle: textStyleItalic(size: 12, color: Colors.red),
        labelStyle: hintTextStyle ?? textStyleInput(color: Colors.grey),
      ),
    );
  }
}