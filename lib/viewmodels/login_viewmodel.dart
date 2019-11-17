import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/models/device_info.dart';
import 'package:myfootball/models/responses/base_response.dart';
import 'package:myfootball/services/auth_services.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class LoginViewModel extends BaseViewModel {
  final AuthServices _authServices;

  LoginViewModel({@required AuthServices authServices})
      : _authServices = authServices;

  Future<void> loginEmail(String email, String password) async {
    UIHelper.showProgressDialog;
    var resp = await _authServices.loginEmail(email, password);
    if (resp.isSuccess) {
      var _registerDeviceResp = await registerDevice();
      UIHelper.hideProgressDialog;
      if (_registerDeviceResp.isSuccess) {
        NavigationService.instance().navigateAndRemove(HOME);
      } else {
        UIHelper.showSimpleDialog(_registerDeviceResp.errorMessage);
      }
    } else {
      UIHelper.hideProgressDialog;
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
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
