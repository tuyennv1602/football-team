import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:myfootball/model/verify_arg.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class RegisterViewModel extends BaseViewModel {
  Api _api;

  RegisterViewModel({@required Api api}) : _api = api;

  Future<void> registerWithEmail(String name, String email, String password,
      String phoneNumber, List<int> roles) async {
    UIHelper.showProgressDialog;
    var resp = await _api.register(name, email, password, phoneNumber, roles);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      UIHelper.showSimpleDialog(
          'Đăng ký thành công! Một mã xác thực gồm 6 ký tự sẽ được gửi đến số điện thoại của bạn. Vui lòng nhập mã xác thực để kích hoạt tài khoản',
          isSuccess: true,
          onConfirmed: () => verifyPhoneNumber(resp.user.id, resp.user.phone));
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  Future<void> verifyPhoneNumber(int userId, String phoneNumber) async {
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
      Navigation.instance.navigateTo(VERIFY_OTP,
          arguments: VerifyArgument(
              userId: userId,
              phoneNumber: phoneNumber,
              verificationId: verificationId));
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
