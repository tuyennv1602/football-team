import 'package:myfootball/data/providers/user-provider.dart';
import 'package:myfootball/models/device-info.dart';
import 'package:myfootball/models/responses/base-response.dart';
import 'package:myfootball/models/responses/login-response.dart';
import 'package:myfootball/models/responses/user-request-response.dart';

class UserRepository {
  UserProvider _userProvider = UserProvider();

  Future<LoginResponse> loginWithEmail(String email, String password) async {
    return _userProvider.loginWithEmail(email, password);
  }

  Future<BaseResponse> forgotPassword(String email) async {
    return _userProvider.forgotPassword(email);
  }

  Future<BaseResponse> register(
      String name, String email, String password, String phoneNumber, List<int> roles) async {
    return _userProvider.register(name, email, password, phoneNumber, roles);
  }

  Future<BaseResponse> changePassword(String email, String password, String code) async {
    return _userProvider.changePassword(email, password, code);
  }

  Future<BaseResponse> createRequestMember(int userId, int teamId, String content) async {
    return _userProvider.createRequestMember(userId, teamId, content);
  }

  Future<BaseResponse> cancelRequestMember(int requestId) async {
    return _userProvider.cancelRequestMember(requestId);
  }

  Future<LoginResponse> refreshToken(String refreshToken) async {
    return _userProvider.refreshToken(refreshToken);
  }

  Future<BaseResponse> registerDevice(DeviceInfo deviceInfo) async {
    return _userProvider.registerDevice(deviceInfo);
  }

  Future<UserRequestResponse> getUserRequests() async {
    return _userProvider.getUserRequests();
  }
}
