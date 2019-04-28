import 'package:myfootball/blocs/noti-bloc.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';

class NotiPage extends BasePage<NotiBloc>{
  @override
  AppBarWidget buildAppBar(BuildContext context) {
    return AppBarWidget(
      centerContent: Text("Noti"),
    );
  }

  @override
  Widget buildLoading(BuildContext context) {
    return null;
  }

  @override
  Widget buildMainContainer(BuildContext context) {
    return Container(
      child: Text("Noti"),
    );
  }

  @override
  void listenAppData(BuildContext context) {
  }

  @override
  void listenPageData(BuildContext context) {
  }

  @override
  bool resizeAvoidPadding() => null;

  @override
  bool showFullScreen() => false;

}