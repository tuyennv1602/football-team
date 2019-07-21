import 'package:flutter/material.dart';
import 'package:myfootball/blocs/noti-bloc.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';

class NotiDetailPage extends BasePage<NotiBloc> {
  @override
  AppBarWidget buildAppBar(BuildContext context) {
    return AppBarWidget(
      centerContent: Text("data"),
    );
  }

  @override
  Widget buildLoading(BuildContext context) {
    return null;
  }

  @override
  Widget buildMainContainer(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () => Navigator.of(context).pop(),
        child: Text("back"),
      ),
    );
  }

  @override
  void listenData(BuildContext context) {}
}
