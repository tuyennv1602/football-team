import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/data/app-preference.dart';
import 'package:myfootball/data/repositories/team-repository.dart';
import 'package:myfootball/data/repositories/user-repository.dart';
import 'package:myfootball/models/responses/base-response.dart';
import 'package:myfootball/models/team.dart';
import 'package:rxdart/rxdart.dart';

class RequestMemberBloc extends BaseBloc {
  final _teamRepository = TeamReposiroty();
  final _userRepo = UserRepository();

  final _changeKeyCtrl = PublishSubject<String>();
  Function(String) get changeKeyFunc => _changeKeyCtrl.add;
  Observable<String> get changeKeyStream => Observable(_changeKeyCtrl).debounce(Duration(milliseconds: 200));
  
  final _searchTeamCtrl = BehaviorSubject<String>();
  Function(String) get searchTeamFunc => _searchTeamCtrl.add;
  Observable<List<Team>> get getAllTeamsStream => Observable(_searchTeamCtrl)
      .flatMap((key) => Observable.fromFuture(_teamRepository.searchTeamByKey(key))
      .flatMap((resp) => Observable.just(resp.teams)));

  final _contentCtrl = BehaviorSubject<String>();
  Function(String) get changeContentFunc => _contentCtrl.add;
  Observable<String> get changeContentStream => Observable(_contentCtrl);

  final _submitRequestCtrl = PublishSubject<int>();
  Function(int) get submitRequestFunc => _submitRequestCtrl.add;
  Observable<BaseResponse> get requestMemberStream => Observable(_submitRequestCtrl)
      .flatMap((teamId) => Observable.fromFuture(_createRequestMember(teamId))
          .doOnListen(() => setLoadingFunc(true))
          .doOnDone(() => setLoadingFunc(false))
          .doOnError(() => setLoadingFunc(false)))
      .flatMap((resp) => Observable.just(resp));

  Future<BaseResponse> _createRequestMember(int teamId) async {
    var user = await AppPreference().getUser();
    return _userRepo.createRequestMember(user.id, teamId, _contentCtrl.value);
  }

  @override
  void dispose() {
    _searchTeamCtrl.close();
    _contentCtrl.close();
    _submitRequestCtrl.close();
    _changeKeyCtrl.close();
  }

  @override
  void initState() {
    searchTeamFunc('');
  }
}
