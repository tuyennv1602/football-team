import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/data/app-preference.dart';
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
    print(user.groups.length);
    return Future.value(user);
  }

  @override
  void dispose() {
    _userCtrl.close();
  }

  @override
  void initState() {}
}
