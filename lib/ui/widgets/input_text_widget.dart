import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/fonts.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/utils/ui_helper.dart';

class InputTextWidget extends StatelessWidget {
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

  InputTextWidget(
      {Key key,
      this.initValue,
      this.validator,
      this.inputType,
      this.inputAction,
      this.errorText,
      this.labelText,
      this.onSaved,
      this.maxLines = 1,
      this.maxLength = 200,
      this.hintTextStyle,
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      cursorColor: PRIMARY,
      cursorWidth: 1,
      maxLines: maxLines,
      maxLength: maxLength,
      initialValue: initValue,
      validator: validator,
      keyboardType: inputType ?? TextInputType.text,
      textInputAction: inputAction ?? TextInputAction.done,
      onSaved: onSaved,
      style: textStyle ?? textStyleInput(),
      decoration: InputDecoration(
        helperText: '',
        contentPadding: EdgeInsets.symmetric(vertical: UIHelper.size5),
        alignLabelWithHint: maxLines > 1,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: LINE_COLOR),
        ),
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 0.5, color: Colors.red)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1.2, color: PRIMARY),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1.2, color: PRIMARY),
        ),
        labelText: labelText,
        errorText: errorText,
        counter: SizedBox(),
        errorStyle: TextStyle(
            fontFamily: REGULAR,
            color: Colors.red,
            fontSize: UIHelper.size(12)),
        labelStyle: hintTextStyle ?? textStyleInput(color: Colors.grey),
      ),
    );
  }
}
