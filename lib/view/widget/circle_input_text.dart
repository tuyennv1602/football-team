import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/ui_helper.dart';

class CircleInputText extends StatelessWidget {
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
  final List<TextInputFormatter> formatter;

  CircleInputText(
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
      this.formatter,
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      cursorColor: PRIMARY,
      cursorWidth: 1,
      maxLines: maxLines,
      initialValue: initValue,
      validator: validator,
      obscureText: obscureText,
      keyboardType: inputType ?? TextInputType.text,
      textInputAction: inputAction ?? TextInputAction.done,
      onSaved: onSaved,
      style: textStyle ?? textStyleInput(),
      inputFormatters: formatter,
      decoration: InputDecoration(
        helperText: '',
        alignLabelWithHint: maxLines > 1,
        contentPadding: EdgeInsets.symmetric(vertical: UIHelper.size(14), horizontal: UIHelper.size25),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0.5, color: Colors.grey),
            borderRadius: BorderRadius.circular(UIHelper.size(24))),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0.5, color: Colors.red),
            borderRadius: BorderRadius.circular(UIHelper.size(24))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: PRIMARY),
            borderRadius: BorderRadius.circular(UIHelper.size(24))),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: PRIMARY),
            borderRadius: BorderRadius.circular(UIHelper.size(24))),
        errorText: errorText,
        labelText: labelText,
        counter: SizedBox(),
        errorStyle: textStyleItalic(size: 12, color: Colors.red),
        labelStyle: textStyleInput(color: Colors.grey),
      ),
    );
  }
}
