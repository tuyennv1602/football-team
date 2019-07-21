import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/data/app-api.dart';
import 'package:myfootball/data/app-preference.dart';
import 'package:myfootball/models/header.dart';
import 'package:myfootball/models/user.dart';
import 'package:rxdart/rxdart.dart';

class AppBloc implements BaseBloc {
  var _appPref = AppPreference();

  final _userCtrl = BehaviorSubject<User>();
  Function(User) get setUserFunc => _userCtrl.add;
  Observable<User> get userStream => Observable(_userCtrl);

  Future<User> updateUser() async {
    var user = await _appPref.getUser();
    setUserFunc(user);
    return Future.value(user);
  }

  void init() async {
    var user = await _appPref.getUser();
    var token = await _appPref.getToken();
    if (user != null && token != null) {
      AppApi.setHeader(Header(accessToken: token, userId: user.id));
      setUserFunc(user);
    }
  }

  @override
  void dispose() {
    _userCtrl.close();
  }

  @override
  void initState() {
    init();
  }
}
