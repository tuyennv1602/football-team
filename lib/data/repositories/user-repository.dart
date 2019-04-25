import 'package:myfootball/data/providers/user-provider.dart';
import 'package:myfootball/models/responses/login-response.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository.internal();
  factory UserRepository() => _instance;
  UserRepository.internal();

  UserApiProvider _apiProvider = UserApiProvider();

  Future<LoginResponse> loginWithEmail(String email, String password) {
    return _apiProvider.loginWithEmail(email, password);
  }
}
