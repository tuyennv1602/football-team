import 'package:dio/dio.dart';
import 'package:myfootball/model/headers.dart';

import '../http.dart';

class ApiConfig {
  static final ApiConfig _instance = ApiConfig.internal();

  factory ApiConfig() => _instance;

  ApiConfig.internal();

  static ApiConfig getInstance() {
    if (_instance == null) {
      return ApiConfig();
    }
    return _instance;
  }

  static Headers header;

  static setHeader(Headers header) {
    ApiConfig.header = header;
  }

  Future<Response<dynamic>> getApi(String endPoint,
      {FormData queryParams}) async {
    return await dio.get(endPoint,
        queryParameters: queryParams,
        options: Options(headers: header.toJson()));
  }

  Future<Response<dynamic>> postApi(String endPoint, {dynamic body}) async {
    return await dio.post(endPoint,
        data: body, options: Options(headers: header.toJson()));
  }

  Future<Response<dynamic>> putApi(String endPoint, {dynamic body}) async {
    return await dio.put(endPoint,
        data: body, options: Options(headers: header.toJson()));
  }

  Future<Response<dynamic>> deleteApi(String endPoint, {FormData queryParams}) async {
    return await dio.delete(endPoint,
        queryParameters: queryParams, options: Options(headers: header.toJson()));
  }
}
