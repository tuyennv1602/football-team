import 'package:flutter/material.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class ForgotPasswordViewModel extends BaseViewModel {
  Api _api;
  bool isChangePassword = false;

  ForgotPasswordViewModel({@required Api api}) : this._api = api;

  switchMode(bool isChangePassword) {
    this.isChangePassword = isChangePassword;
    notifyListeners();
  }

  Future<BaseResponse> forgotPassword(String email) async {
    var resp = await _api.forgotPassword(email);
    return resp;
  }

  Future<BaseResponse> changePassword(
      String email, String password, String code) async {
    var resp = await _api.changePassword(email, password, code);
    return resp;
  }
}
