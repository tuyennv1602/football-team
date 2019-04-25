import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/data/repositories/user-repository.dart';
import 'package:myfootball/models/requests/login-request.dart';
import 'package:myfootball/models/responses/login-response.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc implements BaseBloc {
  
  var _userRepository = UserRepository();
  var _loginRequest;

  final _loadingCtrl = BehaviorSubject<bool>();
  Function(bool) get addLoadingFunc => _loadingCtrl.add;
  Observable<bool> get loadingStream => Observable(_loadingCtrl);

  final _loginWithEmailCtrl = BehaviorSubject<LoginResponse>();
  Function(LoginResponse) get addLoginEmailFunc => _loginWithEmailCtrl.add;
  Observable<LoginResponse> get loginEmailStream => Observable(_loginWithEmailCtrl);

  final _emailCtrl = BehaviorSubject<String>();
  Function(String) get changeEmailFunc => _emailCtrl.add;
  Observable<String> get changeEmailStream => Observable(_emailCtrl);

  final _passwordCtrl = BehaviorSubject<String>();
  Function(String) get changePasswordFunc => _passwordCtrl.add;
  Observable<String> get changePasswordStream => Observable(_passwordCtrl);

  submitLogin() async {
    addLoadingFunc(true);
    var response = await _userRepository.loginWithEmail(
        _loginRequest.email, _loginRequest.password);
    addLoginEmailFunc(response);
    addLoadingFunc(false);
  }

  @override
  void dispose() {
    _loadingCtrl.close();
    _loginWithEmailCtrl.close();
    _emailCtrl.close();
    _passwordCtrl.close();
  }

  @override
  void initState() {
    Observable.combineLatest2(
      changeEmailStream,
      changePasswordStream,
      (email, password) => LoginRequest(email, password),
    ).listen((loginRequest) => _loginRequest = loginRequest);
  }
}
