import 'package:flutter/material.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/ui_helper.dart';

class EmptyWidget extends StatelessWidget {
  final String _message;

  EmptyWidget({@required String message}) : _message = message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/images/ic_empty.gif',
          width: UIHelper.size(150),
          height: UIHelper.size(150),
        ),
        Text(
          _message,
          style: textStyleMediumTitle(color: Colors.grey),
        ),
        SizedBox(height: UIHelper.size50)
      ],
    );
  }
}
