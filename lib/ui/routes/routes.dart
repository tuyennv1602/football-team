import 'package:flutter/material.dart';
import 'package:myfootball/models/ground.dart';
import 'package:myfootball/models/invite_request.dart';
import 'package:myfootball/models/match_schedule.dart';
import 'package:myfootball/models/matching_time_slot.dart';
import 'package:myfootball/models/member.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/ui/pages/login/forgot_password_page.dart';
import 'package:myfootball/ui/pages/home_page.dart';
import 'package:myfootball/ui/pages/login/login_page.dart';
import 'package:myfootball/ui/pages/login/register_page.dart';
import 'package:myfootball/ui/pages/team/add_address_page.dart';
import 'package:myfootball/ui/pages/team/booking_page.dart';
import 'package:myfootball/ui/pages/team/compare_team_page.dart';
import 'package:myfootball/ui/pages/team/invite_detail_page.dart';
import 'package:myfootball/ui/pages/team/edit_team_page.dart';
import 'package:myfootball/ui/pages/team/finance_page.dart';
import 'package:myfootball/ui/pages/team/find_matching_page.dart';
import 'package:myfootball/ui/pages/team/ground_detail_page.dart';
import 'package:myfootball/ui/pages/team/invite_request_page.dart';
import 'package:myfootball/ui/pages/team/invite_team_page.dart';
import 'package:myfootball/ui/pages/team/match_history_page.dart';
import 'package:myfootball/ui/pages/team/match_schedule_page.dart';
import 'package:myfootball/ui/pages/team/match_detail_page.dart';
import 'package:myfootball/ui/pages/team/member_page.dart';
import 'package:myfootball/ui/pages/team/other_team_detail_page.dart';
import 'package:myfootball/ui/pages/team/search_ground_page.dart';
import 'package:myfootball/ui/pages/team/search_team_page.dart';
import 'package:myfootball/ui/pages/team/setup_matching_info_page.dart';
import 'package:myfootball/ui/pages/team/setup_team_page.dart';
import 'package:myfootball/ui/pages/team/team_fund_page.dart';
import 'package:myfootball/ui/pages/team/user_request_page.dart';
import 'package:myfootball/ui/pages/team/create_team_page.dart';
import 'package:myfootball/ui/pages/team/request_member_page.dart';
import 'package:myfootball/ui/pages/user/input_money_page.dart';
import 'package:myfootball/ui/routes/fade_in_route.dart';
import 'package:myfootball/ui/routes/slide_left_route.dart';

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

  static Future<dynamic> routeToCreateTeam(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: CreateTeamPage()));
  }

  static Future<dynamic> routeToUserRequest(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: UserRequestPage()));
  }

  static Future<dynamic> routeToRequestMember(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: RequestMemberPage()));
  }

  static Future<dynamic> routeToMember(
      BuildContext context, List<Member> members, int manageId) async {
    return await Navigator.of(context, rootNavigator: true).push(SlideLeftRoute(
        widget: MemberPage(
      members: members,
      managerId: manageId,
    )));
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

  static Future<dynamic> routeToSearchTeam(
      BuildContext context, SEARCH_TYPE type) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: SearchTeamPage(type: type)));
  }

  static Future<dynamic> routeToCompareTeam(
      BuildContext context, Team team) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: CompareTeamPage(team: team)));
  }

  static Future<dynamic> routeToEditTeam(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: EditTeamPage()));
  }

  static Future<dynamic> routeToInviteTeam(BuildContext context, int fromTeamId,
      int toTeamId, Map<int, List<MatchingTimeSlot>> mappedTimeSlots) async {
    return await Navigator.of(context).push(SlideLeftRoute(
        widget: InviteTeamPage(
      mappedTimeSlots: mappedTimeSlots,
      fromTeamId: fromTeamId,
      toTeamId: toTeamId,
    )));
  }

  static Future<dynamic> routeToGroundDetail(
      BuildContext context, int groundId) async {
    return await Navigator.of(context).push(SlideLeftRoute(
        widget: GroundDetailPage(
      groundId: groundId,
    )));
  }

  static Future<dynamic> routeToSearchGround(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: SearchGroundPage()));
  }

  static Future<dynamic> routeToBooking(
      BuildContext context, Ground ground) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: BookingPage(ground: ground)));
  }

  static Future<dynamic> routeToTeamFund(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: TeamFundPage()));
  }

  static Future<dynamic> routeToFinance(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: FinancePage()));
  }

  static Future<dynamic> routeToInviteRequest(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: InviteRequestPage()));
  }

  static Future<dynamic> routeToConfirmInvite(
      BuildContext context, InviteRequest inviteRequest) async {
    return await Navigator.of(context, rootNavigator: true).push(
        SlideLeftRoute(widget: InviteDetailPage(inviteRequest: inviteRequest)));
  }

  static Future<dynamic> routeToOtherTeamDetail(
      BuildContext context, Team team) async {
    return await Navigator.of(context, rootNavigator: true).push(SlideLeftRoute(
        widget: OtherTeamDetailPage(
      team: team,
    )));
  }

  static Future<dynamic> routeToInputMoney(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: InputMoneyPage()));
  }

  static Future<dynamic> routeToMatchSchedule(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: MatchSchedulePage()));
  }

  static Future<dynamic> routeToMatchHistory(BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true)
        .push(SlideLeftRoute(widget: MatchHistoryPage()));
  }

  static Future<dynamic> routeToMatchDetail(
      BuildContext context, MatchSchedule matchSchedule) async {
    return await Navigator.of(context, rootNavigator: true).push(SlideLeftRoute(
        widget: MatchDetailPage(
      matchSchedule: matchSchedule,
    )));
  }
}
