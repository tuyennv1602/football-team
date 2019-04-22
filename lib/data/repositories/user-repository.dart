import 'package:dio/dio.dart';
import 'package:myfootball/data/providers/user-provider.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository.internal();
  factory UserRepository() => _instance;
  UserRepository.internal();

  UserApiProvider _apiProvider = UserApiProvider();

  Future<Response> loginWithEmail(String email, String password) {
    return _apiProvider.loginWithEmail(email, password);
  }
}
