import 'package:flutter/cupertino.dart';
import 'package:myfootball/models/responses/base-response.dart';
import 'package:myfootball/models/responses/user_request_resp.dart';
import 'package:myfootball/models/user_request.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/utils/constants.dart';
import 'package:myfootball/viewmodels/base_view_model.dart';

class UserRequestModel extends BaseViewModel {
  Api _api;
  List<UserRequest> userRequests;

  UserRequestModel({@required Api api}) : _api = api;

  Future<UserRequestResponse> getAllRequest() async {
    setBusy(true);
    var resp = await _api.getUserRequest();
    if (resp.isSuccess) {
      userRequests = resp.userRequests;
    }
    setBusy(false);
    return resp;
  }

  Future<BaseResponse> updateRequest(
      int index, int requestId, int teamId, String content) async {
    var resp = await _api.updateRequestMember(requestId, teamId, content);
    if (resp.isSuccess) {
      var _userRequest = userRequests[index];
      _userRequest.status = Constants.REQUEST_WAITING;
      _userRequest.content = content;
      userRequests[index] = _userRequest;
      notifyListeners();
    }
    return resp;
  }

  Future<BaseResponse> cancelRequest(int index, int requestId) async {
    var resp = await _api.cancelRequestMember(requestId);
    if (resp.isSuccess) {
      var _userRequest = userRequests[index];
      _userRequest.status = Constants.REQUEST_CANCEL;
      userRequests[index] = _userRequest;
      notifyListeners();
    }
    return resp;
  }
}
