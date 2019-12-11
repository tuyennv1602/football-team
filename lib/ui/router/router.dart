import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/model/fund.dart';
import 'package:myfootball/model/ground.dart';
import 'package:myfootball/model/invite_request.dart';
import 'package:myfootball/model/invite_team_arg.dart';
import 'package:myfootball/model/match_history.dart';
import 'package:myfootball/model/match_schedule.dart';
import 'package:myfootball/model/member.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/model/verify_arg.dart';
import 'package:myfootball/ui/page/home_page.dart';
import 'package:myfootball/ui/page/login/forgot_password_page.dart';
import 'package:myfootball/ui/page/login/login_page.dart';
import 'package:myfootball/ui/page/login/register_page.dart';
import 'package:myfootball/ui/page/login/verify_otp_page.dart';
import 'package:myfootball/ui/page/social/ranking_page.dart';
import 'package:myfootball/ui/page/team/add_address_page.dart';
import 'package:myfootball/ui/page/team/booking_page.dart';
import 'package:myfootball/ui/page/team/conversation_page.dart';
import 'package:myfootball/ui/page/team/create_team_page.dart';
import 'package:myfootball/ui/page/team/edit_team_page.dart';
import 'package:myfootball/ui/page/team/finance_page.dart';
import 'package:myfootball/ui/page/team/find_matching_page.dart';
import 'package:myfootball/ui/page/team/fund_request_page.dart';
import 'package:myfootball/ui/page/team/ground_detail_page.dart';
import 'package:myfootball/ui/page/team/invite_detail_page.dart';
import 'package:myfootball/ui/page/team/invite_request_page.dart';
import 'package:myfootball/ui/page/team/invite_team_page.dart';
import 'package:myfootball/ui/page/team/match_history_detail_page.dart';
import 'package:myfootball/ui/page/team/match_history_page.dart';
import 'package:myfootball/ui/page/team/match_schedulde_detail_page.dart';
import 'package:myfootball/ui/page/team/match_schedule_page.dart';
import 'package:myfootball/ui/page/team/member_detail_page.dart';
import 'package:myfootball/ui/page/team/member_page.dart';
import 'package:myfootball/ui/page/team/request_join_match_page.dart';
import 'package:myfootball/ui/page/team/team_comment_page.dart';
import 'package:myfootball/ui/page/team/team_detail_page.dart';
import 'package:myfootball/ui/page/team/request_member_page.dart';
import 'package:myfootball/ui/page/team/search_ground_page.dart';
import 'package:myfootball/ui/page/team/search_team_page.dart';
import 'package:myfootball/ui/page/team/setup_matching_info_page.dart';
import 'package:myfootball/ui/page/team/setup_team_page.dart';
import 'package:myfootball/ui/page/team/team_fund_page.dart';
import 'package:myfootball/ui/page/team/ticket_page.dart';
import 'package:myfootball/ui/page/team/user_request_page.dart';
import 'package:myfootball/ui/page/user/input_money_page.dart';
import 'package:myfootball/ui/page/user/transaction_history_page.dart';
import 'package:myfootball/ui/page/user/user_comment_page.dart';
import 'package:myfootball/ui/page/user/user_join_match_page.dart';
import 'package:myfootball/ui/router/fade_in_router.dart';
import 'package:myfootball/ui/router/slide_left_router.dart';
import 'package:myfootball/utils/router_paths.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HOME:
      return FadeInRoute(widget: HomePage());
    case TEAM_FUND:
      return SlideLeftRoute(widget: TeamFundPage());
    case LOGIN:
      return FadeInRoute(widget: LoginPage());
    case FORGOT_PASSWORD:
      return SlideLeftRoute(widget: ForgotPasswordPage());
    case REGISTER:
      return SlideLeftRoute(widget: RegisterPage());
    case CREATE_TEAM:
      return SlideLeftRoute(widget: CreateTeamPage());
    case USER_REQUESTS:
      return SlideLeftRoute(widget: UserRequestPage());
    case REQUEST_MEMBER:
      return SlideLeftRoute(widget: RequestMemberPage());
    case MEMBERS:
      var team = settings.arguments as Team;
      if (team != null) {
        return SlideLeftRoute(widget: MemberPage(team: team));
      }
      return SlideLeftRoute(widget: MemberPage());
    case FIND_MATCHING:
      return SlideLeftRoute(widget: FindMatchingPage());
    case SETUP_MATCHING:
      return SlideLeftRoute(widget: SetupMatchingInfoPage());
    case SETUP_ADDRESS:
      return SlideLeftRoute(widget: AddAddressPage());
    case SETUP_TEAM:
      return SlideLeftRoute(widget: SetupTeamPage());
    case SEARCH_TEAM:
      var type = settings.arguments as SEARCH_TYPE;
      return SlideLeftRoute(widget: SearchTeamPage(type: type));
    case EDIT_TEAM_INFO:
      return SlideLeftRoute(widget: EditTeamPage());
    case INVITE_TEAM:
      var inviteArg = settings.arguments as InviteTeamArgument;
      return SlideLeftRoute(
          widget: InviteTeamPage(inviteTeamArgument: inviteArg));
    case GROUND_DETAIL:
      int groundId = settings.arguments as int;
      return SlideLeftRoute(widget: GroundDetailPage(groundId: groundId));
    case SEARCH_GROUND:
      return SlideLeftRoute(widget: SearchGroundPage());
    case BOOKING:
      var ground = settings.arguments as Ground;
      return SlideLeftRoute(widget: BookingPage(ground: ground));
    case FINANCE:
      return SlideLeftRoute(widget: FinancePage());
    case INVITE_DETAIL:
      var invite = settings.arguments as InviteRequest;
      return SlideLeftRoute(widget: InviteDetailPage(inviteRequest: invite));
    case TEAM_DETAIL:
      var team = settings.arguments as Team;
      return SlideLeftRoute(widget: TeamDetailPage(team: team));
    case INPUT_MONEY:
      return SlideLeftRoute(widget: InputMoneyPage());
    case MATCH_SCHEDULE:
      return SlideLeftRoute(widget: MatchSchedulePage());
    case MATCH_HISTORY:
      return SlideLeftRoute(widget: MatchHistoryPage());
    case MATCH_HISTORY_DETAIL:
      var match = settings.arguments as MatchHistory;
      return SlideLeftRoute(
          widget: MatchHistoryDetailPage(matchHistory: match));
    case MATCH_SCHEDULE_DETAIL:
      var match = settings.arguments as MatchSchedule;
      return SlideLeftRoute(
          widget: MatchScheduleDetailPage(matchSchedule: match));
    case TICKETS:
      return SlideLeftRoute(widget: TicketPage());
    case INVITE_REQUESTS:
      return SlideLeftRoute(widget: InviteRequestPage());
    case USER_TRANSACTION_HISTORY:
      return SlideLeftRoute(widget: TransactionHistoryPage());
    case FUND_REQUEST:
      var fund = settings.arguments as Fund;
      return SlideLeftRoute(widget: FundRequestPage(fund: fund));
    case RANKING:
      var teams = settings.arguments as List<Team>;
      return SlideLeftRoute(
          widget: RankingPage(
        teams: teams,
      ));
    case VERIFY_OTP:
      var verify = settings.arguments as VerifyArgument;
      return SlideLeftRoute(widget: VerifyOTPPage(verifyArgument: verify));
    case TEAM_COMMENT:
      return SlideLeftRoute(widget: TeamCommentPage());
    case MEMBER_DETAIL:
      var member = settings.arguments as Member;
      return SlideLeftRoute(widget: MemberDetailPage(member: member));
    case USER_COMMENT:
      var userId = settings.arguments as int;
      return SlideLeftRoute(widget: UserCommentPage(userId: userId));
    case USER_JOIN_MATCH:
      return SlideLeftRoute(widget: UserJoinMatchPage());
    case REQUEST_JOIN_MATCH:
      var matchId = settings.arguments as int;
      return SlideLeftRoute(widget: RequestJoinMatchPage(matchId: matchId));
    case CONVERSATION:
      return SlideLeftRoute(widget: ConversationPage());
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text('No path for ${settings.name}'),
          ),
        ),
      );
  }
}
