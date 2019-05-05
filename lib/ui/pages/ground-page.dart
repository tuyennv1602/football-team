import 'package:flutter/material.dart';
import 'package:myfootball/blocs/ground-bloc.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';

class GroundPage extends BasePage<GroundBloc> {
  @override
  AppBarWidget buildAppBar(BuildContext context) => AppBarWidget(
        centerContent: Center(
          child: Text(
            'Quản lý sân bóng',
            style: Theme.of(context).textTheme.title,
          ),
        ),
      );

  @override
  Widget buildLoading(BuildContext context) {
    return null;
  }

  @override
  Widget buildMainContainer(BuildContext context) {
    return Container(
      child: Text("ground"),
    );
  }

  @override
  void listenAppData(BuildContext context) {}

  @override
  void listenPageData(BuildContext context) {
    // TODO: implement listenPageData
  }

  @override
  bool resizeAvoidPadding() {
    // TODO: implement resizeAvoidPadding
    return null;
  }

  @override
  bool showFullScreen() {
    // TODO: implement showFullScreen
    return null;
  }
}
