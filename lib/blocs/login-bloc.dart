import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/data/user-api.dart';
import 'package:myfootball/models/requests/login-request.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dio/dio.dart';

class LoginBloc implements BaseBloc {
  var _userApi = UserApi();

  final _loadingCtrl = BehaviorSubject<bool>();
  Function(bool) get addLoading => _loadingCtrl.add;
  Observable<bool> get loadingStream => Observable(_loadingCtrl);

  final _loginWithEmailCtrl = BehaviorSubject<LoginRequest>();
  Function(LoginRequest) get excuteLoginEmailFunc => _loginWithEmailCtrl.add;
  Observable<LoginRequest> get loginStream => Observable(_loginWithEmailCtrl);

  Observable<Response> login(String email, String password) =>
      Observable.fromFuture(_userApi.loginWithEmail(email, password))
          .doOnListen(() => addLoading(true))
          .doOnData((data) => addLoading(false))
          .flatMap((response) => Observable.just(response));

  @override
  void dispose() {
    _loadingCtrl.close();
    _loginWithEmailCtrl.close();
  }

  @override
  void initState() {
    loginStream.listen((loginRequest) {
      if (loginRequest != null) {
        login(loginRequest.email, loginRequest.password);
      }
    });
  }
}
