import 'package:myfootball/data/providers/group-provider.dart';
import 'package:myfootball/models/group.dart';
import 'package:myfootball/models/responses/create-group-response.dart';

class GroupReposiroty {
  GroupProvider _groupProvider = GroupProvider();

  Future<CreateGroupResponse> createGroup(Group group) async {
    return _groupProvider.createGroup(group);
  }
}
