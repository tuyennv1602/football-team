import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/data/app-preference.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc implements BaseBloc {
  var _appPref = AppPreference();

  final _loadingCtrl = PublishSubject<bool>();
  Function(bool) get addLoadingFunc => _loadingCtrl.add;
  Observable<bool> get loadingStream => Observable(_loadingCtrl);

  final _logoutCtrl = BehaviorSubject<bool>();
  Function(bool) get logoutFunc => _logoutCtrl.add;
  Observable<bool> get logoutStream => Observable(_logoutCtrl)
      .flatMap((_) => Observable.fromFuture(_logout())
          .doOnListen(() => addLoadingFunc(true))
          .doOnData((_) => addLoadingFunc(false)))
      .flatMap((result) => Observable.just(result));

  Future<bool> _logout() async {
    var token = await _appPref.clearToken();
    var user = await _appPref.clearUser();
    return Future.value(token && user);
  }

  @override
  void dispose() {
    _logoutCtrl.close();
    _loadingCtrl.close();
  }

  @override
  void initState() {}
}
