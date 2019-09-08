import 'package:myfootball/blocs/base-bloc.dart';
import 'package:rxdart/rxdart.dart';

class NotiBloc extends BaseBloc {
  final _notiCtrl = BehaviorSubject<bool>();
  Function(bool) get changeNotiFunc => _notiCtrl.add;
  Observable<bool> get notiStream => Observable(_notiCtrl);

  @override
  void dispose() {
    _notiCtrl.close();
  }
}
