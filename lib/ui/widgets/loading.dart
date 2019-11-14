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
            ? RotationWidget(
                width: UIHelper.size50,
                height: UIHelper.size50,
                widget: Image.asset(
                  'assets/images/ic_loading.png',
                ),
              )
            : Image.asset(
                'assets/images/ic_loading.gif',
                width: UIHelper.size50,
                height: UIHelper.size50,
              ),
      );
}
