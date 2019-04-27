import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/data/repositories/user-repository.dart';
import 'package:myfootball/models/responses/login-response.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc implements BaseBloc {
  var _userRepository = UserRepository();

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
   Observable<LoginResponse> get loginEmailStream =>
      Observable(_submitLoginCtrl).flatMap((_) => Observable.fromFuture(_userRepository.loginWithEmail(
                _emailCtrl.value, _passwordCtrl.value))
            .doOnListen(() => addLoadingFunc(true))
            .doOnData((_) => addLoadingFunc(false)))
        .flatMap((res) => Observable.just(res));

  @override
  void dispose() {
    _loadingCtrl.close();
    _emailCtrl.close();
    _passwordCtrl.close();
    _submitLoginCtrl.close();
  }

  @override
  void initState() {
  }
}
