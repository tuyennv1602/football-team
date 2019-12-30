import 'package:flutter/cupertino.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/model/response/user_request_resp.dart';
import 'package:myfootball/model/user_request.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/utils/constants.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

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

  Future<void> updateRequest(int index, UserRequest request) async {
    UIHelper.showProgressDialog;
    var resp = await _api.updateRequestMember(request);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      var _userRequest = userRequests[index];
      _userRequest.status = Constants.REQUEST_WAITING;
      _userRequest.content = request.content;
      _userRequest.position = request.position;
      userRequests[index] = _userRequest;
      notifyListeners();
      UIHelper.showSimpleDialog('Đã cập nhật yêu cầu!', isSuccess: true);
    }else{
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  Future<BaseResponse> cancelRequest(int index, int requestId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.cancelRequestMember(requestId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      var _userRequest = userRequests[index];
      _userRequest.status = Constants.REQUEST_CANCEL;
      userRequests[index] = _userRequest;
      notifyListeners();
      UIHelper.showSimpleDialog('Đã huỷ yêu cầu', isSuccess: true);
    }else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
    return resp;
  }
}
