import 'package:flutter/material.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/utils/ui-helper.dart';

class EmptyWidget extends StatelessWidget {
  final String _message;

  EmptyWidget({@required String message}) : _message = message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Image.asset(
          'assets/images/icn_empty.png',
          width: UIHelper.size50,
          height: UIHelper.size50,
        ),
        UIHelper.verticalSpaceMedium,
        Text(
          _message,
          style: textStyleRegular(),
        )
      ],
    );
  }
}
