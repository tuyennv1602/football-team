import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/data/repositories/team-repository.dart';
import 'package:myfootball/data/repositories/user-repository.dart';
import 'package:myfootball/models/responses/base-response.dart';
import 'package:myfootball/models/team.dart';
import 'package:rxdart/rxdart.dart';

class RequestMemberBloc implements BaseBloc {
  final _teamReposiroty = TeamReposiroty();
  final _userRepo = UserRepository();

  final _loadingCtrl = PublishSubject<bool>();
  Function(bool) get addLoadingFunc => _loadingCtrl.add;
  Observable<bool> get loadingStream => Observable(_loadingCtrl);

  final _getAllTeamCtrl = BehaviorSubject<bool>();
  Function(bool) get getAllTeamsFunc => _getAllTeamCtrl.add;
  Observable<List<Team>> get getAllTeamsStream => Observable(_getAllTeamCtrl)
      .flatMap((_) => Observable.fromFuture(_teamReposiroty.getAllTeams())
          .doOnListen(() => addLoadingFunc(true))
          .doOnError(() => addLoadingFunc(false))
          .doOnData((_) => addLoadingFunc(false)))
      .flatMap((resp) => Observable.just(resp.teams));

  final _contentCtrl = BehaviorSubject<String>();
  Function(String) get changeContentFunc => _contentCtrl.add;
  Observable<String> get changeContentStream => Observable(_contentCtrl);

  final _submitRequestCtrl = PublishSubject<int>();
  Function(int) get submitRequestFunc => _submitRequestCtrl.add;
  Observable<BaseResponse> get requestMemberStream => Observable(_submitRequestCtrl)
      .flatMap((teamId) =>
          Observable.fromFuture(_userRepo.createRequestMember(teamId, _contentCtrl.value))
              .doOnListen(() => addLoadingFunc(true))
              .doOnData((_) => addLoadingFunc(false))
              .doOnError(() => addLoadingFunc(false)))
      .flatMap((resp) => Observable.just(resp));

  @override
  void dispose() {
    _loadingCtrl.close();
    _getAllTeamCtrl.close();
    _contentCtrl.close();
    _submitRequestCtrl.close();
  }

  @override
  void initState() {
    getAllTeamsFunc(true);
  }
}
