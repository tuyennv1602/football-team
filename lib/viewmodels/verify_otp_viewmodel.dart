import 'package:flutter/material.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/services/firebase_services.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class VerifyOTPViewModel extends BaseViewModel {
  Api _api;

  bool isExpired = false;

  String otpCode = '';

  VerifyOTPViewModel({@required Api api}) : _api = api;

  setExpired(bool isExpire) {
    isExpired = isExpire;
    notifyListeners();
  }

  setCode(String code) {
    if (otpCode.length < 6) {
      this.otpCode = this.otpCode + code;
      notifyListeners();
    }
  }

  deleteCode() {
    if (otpCode.length > 0) {
      this.otpCode = this.otpCode.substring(0, this.otpCode.length - 1);
      notifyListeners();
    }
  }

  Future<void> verifyOtp(String verificationId) async {
    if (otpCode.length != 6) return;
    UIHelper.showProgressDialog;
    var uid = await FirebaseServices.instance
        .signInWithPhoneNumber(verificationId, otpCode);
    UIHelper.hideProgressDialog;
    if (uid != null) {
      UIHelper.showSimpleDialog('Tài khoản đã được kích hoạt thành công! #$uid',
          onConfirmed: () =>
              NavigationService.instance.navigateAndRemove(LOGIN),
          isSuccess: true);
    } else {
      UIHelper.showSimpleDialog('Có lỗi xảy ra. Vui lòng thử lại',
          onConfirmed: () => NavigationService.instance.goBack());
    }
  }
}
