import 'package:flutter/cupertino.dart';
import 'package:myfootball/models/responses/user-request-response.dart';
import 'package:myfootball/models/user-request.dart';
import 'package:myfootball/services/api.dart';
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
}
