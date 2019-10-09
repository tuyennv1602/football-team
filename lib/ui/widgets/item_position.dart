import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/utils/ui_helper.dart';

class ItemPosition extends StatelessWidget {
  final String _position;

  ItemPosition({@required String position}) : _position = position;

  @override
  Widget build(BuildContext context) {
    Color _color;
    switch (_position) {
      case 'FW':
        _color = FW;
        break;
      case 'MF':
        _color = MF;
        break;
      case 'DF':
        _color = DF;
        break;
      case 'GK':
        _color = GK;
        break;
    }
    return Container(
      height: UIHelper.size20,
      decoration: BoxDecoration(
          color: _color, borderRadius: BorderRadius.circular(UIHelper.size10)),
      padding: EdgeInsets.symmetric(horizontal: UIHelper.size(7)),
      margin: EdgeInsets.only(
          right: UIHelper.size5,
          top: UIHelper.size(3),
          bottom: UIHelper.size(3)),
      child: Text(
        _position,
        style: textStyleRegular(color: Colors.white),
      ),
    );
  }
}
