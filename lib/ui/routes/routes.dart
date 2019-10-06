import 'package:flutter/material.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/ui/pages/login/forgot_password_page.dart';
import 'package:myfootball/ui/pages/home_page.dart';
import 'package:myfootball/ui/pages/login/login_page.dart';
import 'package:myfootball/ui/pages/login/register_page.dart';
import 'package:myfootball/ui/pages/team/add_address_page.dart';
import 'package:myfootball/ui/pages/team/compare_team_page.dart';
import 'package:myfootball/ui/pages/team/find_matching_page.dart';
import 'package:myfootball/ui/pages/team/member_page.dart';
import 'package:myfootball/ui/pages/team/province_page.dart';
import 'package:myfootball/ui/pages/team/search_team_page.dart';
import 'package:myfootball/ui/pages/team/setup_matching_info_page.dart';
import 'package:myfootball/ui/pages/team/setup_team_page.dart';
import 'package:myfootball/ui/pages/team/user_request_page.dart';
import 'package:myfootball/ui/pages/team/create-team-page.dart';
import 'package:myfootball/ui/pages/team/member_manager_page.dart';
import 'package:myfootball/ui/pages/team/request_member_page.dart';
import 'package:myfootball/ui/routes/fade-in-route.dart';
import 'package:myfootball/ui/routes/slide-left-route.dart';

class Routes {
  static Future<dynamic> routeToHome(BuildContext context) async {
    var page = HomePage();
    return await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        FadeInRoute(widget: page), (Route<dynamic> route) => false);
  }

  static Future<dynamic> routeToLogin(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        FadeInRoute(widget: LoginPage()), (Route<dynamic> route) => false);
  }

  static Future<dynamic> routeToForgotPassword(BuildContext context) async {
    return await Navigator.of(context)
        .push(SlideLeftRoute(widget: ForgotPasswordPage()));
  }

  static Future<dynamic> routeToRegister(BuildContext context) async {
    return await Navigator.of(context)
        .push(SlideLeftRoute(widget: RegisterPage()));
  }

  static Future<dynamic> routeToCreateGroup(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: CreateTeamPage()));
  }

  static Future<dynamic> routeToRequestMember(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: RequestMemberPage()));
  }

  static Future<dynamic> routeToUserRequest(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: UserRequestPage()));
  }

  static Future<dynamic> routeToMemberManager(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: MemberManagerPage()));
  }

  static Future<dynamic> routeToMember(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: MemberPage()));
  }

  static Future<dynamic> routeToProvinces(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: ProvincePage()));
  }

  static Future<dynamic> routeToFindMatching(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: FindMatchingPage()));
  }

  static Future<dynamic> routeToSetupMatchingInfo(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: SetupMatchingInfoPage()));
  }

  static Future<dynamic> routeToSetupAddAddress(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: AddAddressPage()));
  }

  static Future<dynamic> routeToSetupTeam(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: SetupTeamPage()));
  }

  static Future<dynamic> routeToSearchTeam(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: SearchTeamPage()));
  }

  static Future<dynamic> routeToCompareTeam(
      BuildContext context, Team team) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: CompareTeamPage(team: team)));
  }
}
