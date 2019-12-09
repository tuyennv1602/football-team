import 'package:dio/dio.dart';
import 'package:myfootball/model/device_info.dart';
import 'package:myfootball/model/group_matching_info.dart';
import 'package:myfootball/model/invite_request.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/model/response/comments_resp.dart';
import 'package:myfootball/model/response/create_code_resp.dart';
import 'package:myfootball/model/response/create_matching_resp.dart';
import 'package:myfootball/model/response/fund_request_resp.dart';
import 'package:myfootball/model/response/fund_resp.dart';
import 'package:myfootball/model/response/ground_resp.dart';
import 'package:myfootball/model/response/invite_request_resp.dart';
import 'package:myfootball/model/response/list_ground_resp.dart';
import 'package:myfootball/model/response/login_resp.dart';
import 'package:myfootball/model/response/match_history_resp.dart';
import 'package:myfootball/model/response/match_schedule_resp.dart';
import 'package:myfootball/model/response/match_share_resp.dart';
import 'package:myfootball/model/response/matching_resp.dart';
import 'package:myfootball/model/response/member_resp.dart';
import 'package:myfootball/model/response/notification_resp.dart';
import 'package:myfootball/model/response/request_join_resp.dart';
import 'package:myfootball/model/response/review_resp.dart';
import 'package:myfootball/model/response/search_team_resp.dart';
import 'package:myfootball/model/response/team_request_resp.dart';
import 'package:myfootball/model/response/team_resp.dart';
import 'package:myfootball/model/response/ticket_resp.dart';
import 'package:myfootball/model/response/transaction_resp.dart';
import 'package:myfootball/model/response/user_request_resp.dart';
import 'package:myfootball/model/team.dart';

import 'base_api.dart';

class Api {
  final _api = BaseApi.getInstance();

  Future<LoginResponse> loginEmail(String email, String password) async {
    try {
      var response = await _api.getApi('user/login',
          queryParams: FormData.from({
            'email': email,
            'password': password,
          }));
      return LoginResponse.success(response.data);
    } on DioError catch (e) {
      return LoginResponse.error(e.message);
    }
  }

