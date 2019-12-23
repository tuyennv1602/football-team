import 'package:flutter/cupertino.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/model/response/user_request_resp.dart';
import 'package:myfootball/model/user_request.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/utils/constants.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class UserRequestViewModel extends BaseViewModel {
  Api _api;
  List<UserRequest> userRequests;

  UserRequestViewModel({@required Api api}) : _api = api;

  Future<UserRequestResponse> getAllRequest() async {
    setBusy(true);
    var resp = await _api.getUserRequest();
    if (resp.isSuccess) {
      userRequests = resp.userRequests;
    }
    setBusy(false);
    return resp;
  }

  Future<BaseResponse> updateRequest(int index, UserRequest request) async {
    var resp = await _api.updateRequestMember(request);
    if (resp.isSuccess) {
      var _userRequest = userRequests[index];
      _userRequest.status = Constants.REQUEST_WAITING;
      _userRequest.content = request.content;
      _userRequest.position = request.position;
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
