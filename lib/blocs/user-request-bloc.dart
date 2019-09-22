import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/data/repositories/user-repository.dart';
import 'package:myfootball/models/responses/user-request-response.dart';
import 'package:rxdart/rxdart.dart';

class UserRequestBloc extends BaseBloc {
  final _userRepo = UserRepository();

  final _userRequestCtrl = BehaviorSubject<bool>();

  Function(bool) get getUserRequests => _userRequestCtrl.add;

  Observable<UserRequestResponse> get getUserRequestStream =>
      Observable(_userRequestCtrl)
          .flatMap((_) => Observable.fromFuture(_userRepo.getUserRequests())
              .doOnListen(() => setLoadingFunc(true))
              .doOnError(() => setLoadingFunc(false))
              .doOnDone(() => setLoadingFunc(false)))
          .flatMap((resp) => Observable.just(resp));

  @override
  void dispose() {
    super.dispose();
    _userRequestCtrl.close();
  }

  @override
  void initState() {
    super.initState();
    getUserRequests(true);
    print('load');
  }
}
