import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/data/repositories/user-repository.dart';
import 'package:myfootball/models/responses/base-response.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc implements BaseBloc {
  var _userRepository = UserRepository();

  final _loadingCtrl = PublishSubject<bool>();
  Function(bool) get addLoadingFunc => _loadingCtrl.add;
  Observable<bool> get loadingStream => Observable(_loadingCtrl);

  final _userNameCtrl = BehaviorSubject<String>();
  Function(String) get changeUsernameFunc => _userNameCtrl.add;
  Observable<String> get changeUsernameStream => Observable(_userNameCtrl);

  final _emailCtrl = BehaviorSubject<String>();
  Function(String) get changeEmailFunc => _emailCtrl.add;
  Observable<String> get changeEmailStream => Observable(_emailCtrl);

  final _passwordCtrl = BehaviorSubject<String>();
  Function(String) get changePasswordFunc => _passwordCtrl.add;
  Observable<String> get changePasswordStream => Observable(_passwordCtrl);

  final _phonenumberCtrl = BehaviorSubject<String>();
  Function(String) get changePhoneNumberFunc => _phonenumberCtrl.add;
  Observable<String> get changePhoneNumberStream =>
      Observable(_phonenumberCtrl);

  final _submitRegisterCtrl = BehaviorSubject<bool>();
  Function(bool) get submitRegisterFunc => _submitRegisterCtrl.add;
  Observable<BaseResponse> get registerStream => Observable(_submitRegisterCtrl)
      .flatMap((_) => Observable.fromFuture(_userRepository.register(
              _userNameCtrl.value,
              _emailCtrl.value,
              _passwordCtrl.value,
              _phonenumberCtrl.value))
          .doOnListen(() => addLoadingFunc(true))
          .doOnData((_) => addLoadingFunc(false)))
      .flatMap((res) => Observable.just(res));

  @override
  void dispose() {
    _loadingCtrl.close();
    _emailCtrl.close();
    _passwordCtrl.close();
    _userNameCtrl.close();
    _phonenumberCtrl.close();
    _submitRegisterCtrl.close();
  }

  @override
  void initState() {}
}
