import 'package:myfootball/blocs/user-bloc.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/ui/widgets/loading.dart';

class UserPage extends BasePage<UserBloc> {
  @override
  AppBarWidget buildAppBar(BuildContext context) {
    return AppBarWidget(
      centerContent: Text("User"),
    );
  }

  @override
  Widget buildLoading(BuildContext context) {
    return LoadingWidget(
      show: false,
    );
  }

  @override
  Widget buildMainContainer(BuildContext context) {
    return Container(
      child: Text("User"),
    );
  }

  @override
  void listenAppData(BuildContext context) {}

  @override
  void listenPageData(BuildContext context) {}

  @override
  bool resizeAvoidPadding() => null;

  @override
  bool showFullScreen() => false;
}
