import 'package:dio/dio.dart';
import 'package:myfootball/data/app-preference.dart';
import 'package:myfootball/http.dart';

class AppApi {
  static const HOST = "http://192.168.16.101:8080/football";

  static var _appPref = AppPreference();

  static Future<Response<dynamic>> getApi(String endPoint, {FormData queryParams}) async {
    var header = await _appPref.getHeader();
    return await dio.get('$HOST/$endPoint',
        queryParameters: queryParams, options: Options(headers: header));
  }

  static Future<Response<dynamic>> postApi(String endPoint, {dynamic body}) async {
    var header = await _appPref.getHeader();
    return await dio.post('$HOST/$endPoint', data: body, options: Options(headers: header));
  }
}
