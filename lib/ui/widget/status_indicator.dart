import 'package:flutter/material.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/utils/ui_helper.dart';

enum Status { PENDING, DONE, NEW, ABORTED, FAILED }

class StatusIndicator extends StatelessWidget {
  final Status status;
  final String statusName;

  StatusIndicator({Key key, this.statusName, @required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    if (status == Status.DONE) {
      color = Colors.green;
    }
    if (status == Status.PENDING) {
      color = Colors.amber;
    }
    if (status == Status.NEW) {
      color = Colors.orange;
    }
    if (status == Status.ABORTED) {
      color = Colors.grey;
    }
    if(status == Status.FAILED){
      color = Colors.red;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: UIHelper.size(8),
          height: UIHelper.size(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(UIHelper.size(4)),
              color: color),
        ),
        statusName == null
            ? SizedBox()
            : Padding(
                padding: EdgeInsets.only(left: UIHelper.size5),
                child: Text(
                  statusName,
                  style: textStyleMedium(size: 13, color: Colors.black45),
                ),
              ),
      ],
    );
  }
}
