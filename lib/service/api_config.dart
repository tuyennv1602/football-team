import 'package:dio/dio.dart';
import 'package:myfootball/model/header.dart';

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

  static Header header;

  static setHeader(Header header) {
    ApiConfig.header = header;
  }

  Future<Response<dynamic>> getApi(String endPoint,
      {Map<String, dynamic> queryParams}) async {
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

  Future<Response<dynamic>> deleteApi(String endPoint,
      { Map<String, dynamic> queryParams}) async {
    return await dio.delete(endPoint,
        queryParameters: queryParams,
        options: Options(headers: header.toJson()));
  }
}
