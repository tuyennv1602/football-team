import 'package:flutter/material.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/utils/ui_helper.dart';

class StatusIndicator extends StatelessWidget {
  final String status;
  final bool isActive;

  StatusIndicator({Key key, this.isActive, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: UIHelper.size10,
          height: UIHelper.size10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(UIHelper.size5),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: isActive
                    ? [
                        Color(0xFF04F13D),
                        Color(0xFF02DC37),
                        Color(0xFF02DC37),
                        Color(0xFF04F13D)
                      ]
                    : [
                        Color(0xFFE8E8E8),
                        Color(0xFFD8D8D8),
                        Color(0xFFD8D8D8),
                        Color(0xFFE8E8E8)
                      ]),
            boxShadow: [
              BoxShadow(
                  color: isActive ? SHADOW_GREEN : SHADOW_GREY,
                  offset: Offset(0, 0),
                  blurRadius: UIHelper.size5,
                  spreadRadius: 2)
            ],
          ),
        ),
        status == null
            ? SizedBox()
            : Padding(
                padding: EdgeInsets.only(left: UIHelper.size10),
                child: Text(
                  status,
                  style: textStyleMedium(
                      size: 14, color: isActive ? GREEN_TEXT : Colors.grey),
                ),
              ),
      ],
    );
  }
}
