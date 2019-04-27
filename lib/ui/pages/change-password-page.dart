import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends BasePage {
  @override
  AppBarWidget buildAppBar(BuildContext context) {
    return null;
  }

  @override
  Widget buildLoading(BuildContext context) {
    return null;
  }

  @override
  Widget buildMainContainer(BuildContext context) {
    return Container(
      child: Text("data"),
    );
  }

  @override
  void listenPageData(BuildContext context) {}

  @override
  bool showFullScreen() {
    return null;
  }

  @override
  void listenAppData(BuildContext context) {}
}
