import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/model/verify_arg.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/service/firebase_services.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

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

  Future<BaseResponse> verifyOtp(VerifyArgument argument) async {
    if (otpCode.length != 6)
      BaseResponse(
          success: false,
          errorMessage: 'Mã xác thực không đúng. Vui lòng thử lại');
    var token = await FirebaseServices.instance
        .signInWithPhoneNumber(argument.verificationId, otpCode);
    if (token != null) {
      var resp = await _api.activeUser(argument.userId, argument.phoneNumber, token);
      return resp;
    } else {
      return BaseResponse(
          success: false,
          errorMessage: 'Mã xác thực không đúng. Vui lòng thử lại');
    }
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    UIHelper.showProgressDialog;
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
