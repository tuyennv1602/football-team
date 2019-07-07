import 'package:dio/dio.dart';
import 'package:myfootball/data/app-api.dart';
import 'package:myfootball/data/app-preference.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/responses/create-team-response.dart';

class TeamProvider {
  static final TeamProvider _instance = TeamProvider.internal();
  factory TeamProvider() => _instance;
  TeamProvider.internal();

  Future<CreateTeamResponse> createGroup(Team group) async {
    try {
      var user = await AppPreference().getUser();
      var response = await AppApi.postApi('group/create', body: {
        "manager": user.id,
        "name": group.name,
        "dress": group.dress,
        "bio": group.bio,
        "logo": group.logo
      });
      return CreateTeamResponse.success(response.data);
    } on DioError catch (e) {
      return CreateTeamResponse.error(e.message);
    }
  }
}
