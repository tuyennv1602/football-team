import 'package:flutter/material.dart';
import 'package:myfootball/ui/widgets/rotation_widget.dart';
import 'package:myfootball/utils/ui-helper.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: RotationWidget(
          width: UIHelper.size50,
          height: UIHelper.size50,
          widget: Image.asset(
            'assets/images/icn_loading.png',
          ),
        ),
      );
}
