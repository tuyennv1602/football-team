import 'package:flutter/material.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LoadMoreLoading extends StatelessWidget {
  final IconPosition iconPosition;

  const LoadMoreLoading({Key key, this.iconPosition = IconPosition.bottom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClassicFooter(
      loadingText: '',
      noDataText: '',
      failedText: '',
      canLoadingText: '',
      idleText: '',
      failedIcon: const Icon(Icons.error, color: Colors.red),
      iconPos: iconPosition,
      loadingIcon: LoadingWidget(size: UIHelper.size30),
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