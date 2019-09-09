import 'package:dio/dio.dart';
import 'package:myfootball/data/app-api.dart';
import 'package:myfootball/models/responses/search-team-response.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/responses/create-team-response.dart';

class TeamProvider {
  Future<CreateTeamResponse> createTeam(Team team) async {
    try {
      var response = await AppApi.postApi('group/create', body: {
        "manager": team.userId,
        "name": team.name,
        "dress": team.dress,
        "bio": team.bio,
        "logo": team.logo
      });
      return CreateTeamResponse.success(response.data);
    } on DioError catch (e) {
      return CreateTeamResponse.error(e.message);
    }
  }

  Future<SearchTeamResponse> searchTeamByKey(String key) async {
    try {
      FormData formData = new FormData.from({
        'text_search': key,
      });
      var resp = await AppApi.getApi('group/search', queryParams: formData);
      return SearchTeamResponse.success(resp.data);
    } on DioError catch (e) {
      return SearchTeamResponse.error(e.message);
    }
  }
}
