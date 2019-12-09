import 'package:flutter/material.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshLoading extends StatelessWidget {
  final IconPosition iconPosition;
  final Widget idleIcon;

  const RefreshLoading(
      {Key key,
      this.iconPosition = IconPosition.top,
      this.idleIcon = const Icon(Icons.arrow_downward, color: Colors.grey)})
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
      idleIcon: idleIcon,
      releaseIcon: const Icon(Icons.refresh, color: Colors.grey),
      refreshingIcon: Image.asset(
        'assets/images/ic_circle_loading.gif',
        width: UIHelper.size30,
        height: UIHelper.size30,
      ),
      outerBuilder: (child) {
        return Container(
          width: UIHelper.size50,
          child: Center(
            child: child,
          ),
        );
      },
    );
  }
}
