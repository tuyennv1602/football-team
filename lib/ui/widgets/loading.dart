import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/ui/widgets/rotation-widget.dart';

class LoadingWidget extends StatelessWidget {
  final bool show;
  LoadingWidget({Key key, this.show = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (show) {
      FocusScope.of(context).requestFocus(new FocusNode());
    }
    return show
        ? Stack(
            children: [
              ModalBarrier(dismissible: false, color: BLACK_TRANSPARENT,),
              Center(
                child: RotationWidget(
                  widget: Image.asset('assets/images/icn_loading.png'),
                ),
              ),
            ],
          )
        : SizedBox();
  }
}
