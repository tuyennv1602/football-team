import 'package:flutter/material.dart';
import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/blocs/forgot-password-bloc.dart';
import 'package:myfootball/blocs/login-bloc.dart';
import 'package:myfootball/blocs/noti-bloc.dart';
import 'package:myfootball/blocs/register-bloc.dart';
import 'package:myfootball/models/user.dart';
import 'package:myfootball/ui/pages/forgot-password-page.dart';
import 'package:myfootball/ui/pages/home-page.dart';
import 'package:myfootball/ui/pages/login-page.dart';
import 'package:myfootball/ui/pages/noti-detail-page.dart';
import 'package:myfootball/ui/pages/register-page.dart';
import 'package:myfootball/ui/routes/fade-in-route.dart';
import 'package:myfootball/ui/routes/slide-left-route.dart';

class Routes {
  static routeToHomePage(BuildContext context, User user) async {
    var page = HomePage(user);
    return await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        FadeInRoute(widget: page), (Route<dynamic> route) => false);
  }

  static routeToLoginPage(BuildContext context) async {
    var page = BlocProvider<LoginBloc>(
      bloc: LoginBloc(),
      child: LoginPage(),
    );
    return await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        FadeInRoute(widget: page), (Route<dynamic> route) => false);
  }

  static routeToForgotPasswordPage(BuildContext context) async {
    var page = BlocProvider<ForgotPasswordBloc>(
      bloc: ForgotPasswordBloc(),
      child: ForgotPasswordPage(),
    );
    return await Navigator.of(context).push(SlideLeftRoute(widget: page));
  }

  static routeToRegisterPage(BuildContext context) async {
    var page = BlocProvider<RegisterBloc>(
      bloc: RegisterBloc(),
      child: RegisterPage(),
    );
    return await Navigator.of(context).push(SlideLeftRoute(widget: page));
  }

  static routeToNotiDetailPage(BuildContext context) async {
    var page = BlocProvider<NotiBloc>(
      bloc: NotiBloc(),
      child: NotiDetailPage(),
    );
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: page));
  }
}
