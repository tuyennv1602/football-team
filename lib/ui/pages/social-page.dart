import 'package:flutter/material.dart';
import 'package:myfootball/blocs/social-bloc.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';

class SocialPage extends BasePage<SocialBloc> {
  @override
  AppBarWidget buildAppBar(BuildContext context) => AppBarWidget(
        centerContent: Center(
          child: Text(
            'Cộng đồng',
            style: Theme.of(context).textTheme.title,
          ),
        ),
      );

  @override
  Widget buildLoading(BuildContext context) {
    // TODO: implement buildLoading
    return null;
  }

  @override
  Widget buildMainContainer(BuildContext context) {
    // TODO: implement buildMainContainer
    return null;
  }

  @override
  void listenAppData(BuildContext context) {
    // TODO: implement listenAppData
  }

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
