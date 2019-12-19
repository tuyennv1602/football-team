import 'package:flutter/material.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class ForgotPasswordViewModel extends BaseViewModel {
  Api _api;
  bool isChangePassword = false;

  ForgotPasswordViewModel({@required Api api}) : this._api = api;

  Future<void> forgotPassword(String email) async {
    UIHelper.showProgressDialog;
    var resp = await _api.forgotPassword(email);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      isChangePassword = true;
      notifyListeners();
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  Future<void> changePassword(
      String email, String password, String code) async {
    UIHelper.showProgressDialog;
    var resp = await _api.changePassword(email, password, code);
    UIHelper.hideProgressDialog;
    if(resp.isSuccess){
      UIHelper.showSimpleDialog(
        'Mật khẩu đã được thay đổi',
        isSuccess: true,
        onConfirmed: () => Navigation.instance.goBack(),
      );
    }else{
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }
}
