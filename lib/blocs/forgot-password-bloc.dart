import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/data/repositories/user-repository.dart';
import 'package:myfootball/models/responses/base-response.dart';
import 'package:rxdart/rxdart.dart';

class ForgotPasswordBloc implements BaseBloc {
  var _userRepo = UserRepository();

  final _loadingCtrl = PublishSubject<bool>();
  Function(bool) get addLoadingFunc => _loadingCtrl.add;
  Observable<bool> get loadingStream => Observable(_loadingCtrl);

  final _emailCtrl = BehaviorSubject<String>();
  Function(String) get changeEmailFunc => _emailCtrl.add;
  Observable<String> get changeEmailStream => Observable(_emailCtrl);

  final _passwordCtrl = BehaviorSubject<String>();
  Function(String) get changePasswordFunc => _passwordCtrl.add;
  Observable<String> get changePasswordStream => Observable(_passwordCtrl);

  final _confirmCodeCtrl = BehaviorSubject<String>();
  Function(String) get changeCodeFunc => _confirmCodeCtrl.add;
  Observable<String> get changeCodeStream => Observable(_confirmCodeCtrl);

  final _changeTypeCtrl = BehaviorSubject<bool>(seedValue: false);
  Function(bool) get changeTypeFunc => _changeTypeCtrl.add;
  Observable<bool> get changeTypeStream => Observable(_changeTypeCtrl);

  final _submitEmailCtrl = BehaviorSubject<bool>();
  Function(bool) get submitEmailFunc => _submitEmailCtrl.add;
  Observable<BaseResponse> get submitEmailStream => Observable(_submitEmailCtrl)
      .flatMap((_) => Observable.fromFuture(_userRepo.forgotPassword(_emailCtrl.value))
          .doOnListen(() => addLoadingFunc(true))
          .doOnData((_) => addLoadingFunc(false)))
      .flatMap((response) => Observable.just(response));

  final _submitChangePassword = BehaviorSubject<bool>();
  Function(bool) get submitChangePassword => _submitChangePassword.add;
  Observable<BaseResponse> get submitChangePasswordStream => Observable(_submitChangePassword)
      .flatMap((_) => Observable.fromFuture(_userRepo.changePassword(
              _emailCtrl.value, _passwordCtrl.value, _confirmCodeCtrl.value))
          .doOnListen(() => addLoadingFunc(true))
          .doOnData((_) => addLoadingFunc(false)))
      .flatMap((response) => Observable.just(response));

  submit() {
    if (_changeTypeCtrl.value) {
      submitChangePassword(true);
    } else {
      submitEmailFunc(true);
    }
  }

  @override
  void dispose() {
    _loadingCtrl.close();
    _emailCtrl.close();
    _submitEmailCtrl.close();
    _passwordCtrl.close();
    _confirmCodeCtrl.close();
    _changeTypeCtrl.close();
    _submitChangePassword.close();
  }

  @override
  void initState() {}
}
