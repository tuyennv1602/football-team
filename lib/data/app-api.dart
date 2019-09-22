import 'package:dio/dio.dart';
import 'package:myfootball/http.dart';
import 'package:myfootball/models/headers.dart';

class AppApi {
//  static const HOST = "http://192.168.16.103:8080/football";
//  static const HOST = "http://42.114.56.77:8080/football";
  static const HOST = "http://192.168.1.14:8080/football";

  static Headers header;

  static setHeader(Headers header) {
    AppApi.header = header;
  }

  static Future<Response<dynamic>> getAuthApi(String endPoint,
      {FormData queryParams}) async {
    return await dio.get('$HOST/$endPoint', queryParameters: queryParams);
  }

  static Future<Response<dynamic>> postAuthApi(String endPoint,
      {dynamic body}) async {
    return await dio.post('$HOST/$endPoint', data: body);
  }

  static Future<Response<dynamic>> getApi(String endPoint,
      {FormData queryParams}) async {
    return await dio.get('$HOST/$endPoint',
        queryParameters: queryParams,
        options: Options(
          headers: header.toJson(),
        ));
  }

  static Future<Response<dynamic>> postApi(String endPoint,
      {dynamic body}) async {
    return await dio.post('$HOST/$endPoint',
        data: body,
        options: Options(
          headers: header.toJson(),
        ));
  }
}
