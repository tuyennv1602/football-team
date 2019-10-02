import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:myfootball/models/device_info.dart';
import 'package:myfootball/models/responses/base_response.dart';
import 'package:myfootball/models/responses/login_resp.dart';
import 'package:myfootball/services/auth_services.dart';
import 'package:myfootball/viewmodels/base_view_model.dart';

class LoginViewModel extends BaseViewModel {
  AuthServices _authServices;

  LoginViewModel({@required AuthServices authServices})
      : _authServices = authServices;

  Future<LoginResponse> loginEmail(String email, String password) async {
    setBusy(true);
    var resp = await _authServices.loginEmail(email, password);
    setBusy(false);
    return resp;
  }

  Future<BaseResponse> registerDevice() async {
    setBusy(true);
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
    var resp = await _authServices.registerDevice(DeviceInfo(
        deviceId: deviceId,
        firebaseToken: firebaseToken,
        os: os,
        deviceVer: version,
        deviceName: deviceName));
    setBusy(false);
    return resp;
  }
}
