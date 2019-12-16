import 'package:flutter/material.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/utils/ui_helper.dart';

enum LOADING_TYPE { CIRCLE, WAVE }

class LoadingWidget extends StatelessWidget {
  final LOADING_TYPE type;

  LoadingWidget({Key key, this.type = LOADING_TYPE.CIRCLE}) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: type == LOADING_TYPE.CIRCLE
            ? Container(
                width: UIHelper.size50,
                height: UIHelper.size50,
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
                width: UIHelper.size50,
                height: UIHelper.size50,
              ),
      );
}
