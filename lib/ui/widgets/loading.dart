import 'package:flutter/material.dart';
import 'package:myfootball/ui/widgets/rotation_widget.dart';
import 'package:myfootball/utils/ui_helper.dart';

enum LOADING_TYPE { CIRCLE, WAVE }

class LoadingWidget extends StatelessWidget {
  final LOADING_TYPE type;

  LoadingWidget({Key key, this.type = LOADING_TYPE.CIRCLE}) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: type == LOADING_TYPE.CIRCLE
            ? Container(
                width: UIHelper.size(60),
                height: UIHelper.size(60),
                padding: EdgeInsets.all(UIHelper.size5),
                child: Image.asset('assets/images/ic_circle_loading.gif'),
              )
            : Image.asset(
                'assets/images/ic_loading.gif',
                width: UIHelper.size50,
                height: UIHelper.size50,
              ),
      );
}
