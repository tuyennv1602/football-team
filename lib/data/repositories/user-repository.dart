import 'package:myfootball/data/providers/user-provider.dart';
import 'package:myfootball/models/responses/base-response.dart';
import 'package:myfootball/models/responses/login-response.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository.internal();
  factory UserRepository() => _instance;
  UserRepository.internal();

  UserApiProvider _apiProvider = UserApiProvider();

  Future<LoginResponse> loginWithEmail(String email, String password) {
    return _apiProvider.loginWithEmail(email, password);
  }

  Future<BaseResponse> forgotPassword(String email) {
    return _apiProvider.forgotPassword(email);
  }

  Future<BaseResponse> register(
      String userName, String email, String password, String phoneNumber) {
    return _apiProvider.register(userName, email, password, phoneNumber);
  }
}
