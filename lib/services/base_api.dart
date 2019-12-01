import 'package:dio/dio.dart';
import 'package:myfootball/models/headers.dart';

import '../http.dart';

class BaseApi {
  static final BaseApi _instance = BaseApi.internal();

  factory BaseApi() => _instance;

  BaseApi.internal();

  static BaseApi getInstance() {
    if (_instance == null) {
      return BaseApi();
    }
    return _instance;
  }

  static Headers header;

  static setHeader(Headers header) {
    BaseApi.header = header;
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
}
