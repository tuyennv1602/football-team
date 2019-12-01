import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> verifyOtp(
      int userId, String phoneNumber, String verificationId) async {
    if (otpCode.length != 6) return;
    UIHelper.showProgressDialog;
    var token = await FirebaseServices.instance
        .signInWithPhoneNumber(verificationId, otpCode);
    if (token != null) {
      var resp = await _api.activeUser(userId, phoneNumber, token);
      UIHelper.hideProgressDialog;
      if (resp.isSuccess) {
        UIHelper.showSimpleDialog('Tài khoản đã được kích hoạt thành công!',
            onConfirmed: () =>
                NavigationService.instance.navigateAndRemove(LOGIN),
            isSuccess: true);
      } else {
        UIHelper.showSimpleDialog(resp.errorMessage);
      }
    } else {
      UIHelper.hideProgressDialog;
      UIHelper.showSimpleDialog('Có lỗi xảy ra. Vui lòng thử lại',
          onConfirmed: () => NavigationService.instance.goBack());
    }
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    UIHelper.showProgressDialog;
    if (phoneNumber.startsWith('0')) {
      phoneNumber = phoneNumber.replaceFirst('0', '+84');
    }
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      UIHelper.hideProgressDialog;
      print('verify completely');
    };
    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      UIHelper.hideProgressDialog;
      UIHelper.showSimpleDialog(
          'Gửi mã xác thực lỗi: ${authException.message}');
    };
    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      UIHelper.hideProgressDialog;
      print('code sent: ' + verificationId);
      setExpired(false);
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      UIHelper.hideProgressDialog;
      print('Gửi mã xác thực lỗi: Timeout!');
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(minutes: 1),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }
}
