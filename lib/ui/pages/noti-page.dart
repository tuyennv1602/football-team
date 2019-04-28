import 'package:myfootball/blocs/noti-bloc.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/ui/routes/routes.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';

class NotiPage extends BasePage<NotiBloc> {
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
    return Column(
      children: <Widget>[
        StreamBuilder<bool>(
          stream: pageBloc.notiStream,
          builder: (c, snap) =>
              Text((snap.hasData && snap.data) ? "Changed" : "Init"),
        ),
        InkWell(
          onTap: () => pageBloc.changeNotiFunc(true),
          child: Text("Change"),
        ),
        InkWell(
          onTap: () => Routes.routeToNotiDetailPage(context),
          child: Text("next page"),
        )
      ],
    );
  }

  @override
  void listenAppData(BuildContext context) {}

  @override
  void listenPageData(BuildContext context) {
    pageBloc.notiStream.listen((onData) {
      print(onData);
    });
  }

  @override
  bool resizeAvoidPadding() => null;

  @override
  bool showFullScreen() => false;
}
