import 'package:flutter/material.dart';
import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:myfootball/ui/widgets/loading.dart';

class LoginPage extends BasePage {
  @override
  AppBarWidget buildAppBar(BuildContext context) {
    return null;
  }

  @override
  Widget buildLoading(BuildContext context) => LoadingWidget(
        show: true,
      );

  @override
  Widget buildMainContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_login.jpg'),
          fit: BoxFit.fill
        )
      ),
      child: InkWell(
        child: Text("LOGIN"),
        onTap: () => print("click"),
      ),
    );
  }

  @override
  BaseBloc createBloc() {
    return null;
  }

  @override
  bool showFullScreen() => true;
}
