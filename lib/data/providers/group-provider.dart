import 'package:dio/dio.dart';
import 'package:myfootball/data/app-api.dart';
import 'package:myfootball/data/app-preference.dart';
import 'package:myfootball/models/group.dart';
import 'package:myfootball/models/responses/create-group-response.dart';

class GroupProvider {
  static final GroupProvider _instance = GroupProvider.internal();
  factory GroupProvider() => _instance;
  GroupProvider.internal();

  Future<CreateGroupResponse> createGroup(Group group) async {
    try {
      var user = await AppPreference().getUser();
      var response = await AppApi.postApi('group/create', body: {
        "manager": user.id,
        "name": group.name,
        "dress": group.dress,
        "bio": group.bio,
        "logo": group.logo
      });
      return CreateGroupResponse.success(response.data);
    } on DioError catch (e) {
      return CreateGroupResponse.error(e.message);
    }
  }
}
