import 'package:flutter/material.dart';
import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/blocs/forgot-password-bloc.dart';
import 'package:myfootball/blocs/register-bloc.dart';
import 'package:myfootball/ui/pages/change-password-page.dart';
import 'package:myfootball/ui/pages/forgot-password-page.dart';
import 'package:myfootball/ui/pages/register-page.dart';
import 'package:myfootball/ui/routes/slide-left-route.dart';

class Routes {
  // static routeToHomePage(BuildContext context) async {
  //   var page = HomePage();
  //   return await Navigator.of(context).pushAndRemoveUntil(
  //       FadeInRoute(widget: page), (Route<dynamic> route) => false);
  // }

  // static routeToSplashPage(BuildContext context) async {
  //   var page = SplashPage();
  //   return await Navigator.of(context).pushAndRemoveUntil(
  //       FadeInRoute(widget: page), (Route<dynamic> route) => false);
  // }

  static routeToForgotPasswordPage(BuildContext context) async {
    var page = BlocProvider<ForgotPasswordBloc>(
      bloc: ForgotPasswordBloc(),
      child: ForgotPasswordPage(),
    );
    return await Navigator.of(context).push(SlideLeftRoute(widget: page));
  }

  static routeToChangePasswordPage(BuildContext context) async {
    var page = ChangePasswordPage();
    return await Navigator.of(context).push(SlideLeftRoute(widget: page));
  }

  static routeToRegisterPage(BuildContext context) async {
    var page = BlocProvider<RegisterBloc>(
      bloc: RegisterBloc(),
      child: RegisterPage(),
    );
    return await Navigator.of(context).push(SlideLeftRoute(widget: page));
  }
}