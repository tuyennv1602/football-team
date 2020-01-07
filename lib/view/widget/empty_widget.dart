import 'package:flutter/material.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/ui_helper.dart';

class EmptyWidget extends StatelessWidget {
  final String _message;
  final double size;

  EmptyWidget({@required String message, this.size = 80}) : _message = message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: UIHelper.size50),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/ic_empty.gif',
            width: UIHelper.size(size),
            height: UIHelper.size(size),
            fit: BoxFit.cover,
          ),
          Text(
            _message,
            style: textStyleRegular(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
