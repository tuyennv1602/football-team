import 'package:dio/dio.dart';
import 'package:myfootball/http.dart';

class UserApiProvider {
  static final UserApiProvider _instance = UserApiProvider.internal();
  factory UserApiProvider() => _instance;
  UserApiProvider.internal();

  final String host = 'https://thedropapp.co/driverapi';

  Future<Response> loginWithEmail(String email, String password) async {
    try {
      FormData formData = new FormData.from({
        'email': email,
        'password': password,
        'device_id': '1092',
        'device_os': '1',
        'device_version': '8.0',
        'version': '1.2',
        'battery': '100'
      });
      return await dio.post('$host/driver/login', data: formData);
    } on DioError catch (e) {
      return null;
    }
  }
}
