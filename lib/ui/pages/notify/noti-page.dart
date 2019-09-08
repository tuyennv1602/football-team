import 'package:myfootball/blocs/noti-bloc.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/ui/routes/routes.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';

// ignore: must_be_immutable
class NotiPage extends BasePage<NotiBloc> {
  @override
  AppBarWidget buildAppBar(BuildContext context) {
    return AppBarWidget(
      centerContent: Text(
        "Thông báo",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.title,
      ),
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
          builder: (c, snap) => Text((snap.hasData && snap.data) ? "Changed" : "Init"),
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
  void listenData(BuildContext context) {
    pageBloc.notiStream.listen((onData) {});
  }

  @override
  bool get hasBottomBar => true;
}
