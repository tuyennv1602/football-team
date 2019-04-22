import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';

typedef void OnChangedText(String text);
typedef void OnSubmitText(String text);
typedef void OnValidator(String text);

class InputWidget extends StatefulWidget {
  final String labelText;
  final String initValue;
  final String errorText;
  final bool obscureText;
  final OnChangedText onChangedText;
  final OnSubmitText onSubmitText;
  final OnValidator validator;
  final TextInputType inputType;
  final TextInputAction inputAction;

  InputWidget(
      {this.labelText,
      this.obscureText,
      @required this.onChangedText,
      this.validator,
      this.initValue,
      this.inputAction,
      this.inputType,
      this.errorText,
      this.onSubmitText});

  @override
  State<StatefulWidget> createState() => InputState();
}

class InputState extends State<InputWidget> {
  TextEditingController _controller = new TextEditingController();
  FocusNode _textFocus = new FocusNode();

  @override
  void initState() {
    super.initState();
    _textFocus.addListener(onChange);
    _controller.addListener(onChange);
  }

  void onChange() {
    String text = _controller.text;
    if (_textFocus.hasFocus) {
      widget.onChangedText(text);
    }
    _controller.selection =
        new TextSelection(baseOffset: text.length, extentOffset: text.length);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: AppColor.GREEN,
      cursorWidth: 1,
      style: TextStyle(
          fontFamily: 'regular',
          fontSize: 16,
          color: AppColor.MAIN_BLACK,
          letterSpacing: 0.15),
      initialValue: widget.initValue,
      controller: _controller,
      focusNode: _textFocus,
      validator: widget.validator,
      onFieldSubmitted: widget.onSubmitText,
      obscureText: widget.obscureText ?? false,
      keyboardType: widget.inputType,
      textInputAction: widget.inputAction,
      decoration: InputDecoration(
        border: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: AppColor.LINE_COLOR),
        ),
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.red)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: AppColor.GREEN),
        ),
        labelText: widget.labelText,
        errorText: widget.errorText,
        errorStyle:
            TextStyle(fontFamily: 'regular', color: Colors.red, fontSize: 15),
        labelStyle: TextStyle(
            fontFamily: 'regular', color: AppColor.SECOND_BLACK, fontSize: 15),
      ),
    );
  }
}
