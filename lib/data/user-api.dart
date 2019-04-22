import 'dart:io';

import 'package:dio/dio.dart';
import 'package:myfootball/data/api-util.dart';
import 'package:myfootball/http.dart';

class UserApi {
  static final UserApi _instance = UserApi.internal();
  factory UserApi() => _instance;
  UserApi.internal();
  var apiUtil = ApiUtil();

  Future<Response> loginWithEmail(String email, String password) async {
    FormData formData = new FormData.from({
      'email': email,
      'password': password,
      'device_id': '1092',
      'device_os': '1',
      'device_version': '8.0',
      'version': '1.2',
      'battery': '100'
    });
    return await dio.post('${ApiUtil.HOST}driver/login', data: formData);
  }
}
