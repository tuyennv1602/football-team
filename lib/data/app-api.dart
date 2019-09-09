import 'package:dio/dio.dart';
import 'package:myfootball/http.dart';
import 'package:myfootball/models/header.dart';

class AppApi {
  static const HOST = "http://192.168.16.103:8080/football";

  static Header header;

  static setHeader(Header header) {
    AppApi.header = header;
  }

  static Future<Response<dynamic>> getApi(String endPoint, {FormData queryParams}) async {
    return await dio.get('$HOST/$endPoint',
        queryParameters: queryParams,
        options: Options(headers: header != null ? header.toJson() : null));
  }

  static Future<Response<dynamic>> postApi(String endPoint, {dynamic body}) async {
    return await dio.post('$HOST/$endPoint',
        data: body, options: Options(headers: header != null ? header.toJson() : null));
  }
}
