import 'package:flutter/material.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/utils/ui_helper.dart';

enum LOADING_TYPE { CIRCLE, WAVE }

class LoadingWidget extends StatelessWidget {
  final LOADING_TYPE type;
  final double size;

  LoadingWidget({Key key, this.type = LOADING_TYPE.CIRCLE, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: type == LOADING_TYPE.CIRCLE
            ? Container(
                width: size ?? UIHelper.size50,
                height: size ?? UIHelper.size50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: GREY_BACKGROUND,
                  image: DecorationImage(
                    image: AssetImage('assets/images/ic_circle_loading.gif'),
                  ),
                ),
              )
            : Image.asset(
                'assets/images/ic_loading.gif',
                width: size ?? UIHelper.size50,
                height: size ?? UIHelper.size50,
              ),
      );
}
