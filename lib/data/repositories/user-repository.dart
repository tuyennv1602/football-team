import 'package:myfootball/data/providers/user-provider.dart';
import 'package:myfootball/models/responses/base-response.dart';
import 'package:myfootball/models/responses/login-response.dart';

class UserRepository {
  UserProvider _userProvider = UserProvider();

  Future<LoginResponse> loginWithEmail(String email, String password) async {
    return _userProvider.loginWithEmail(email, password);
  }

  Future<BaseResponse> forgotPassword(String email) async {
    return _userProvider.forgotPassword(email);
  }

  Future<BaseResponse> register(
      String userName, String email, String password, String phoneNumber, List<int> roles) async {
    return _userProvider.register(userName, email, password, phoneNumber, roles);
  }

  Future<BaseResponse> changePassword(String email, String password, String code) async {
    return _userProvider.changePassword(email, password, code);
  }

  Future<BaseResponse> createRequestMember(int teamId, String content) async {
    return _userProvider.createRequestMember(teamId, content);
  }

  Future<BaseResponse> cancelRequestMember(int requestId) async {
    return _userProvider.cancelRequestMember(requestId);
  }
}