  Future<BaseResponse> registerDevice(DeviceInfo deviceInfo) async {
    try {
      var resp = await _api.postApi('device-info', body: deviceInfo.toJson());
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<LoginResponse> register(String name, String email, String password,
      String phoneNumber, List<int> roles) async {
    try {
      // for body
      var response = await _api.postApi('user/register', body: {
        "name": name,
        "email": email,
        "password": password,
        "phone": phoneNumber,
        "roles": roles
      });
      return LoginResponse.success(response.data);
    } on DioError catch (e) {
      return LoginResponse.error(e.message);
    }
  }

  Future<BaseResponse> activeUser(
      int userId, String phoneNumber, String idToken) async {
    try {
      var resp = await _api.putApi('user/active',
          body: {"user_id": userId, "phone": phoneNumber, "token_id": idToken});
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> forgotPassword(String email) async {
    try {
      var response =
          await _api.postApi('user/forgot-password', body: {"email": email});
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> changePassword(
      String email, String password, String code) async {
    try {
      var response = await _api.postApi('user/change-password',
          body: {"email": email, "password": password, "code": code});
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<LoginResponse> refreshToken(String refreshToken) async {
    try {
      var resp = await _api.getApi('user/login/refresh-token/$refreshToken');
      return LoginResponse.success(resp.data);
    } on DioError catch (e) {
      return LoginResponse.error(e.message);
    }
  }

  Future<BaseResponse> logout() async {
    try {
      var response = await _api.postApi('user/logout');
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<UserRequestResponse> getUserRequest() async {
    try {
      var resp = await _api.getApi('request-member/find-by-user-id');
      return UserRequestResponse.success(resp.data);
    } on DioError catch (e) {
      return UserRequestResponse.error(e.message);
    }
  }

  Future<TeamRequestResponse> getTeamRequest(int teamId) async {
    try {
      FormData formData = new FormData.from({
        "groupId": teamId,
      });
      var resp = await _api.getApi('request-member/find-by-group-id',
          queryParams: formData);
      return TeamRequestResponse.success(resp.data);
    } on DioError catch (e) {
      return TeamRequestResponse.error(e.message);
    }
  }

  Future<BaseResponse> createRequestMember(
      int teamId, String content, String position) async {
    try {
      var response = await _api.postApi('request-member/create',
          body: {"group_id": teamId, "content": content, "position": position});
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> updateRequestMember(
      int requestId, int teamId, String content, String position) async {
    try {
      var response = await _api.postApi('request-member/update', body: {
        "id": requestId,
        "content": content,
        'group_id': teamId,
        'position': position
      });
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> cancelRequestMember(int requestId) async {
    try {
      var response = await _api.postApi('request-member/$requestId/cancel');
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> approveRequestMember(int requestId) async {
    try {
      var response = await _api.postApi('request-member/$requestId/approved');
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> rejectRequestMember(int requestId) async {
    try {
      var response = await _api.postApi('request-member/$requestId/rejected');
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<TeamResponse> createTeam(Team team) async {
    try {
      var response =
          await _api.postApi('group/create', body: team.createTeamJson());
      return TeamResponse.success(response.data);
    } on DioError catch (e) {
      return TeamResponse.error(e.message);
    }
  }

  Future<BaseResponse> updateTeam(Team team) async {
    try {
      var response = await _api.putApi('group/update', body: team.toJson());
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<SearchTeamResponse> searchTeamByKey(String key) async {
    try {
      FormData formData = new FormData.from({
        "text_search": key,
      });
      var resp = await _api.getApi("group/search", queryParams: formData);
      return SearchTeamResponse.success(resp.data);
    } on DioError catch (e) {
      return SearchTeamResponse.error(e.message);
    }
  }

  Future<TeamResponse> getTeamDetail(int id) async {
    try {
      var resp = await _api.getApi("group/$id");
      return TeamResponse.success(resp.data);
    } on DioError catch (e) {
      return TeamResponse.error(e.message);
    }
  }

  Future<NotificationResponse> getNotifications() async {
    try {
      var resp = await _api.getApi("user/notification");
      return NotificationResponse.success(resp.data);
    } on DioError catch (e) {
      return NotificationResponse.error(e.message);
    }
  }

  Future<BaseResponse> activeMatching(int groupId) async {
    try {
      var resp = await _api.putApi("group/$groupId/matching/active");
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> inActiveMatching(int groupId) async {
    try {
      var resp = await _api.putApi("group/$groupId/matching/inactive");
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<CreateMatchingResponse> createMatchingInfo(
      GroupMatchingInfo groupMatchingInfo) async {
    try {
      var resp = await _api.postApi(
          "group/${groupMatchingInfo.groupId}/matching",
          body: groupMatchingInfo.toJson());
      return CreateMatchingResponse.success(resp.data);
    } on DioError catch (e) {
      return CreateMatchingResponse.error(e.message);
    }
  }

  Future<MatchingResponse> findMatching(
      int teamId, GroupMatchingInfo groupMatchingInfo, int pageIndex) async {
    try {
      var resp = await _api.putApi(
          "group/$teamId/matching?limit=10&page=$pageIndex",
          body: groupMatchingInfo.toJson());
      return MatchingResponse.success(resp.data);
    } on DioError catch (e) {
      return MatchingResponse.error(e.message);
    }
  }

  Future<GroundResponse> getGroundDetail(int groundId) async {
    try {
      var resp = await _api.getApi("ground/$groundId");
      return GroundResponse.success(resp.data);
    } on DioError catch (e) {
      return GroundResponse.error(e.message);
    }
  }

  Future<ListGroundResponse> getGroundByLocation(double lat, double lng) async {
    try {
      var resp =
          await _api.getApi("ground/distance?lat=$lat&lng=$lng&distance=5000");
      return ListGroundResponse.success(resp.data);
    } on DioError catch (e) {
      return ListGroundResponse.error(e.message);
    }
  }

  Future<GroundResponse> getFreeTimeSlots(int groundId, String playDate) async {
    try {
      FormData formData = new FormData.from({
        "playDate": playDate,
      });
      var resp =
          await _api.getApi("ground/$groundId/detail", queryParams: formData);
      return GroundResponse.success(resp.data);
    } on DioError catch (e) {
      return GroundResponse.error(e.message);
    }
  }

  Future<BaseResponse> booking(int teamId, int timeSlotId, int playDate) async {
    try {
      var resp = await _api.postApi("ticket", body: {
        "group_id": teamId,
        "time_slot_id": timeSlotId,
        "play_date": playDate,
        "prepayment_status": 0,
        "payment_status": 0
      });
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> cancelBooking(int ticketId) async {
    try {
      var resp = await _api.putApi('ticket/$ticketId/cancel');
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> sendInvite(InviteRequest inviteRequest) async {
    try {
      var resp = await _api.postApi('match/request',
          body: inviteRequest.toCreateInviteJson());
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> sendInviteJoin(InviteRequest inviteRequest) async {
    try {
      var resp = await _api.postApi('match/request',
          body: inviteRequest.toCreateInviteJoinJson());
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<InviteRequestResponse> getInviteRequests(int teamId) async {
    try {
      FormData formData = new FormData.from({
        "page": 1,
        "limit": 50,
      });
      var resp = await _api.getApi('match/request/group/$teamId',
          queryParams: formData);
      return InviteRequestResponse.success(teamId, resp.data);
    } on DioError catch (e) {
      return InviteRequestResponse.error(e.message);
    }
  }

  Future<BaseResponse> cancelInviteRequest(int inviteId) async {
    try {
      var resp = await _api.putApi('match/request/$inviteId/cancel');
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> rejectInviteRequest(int inviteId) async {
    try {
      var resp = await _api.putApi('match/request/$inviteId/reject');
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> acceptInviteRequest(
      int inviteId, int timeSlotId, int playDate) async {
    try {
      var resp = await _api.putApi('match/request/$inviteId/accept',
          body: {"time_slot_id": timeSlotId, "play_date": playDate});
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> acceptJoinMatch(int inviteId) async {
    try {
      var resp = await _api.putApi('match/request/$inviteId/accept');
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<ReviewResponse> reviewTeam(
      int teamId, double rating, String comment) async {
    try {
      var resp = await _api.postApi('rate/group/$teamId',
          body: {"rating": rating, "comment": comment});
      return ReviewResponse.success(resp.data);
    } on DioError catch (e) {
      return ReviewResponse.error(e.message);
    }
  }

  Future<ReviewResponse> reviewGround(
      int groundId, double rating, String comment) async {
    try {
      var resp = await _api.postApi('rate/ground/$groundId',
          body: {"rating": rating, "comment": comment});
      return ReviewResponse.success(resp.data);
    } on DioError catch (e) {
      return ReviewResponse.error(e.message);
    }
  }

  Future<ReviewResponse> reviewUser(
      int userId, double rating, String comment) async {
    try {
      var resp = await _api.postApi('rate/user/$userId',
          body: {"rating": rating, "comment": comment});
      return ReviewResponse.success(resp.data);
    } on DioError catch (e) {
      return ReviewResponse.error(e.message);
    }
  }

  Future<CommentResponse> getCommentByTeamId(int teamId, int page) async {
    try {
      FormData formData = new FormData.from({
        "page": page,
        "size": 50,
      });
      var resp = await _api.getApi('rate/group/$teamId', queryParams: formData);
      return CommentResponse.success(resp.data);
    } on DioError catch (e) {
      return CommentResponse.error(e.message);
    }
  }

  Future<CommentResponse> getCommentByGroundId(int groundId, int page) async {
    try {
      FormData formData = new FormData.from({
        "page": page,
        "size": 50,
      });
      var resp =
          await _api.getApi('rate/ground/$groundId', queryParams: formData);
      return CommentResponse.success(resp.data);
    } on DioError catch (e) {
      return CommentResponse.error(e.message);
    }
  }

  Future<CommentResponse> getCommentByUserId(int userId, int page) async {
    try {
      FormData formData = new FormData.from({
        "page": page,
        "size": 50,
      });
      var resp = await _api.getApi('rate/user/$userId', queryParams: formData);
      return CommentResponse.success(resp.data);
    } on DioError catch (e) {
      return CommentResponse.error(e.message);
    }
  }

  Future<MatchScheduleResponse> getMatchSchedules(int teamId, int page) async {
    try {
      FormData formData =
          new FormData.from({"groupId": teamId, "page": page, "limit": 50});
      var resp = await _api.getApi('match', queryParams: formData);
      return MatchScheduleResponse.success(teamId, resp.data);
    } on DioError catch (e) {
      return MatchScheduleResponse.error(e.message);
    }
  }

  Future<BaseResponse> joinMatch(int teamId, int matchId) async {
    try {
      var resp = await _api.putApi('match/$matchId/group/$teamId/join');
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> leaveMatch(int teamId, int matchId) async {
    try {
      var resp = await _api.putApi('match/$matchId/group/$teamId/leave');
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<MemberResponse> getJoinedMember(int matchId, int teamId) async {
    try {
      var resp = await _api.getApi('match/$matchId/group/$teamId/user');
      return MemberResponse.success(resp.data);
    } on DioError catch (e) {
      return MemberResponse.error(e.message);
    }
  }

  Future<TicketResponse> getTickets(int teamId) async {
    try {
      var resp = await _api.getApi('ticket/group/$teamId');
      return TicketResponse.success(resp.data);
    } on DioError catch (e) {
      return TicketResponse.error(e.message);
    }
  }

  Future<BaseResponse> updateScore(
      int historyId, int sendTeamScore, int receiveTeamScore) async {
    try {
      var resp = await _api.putApi('match/history/$historyId/score', body: {
        'send_group_score': sendTeamScore,
        'receive_group_score': receiveTeamScore
      });
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<MatchHistoryResponse> getHistories(int teamId, int page) async {
    try {
      FormData formData =
          new FormData.from({"groupId": teamId, "page": page, "limit": 50});
      var resp = await _api.getApi('match/history', queryParams: formData);
      return MatchHistoryResponse.success(teamId, resp.data);
    } on DioError catch (e) {
      return MatchHistoryResponse.error(e.message);
    }
  }

  Future<BaseResponse> confirmMatchResult(int historyId) async {
    try {
      var resp = await _api.putApi('match/history/$historyId/confirm');
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> createFundNotify(
      int teamId, String title, double price, int expireDate) async {
    try {
      var resp = await _api.postApi('group/$teamId/notice-wallet',
          body: {"price": price, "title": title, "expire_date": expireDate});
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<FundResponse> getFundsByTeam(int teamId) async {
    try {
      var resp = await _api.getApi('group/$teamId/notice-wallet');
      return FundResponse.success(resp.data);
    } on DioError catch (e) {
      return FundResponse.error(e.message);
    }
  }

  Future<SearchTeamResponse> getRanking() async {
    try {
      var resp = await _api.getApi('group/ranking');
      return SearchTeamResponse.success(resp.data);
    } on DioError catch (e) {
      return SearchTeamResponse.error(e.message);
    }
  }

  Future<BaseResponse> sendFundRequest(int noticeId) async {
    try {
      var resp = await _api.postApi('group/notice-wallet/$noticeId/request');
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> acceptFundRequest(int requestId) async {
    try {
      var resp =
          await _api.postApi('group/notice-wallet/request/$requestId/accept');
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> rejectFundRequest(int requestId) async {
    try {
      var resp =
          await _api.postApi('group/notice-wallet/request/$requestId/reject');
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<FundRequestResponse> getFundStatusByNoticeId(
      int teamId, int noticeId) async {
    try {
      var resp = await _api.getApi('group/$teamId/notice-wallet/$noticeId');
      return FundRequestResponse.success(resp.data);
    } on DioError catch (e) {
      return FundRequestResponse.error(e.message);
    }
  }

  Future<TransactionResponse> getTransactionByTeam(
      int teamId, String month) async {
    try {
      var resp = await _api.getApi('group/$teamId/wallet/history?month=$month');
      return TransactionResponse.success(resp.data);
    } on DioError catch (e) {
      return TransactionResponse.error(e.message);
    }
  }

  Future<BaseResponse> createExchange(
      int teamId, double price, int type, String title) async {
    try {
      var resp = await _api.postApi('group/$teamId/exchange',
          body: {'price': price, 'type': type, 'title': title});
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<TransactionResponse> getUserTransaction(int page) async {
    try {
      FormData formData = new FormData.from({"page": page, "limit": 50});
      var resp =
          await _api.getApi('user/wallet/history', queryParams: formData);
      return TransactionResponse.success(resp.data);
    } on DioError catch (e) {
      return TransactionResponse.error(e.message);
    }
  }

  Future<BaseResponse> addCaptain(int teamId, int memberId) async {
    try {
      var resp = await _api.putApi('group/$teamId/captain?member_id=$memberId');
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> removeMember(int teamId, int memberId) async {
    try {
      var resp = await _api.deleteApi('group/$teamId/member/$memberId/kick');
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> leaveTeam(int teamId) async {
    try {
      var resp = await _api.deleteApi('group/$teamId/leave');
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> memberConfirm(int matchId) async {
    try {
      var resp = await _api.putApi('match/$matchId/result/confirm');
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> memberCancelConfirm(int matchId) async {
    try {
      var resp = await _api.putApi('match/$matchId/result/cancel');
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<CreateCodeResponse> createCode(int matchId, int teamId) async {
    try {
      var resp = await _api.postApi('match/$matchId/group/$teamId/code');
      return CreateCodeResponse.success(resp.data);
    } on DioError catch (e) {
      return CreateCodeResponse.error(e.message);
    }
  }

  Future<MatchShareResponse> getMatchShares(int page) async {
    try {
      FormData formData = new FormData.from({"page": page, "limit": 50});
      var resp = await _api.getApi('match/share', queryParams: formData);
      return MatchShareResponse.success(resp.data);
    } on DioError catch (e) {
      return MatchShareResponse.error(e.message);
    }
  }

  Future<BaseResponse> joinMatchByCode(int shareId, String code) async {
    try {
      var resp = await _api
          .postApi('match/share/$shareId/request', body: {'code': code});
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<MatchShareResponse> getUserJoinMatch(int page) async {
    try {
      FormData formData = new FormData.from({"page": page, "limit": 50});
      var resp =
          await _api.getApi('match/share/user/request', queryParams: formData);
      return MatchShareResponse.success(resp.data);
    } on DioError catch (e) {
      return MatchShareResponse.error(e.message);
    }
  }

  Future<BaseResponse> cancelUserJoinRequest(int matchUserId) async {
    try {
      var resp = await _api.putApi('match/share/$matchUserId/cancel');
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> acceptUserJoinRequest(int matchUserId) async {
    try {
      var resp = await _api.putApi('match/share/$matchUserId/accept');
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> rejectUserJoinRequest(int matchUserId) async {
    try {
      var resp = await _api.putApi('match/share/$matchUserId/reject');
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<RequestJoinResponse> getRequestJoin(int matchId, int teamId) async {
    try {
      var resp =
          await _api.getApi('match/$matchId/group/$teamId/share/request');
      return RequestJoinResponse.success(resp.data);
    } on DioError catch (e) {
      return RequestJoinResponse.error(e.message);
    }
  }
}
