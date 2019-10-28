import 'package:dio/dio.dart';
import 'package:myfootball/models/device_info.dart';
import 'package:myfootball/models/group_matching_info.dart';
import 'package:myfootball/models/invite_request.dart';
import 'package:myfootball/models/responses/base_response.dart';
import 'package:myfootball/models/responses/create_matching_resp.dart';
import 'package:myfootball/models/responses/ground_resp.dart';
import 'package:myfootball/models/responses/invite_request_resp.dart';
import 'package:myfootball/models/responses/list_ground_resp.dart';
import 'package:myfootball/models/responses/login_resp.dart';
import 'package:myfootball/models/responses/matching_resp.dart';
import 'package:myfootball/models/responses/notification_resp.dart';
import 'package:myfootball/models/responses/search_team_resp.dart';
import 'package:myfootball/models/responses/team_request_resp.dart';
import 'package:myfootball/models/responses/team_resp.dart';
import 'package:myfootball/models/responses/user_request_resp.dart';
import 'package:myfootball/models/team.dart';

import 'base_api.dart';

class Api {
  final _api = BaseApi.getInstance();

  Future<LoginResponse> loginEmail(String email, String password) async {
    try {
      var response = await _api.getAuthApi('user/login',
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

  Future<BaseResponse> register(String name, String email, String password,
      String phoneNumber, List<int> roles) async {
    try {
      // for body
      var response = await _api.postAuthApi('user/register', body: {
        "name": name,
        "email": email,
        "password": password,
        "phone": phoneNumber,
        "roles": roles
      });
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> forgotPassword(String email) async {
    try {
      var response = await _api
          .postAuthApi('user/forgot-password', body: {"email": email});
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> changePassword(
      String email, String password, String code) async {
    try {
      var response = await _api.postAuthApi('user/change-password',
          body: {"email": email, "password": password, "code": code});
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<LoginResponse> refreshToken(String refreshToken) async {
    try {
      var resp =
          await _api.getAuthApi('user/login/refresh-token/$refreshToken');
      return LoginResponse.success(resp.data);
    } on DioError catch (e) {
      return LoginResponse.error(e.message);
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
      var response = await _api.putApi('request-member/update', body: {
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

  Future<TeamResponse> createTeam(int userId, Team team) async {
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

  Future<BaseResponse> bookingTimeSlot(
      int groundId, int timeSlotId, int playDate) async {
    try {
      var resp = await _api.postApi("ticket", body: {
        "group_id": groundId,
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

  Future<BaseResponse> sendInviteMatching(
      InviteRequest matchingRequest) async {
    try {
      var resp = await _api.postApi('match/request',
          body: matchingRequest.toCreateJson());
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<InviteRequestResponse> getInviteRequestsByTeam(int teamId) async {
    try {
      FormData formData = new FormData.from({
        "page": 1,
        "limit": 10,
      });
      var resp = await _api.getApi('match/request/group/$teamId',
          queryParams: formData);
      return InviteRequestResponse.success(resp.data);
    } on DioError catch (e) {
      return InviteRequestResponse.error(e.message);
    }
  }
}
