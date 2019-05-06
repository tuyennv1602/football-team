import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/data/app-preference.dart';
import 'package:myfootball/data/providers/user-provider.dart';
import 'package:myfootball/models/header.dart';
import 'package:myfootball/models/responses/login-response.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc implements BaseBloc {
  var _userProvider = UserApiProvider();
  var _appPref = AppPreference();

  final _loadingCtrl = PublishSubject<bool>();
  Function(bool) get addLoadingFunc => _loadingCtrl.add;
  Observable<bool> get loadingStream => Observable(_loadingCtrl);

  final _emailCtrl = BehaviorSubject<String>();
  Function(String) get changeEmailFunc => _emailCtrl.add;
  Observable<String> get changeEmailStream => Observable(_emailCtrl);

  final _passwordCtrl = BehaviorSubject<String>();
  Function(String) get changePasswordFunc => _passwordCtrl.add;
  Observable<String> get changePasswordStream => Observable(_passwordCtrl);

  final _submitLoginCtrl = PublishSubject<bool>();
  Function(bool) get submitLoginEmailFunc => _submitLoginCtrl.add;
  Observable<LoginResponse> get loginEmailStream => Observable(_submitLoginCtrl)
      .flatMap((_) => Observable.fromFuture(_userProvider.loginWithEmail(
              _emailCtrl.value, _passwordCtrl.value))
          .doOnListen(() => addLoadingFunc(true))
          .doOnData((_) => addLoadingFunc(false)))
      .flatMap((res) => Observable.fromFuture(_handleLogin(res)))
      .flatMap((res) => Observable.just(res));

  Future<LoginResponse> _handleLogin(LoginResponse response) async {
    if (response.success) {
      await _appPref.setToken(response.token);
      await _appPref.setUser(response.user);
      await _appPref.setHeader(
          Header(accessToken: response.token, userId: response.user.id));
    }
    return Future.value(response);
  }

  @override
  void dispose() {
    _loadingCtrl.close();
    _emailCtrl.close();
    _passwordCtrl.close();
    _submitLoginCtrl.close();
  }

  @override
  void initState() {}
}
