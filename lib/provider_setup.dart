import 'package:myfootball/model/user.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/service/auth_services.dart';
import 'package:myfootball/service/local_storage.dart';
import 'package:myfootball/service/sqlite_services.dart';
import 'package:myfootball/service/team_services.dart';
import 'package:provider/provider.dart';

import 'model/team.dart';

// Define all provider in app
List<SingleChildCloneableWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

// These are classes/objects that do not depend on any other services to execute their logic
List<SingleChildCloneableWidget> independentServices = [
  Provider.value(value: Api()),
  Provider.value(value: LocalStorage()),
  Provider.value(value: SQLiteServices()),
];

// These are classes/object that depend on previously registered services
List<SingleChildCloneableWidget> dependentServices = [
  ProxyProvider2<Api, LocalStorage, AuthServices>(
      update: (context, api, sharePref, authenticationService) =>
          AuthServices(api: api, sharePreferences: sharePref)),
  ProxyProvider2<Api, LocalStorage, TeamServices>(
      update: (context, api, sharePref, teamServices) =>
          TeamServices(api: api, sharePreferences: sharePref))
];

// These are values that you want to consume directly in the UI
// You can add values here if you would have to introduce a property on most,
// if not all your models just to get the data out. In our case the user information.
// If we don't provide it here then all the models will have a user property on it.
// You could also just add it to the BaseModel
List<SingleChildCloneableWidget> uiConsumableProviders = [
  StreamProvider<User>(
    create: (context) =>
        Provider.of<AuthServices>(context, listen: false).user,
  ),
  StreamProvider<Team>(
    create: (context) =>
        Provider.of<TeamServices>(context, listen: false).team,
  )
];
