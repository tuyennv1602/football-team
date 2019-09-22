import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/data/app-api.dart';
import 'package:myfootball/data/app-preference.dart';
import 'package:myfootball/data/repositories/user-repository.dart';
import 'package:myfootball/models/headers.dart';
import 'package:myfootball/models/responses/login-response.dart';
import 'package:myfootball/models/token.dart';
import 'package:myfootball/models/user.dart';
import 'package:rxdart/rxdart.dart';

class AppBloc extends BaseBloc {
  var _appPref = AppPreference();
  var _userRepo = UserRepository();

  final _userCtrl = BehaviorSubject<User>();

  Function(User) get setUserFunc => _userCtrl.add;

  Observable<User> get userStream => Observable(_userCtrl);

  final _refreshTokenCtrl = PublishSubject<String>();

  Function(String) get refreshTokenFunc => _refreshTokenCtrl.add;

  Observable<bool> get refreshTokenStream => Observable(_refreshTokenCtrl)
      .flatMap(
          (refreshToken) => Observable.fromFuture(_refreshToken(refreshToken)))
      .flatMap((resp) => Observable.fromFuture(_handleLoginResp(resp)))
      .flatMap((resp) => Observable.just(resp));

  Future<LoginResponse> _refreshToken(String refreshToken) async {
    return _userRepo.refreshToken(refreshToken);
  }

  Future<bool> _handleLoginResp(LoginResponse response) async {
    if (response.isSuccess) {
      await _appPref.setToken(
          Token(token: response.token, refreshToken: response.refreshToken));
      await _appPref.setUser(response.user);
      AppApi.setHeader(Headers(accessToken: response.token));
      setUserFunc(response.user);
      return Future.value(true);
    } else {
      _logout();
      return Future.value(false);
    }
  }

  Future<bool> _logout() async {
    var token = await _appPref.clearToken();
    var user = await _appPref.clearUser();
    return Future.value(token && user);
  }

  Future<User> updateUser() async {
    var user = await _appPref.getUser();
    setUserFunc(user);
    return Future.value(user);
  }

  _init() async {
    var token = await _appPref.getToken();
    if (token != null) {
      refreshTokenFunc(token.refreshToken);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _userCtrl.close();
    _refreshTokenCtrl.close();
  }

  @override
  void initState() {
    _init();
  }
}
