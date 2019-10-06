import 'package:dio/dio.dart';
import 'package:myfootball/models/headers.dart';

import '../http.dart';

class BaseApi {
  static final BaseApi _instance = BaseApi.internal();

  factory BaseApi() => _instance;

  BaseApi.internal();

  static const HOST = "http://35.192.88.45:8080/football";

  static Headers header;

  static setHeader(Headers header) {
    BaseApi.header = header;
  }

  Future<Response<dynamic>> getAuthApi(String endPoint,
      {FormData queryParams}) async {
    return await dio.get('$HOST/$endPoint', queryParameters: queryParams);
  }

  Future<Response<dynamic>> postAuthApi(String endPoint, {dynamic body}) async {
    return await dio.post('$HOST/$endPoint', data: body);
  }

  Future<Response<dynamic>> getApi(String endPoint,
      {FormData queryParams}) async {
    return await dio.get('$HOST/$endPoint',
        queryParameters: queryParams,
        options: Options(headers: header != null ? header.toJson() : null));
  }

  Future<Response<dynamic>> postApi(String endPoint, {dynamic body}) async {
    return await dio.post('$HOST/$endPoint',
        data: body,
        options: Options(headers: header != null ? header.toJson() : null));
  }

  Future<Response<dynamic>> putApi(String endPoint, {dynamic body}) async {
    return await dio.put('$HOST/$endPoint',
        data: body,
        options: Options(headers: header != null ? header.toJson() : null));
  }
}
