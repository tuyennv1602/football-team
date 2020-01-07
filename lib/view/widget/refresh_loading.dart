import 'package:flutter/material.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum REFRESH_TYPE { HORIZONTAL, VERTICAL }

class RefreshLoading extends StatelessWidget {
  final IconPosition iconPosition;
  final REFRESH_TYPE type;

  const RefreshLoading(
      {Key key,
      this.iconPosition = IconPosition.top,
      this.type = REFRESH_TYPE.VERTICAL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClassicHeader(
      iconPos: iconPosition,
      refreshingText: '',
      completeText: '',
      failedText: '',
      releaseText: '',
      canTwoLevelText: '',
      idleText: '',
      failedIcon: const Icon(Icons.error, color: Colors.red),
      completeIcon: const Icon(Icons.done, color: Colors.green),
      idleIcon: Icon(
          type == REFRESH_TYPE.HORIZONTAL
              ? Icons.arrow_forward
              : Icons.arrow_downward,
          color: Colors.grey),
      releaseIcon: const Icon(Icons.refresh, color: Colors.grey),
      refreshingIcon: LoadingWidget(size: UIHelper.size30),
      outerBuilder: (child) {
        return Container(
          width: UIHelper.size50,
          height: UIHelper.size50,
          child: Center(
            child: child,
          ),
        );
      },
    );
  }
}
