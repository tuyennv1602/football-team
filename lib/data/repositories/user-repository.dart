import 'package:myfootball/data/providers/user-provider.dart';
import 'package:myfootball/models/responses/base-response.dart';
import 'package:myfootball/models/responses/login-response.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository.internal();
  factory UserRepository() => _instance;
  UserRepository.internal();

  UserApiProvider _apiProvider = UserApiProvider();

  Future<LoginResponse> loginWithEmail(String email, String password) =>
      _apiProvider.loginWithEmail(email, password);

  Future<BaseResponse> forgotPassword(String email) =>
      _apiProvider.forgotPassword(email);

  Future<BaseResponse> register(
          String userName, String email, String password, String phoneNumber) =>
      _apiProvider.register(userName, email, password, phoneNumber);

  Future<BaseResponse> changePassword(
          String email, String password, String code) =>
      _apiProvider.changePassword(email, password, code);
}
