import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/data/repositories/user-repository.dart';
import 'package:myfootball/models/responses/base-response.dart';
import 'package:rxdart/rxdart.dart';

class ForgotPasswordBloc implements BaseBloc {
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

  final _confirmCodeCtrl = BehaviorSubject<String>();
  Function(String) get changeCodeFunc => _confirmCodeCtrl.add;
  Observable<String> get changeCodeStream => Observable(_confirmCodeCtrl);

  final _submitEmailCtrl = BehaviorSubject<bool>();
  Function(bool) get submitEmailFunc => _submitEmailCtrl.add;
  Observable<BaseResponse> get submitEmailStream => Observable(_submitEmailCtrl)
      .flatMap((_) => Observable.fromFuture(
              _userRepository.forgotPassword(_emailCtrl.value))
          .doOnListen(() => addLoadingFunc(true))
          .doOnData((_) => addLoadingFunc(false)))
      .flatMap((response) => Observable.just(response));

  @override
  void dispose() {
    _loadingCtrl.close();
    _emailCtrl.close();
    _submitEmailCtrl.close();
    _passwordCtrl.close();
    _confirmCodeCtrl.close();
  }

  @override
  void initState() {}
}
