import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/data/app-preference.dart';
import 'package:myfootball/models/team.dart';
import 'package:rxdart/rxdart.dart';

class TeamBloc implements BaseBloc {
  final _selectTeamCtrl = BehaviorSubject<Team>();
  Function(Team) get changeTeamFunc => _selectTeamCtrl.add;
  Observable<Team> get changeTeamStream => Observable(_selectTeamCtrl);

  @override
  void dispose() {
    _selectTeamCtrl.close();
  }

  @override
  void initState() {}
}
