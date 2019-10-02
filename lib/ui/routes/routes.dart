import 'package:flutter/material.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/ui/pages/login/forgot_password_page.dart';
import 'package:myfootball/ui/pages/home_page.dart';
import 'package:myfootball/ui/pages/login/login_page.dart';
import 'package:myfootball/ui/pages/login/register_page.dart';
import 'package:myfootball/ui/pages/team/member_page.dart';
import 'package:myfootball/ui/pages/team/province_page.dart';
import 'package:myfootball/ui/pages/team/user_request_page.dart';
import 'package:myfootball/ui/pages/team/create-team-page.dart';
import 'package:myfootball/ui/pages/team/member_manager_page.dart';
import 'package:myfootball/ui/pages/team/request_member_page.dart';
import 'package:myfootball/ui/routes/fade-in-route.dart';
import 'package:myfootball/ui/routes/slide-left-route.dart';

class Routes {
  static routeToHome(BuildContext context) async {
    var page = HomePage();
    return await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        FadeInRoute(widget: page), (Route<dynamic> route) => false);
  }

  static routeToLogin(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        FadeInRoute(widget: LoginPage()), (Route<dynamic> route) => false);
  }

  static routeToForgotPassword(BuildContext context) async {
    return await Navigator.of(context)
        .push(SlideLeftRoute(widget: ForgotPasswordPage()));
  }

  static routeToRegister(BuildContext context) async {
    return await Navigator.of(context)
        .push(SlideLeftRoute(widget: RegisterPage()));
  }

  static routeToCreateGroup(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: CreateTeamPage()));
  }

  static routeToRequestMember(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: RequestMemberPage()));
  }

  static routeToUserRequest(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: UserRequestPage()));
  }

  static routeToMemberManager(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: MemberManagerPage()));
  }

  static routeToMember(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: MemberPage()));
  }

  static routeToProvinces(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: ProvincePage()));
  }
}
