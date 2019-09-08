import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/data/repositories/user-repository.dart';
import 'package:myfootball/models/responses/base-response.dart';
import 'package:myfootball/utils/constants.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc extends BaseBloc {
  var _userRepo = UserRepository();

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
  Observable<String> get changePhoneNumberStream => Observable(_phonenumberCtrl);

  final _submitRegisterCtrl = PublishSubject<bool>();
  Function(bool) get submitRegisterFunc => _submitRegisterCtrl.add;
  Observable<BaseResponse> get registerStream => Observable(_submitRegisterCtrl)
      .flatMap((_) => Observable.fromFuture(_register())
          .doOnListen(() => setLoadingFunc(true))
          .doOnError(() => setLoadingFunc(false))
          .doOnDone(() => setLoadingFunc(false)))
      .flatMap((res) => Observable.just(res));

  Future<BaseResponse> _register() async {
    return _userRepo.register(_userNameCtrl.value, _emailCtrl.value, _passwordCtrl.value,
        _phonenumberCtrl.value, [Constants.TEAM_LEADER]);
  }

  @override
  void dispose() {
    _emailCtrl.close();
    _passwordCtrl.close();
    _userNameCtrl.close();
    _phonenumberCtrl.close();
    _submitRegisterCtrl.close();
  }
}
