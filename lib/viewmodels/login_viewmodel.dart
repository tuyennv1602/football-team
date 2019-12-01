import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/models/device_info.dart';
import 'package:myfootball/models/headers.dart';
import 'package:myfootball/models/responses/base_response.dart';
import 'package:myfootball/models/verify_arg.dart';
import 'package:myfootball/services/auth_services.dart';
import 'package:myfootball/services/base_api.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/utils/constants.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class LoginViewModel extends BaseViewModel {
  final AuthServices _authServices;
  DeviceInfo deviceInfo;

  LoginViewModel({@required AuthServices authServices})
      : _authServices = authServices;

  Future<void> setupDeviceInfo() async {
    var resp = await getDeviceInfo();
    this.deviceInfo = resp;
    BaseApi.setHeader(Headers(deviceId: deviceInfo.deviceId));
  }

  Future<void> loginEmail(String email, String password) async {
    UIHelper.showProgressDialog;
    var resp =
        await _authServices.loginEmail(deviceInfo.deviceId, email, password);
    if (resp.isSuccess) {
      var _registerDeviceResp = await registerDevice();
      UIHelper.hideProgressDialog;
      if (_registerDeviceResp.isSuccess) {
        NavigationService.instance.navigateAndRemove(HOME);
      } else {
        UIHelper.showSimpleDialog(_registerDeviceResp.errorMessage);
      }
    } else {
      UIHelper.hideProgressDialog;
      if (resp.statusCode == Constants.CODE_NOT_ACCEPTABLE) {
        UIHelper.showConfirmDialog(
            'Tài khoản chưa được kích hoạt! Một mã xác thực gồm 6 ký tự sẽ được gửi đến số điện thoại của bạn. Vui lòng nhập mã xác thực để kích hoạt tài khoản',
            onConfirmed: () =>
                verifyPhoneNumber(resp.user.id, resp.user.phone));
      } else {
        UIHelper.showSimpleDialog(resp.errorMessage);
      }
    }
  }

  Future<DeviceInfo> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String firebaseToken = await FirebaseMessaging().getToken();
    String deviceId;
    String os;
    String version;
    String deviceName;
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.androidId;
      os = 'ANDROID';
      deviceName = androidInfo.model;
      version = androidInfo.version.release;
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
      os = 'IOS';
      deviceName = iosInfo.name;
      version = iosInfo.systemVersion;
    }
    return DeviceInfo(
        deviceId: deviceId,
        firebaseToken: firebaseToken,
        os: os,
        deviceVer: version,
        deviceName: deviceName);
  }

  Future<BaseResponse> registerDevice() async {
    setBusy(true);
    var resp = await _authServices.registerDevice(deviceInfo);
    setBusy(false);
    return resp;
  }

  Future<void> verifyPhoneNumber(int userId, String phoneNumber) async {
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
      NavigationService.instance.navigateTo(VERIFY_OTP,
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
