import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/blocs/chat-bloc.dart';
import 'package:myfootball/blocs/ground-bloc.dart';
import 'package:myfootball/blocs/group-bloc.dart';
import 'package:myfootball/blocs/noti-bloc.dart';
import 'package:myfootball/blocs/social-bloc.dart';
import 'package:myfootball/blocs/user-bloc.dart';
import 'package:myfootball/models/type-user.dart';
import 'package:myfootball/models/user.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/ui/pages/chat-page.dart';
import 'package:myfootball/ui/pages/ground-page.dart';
import 'package:myfootball/ui/pages/group-page.dart';
import 'package:myfootball/ui/pages/noti-page.dart';
import 'package:myfootball/ui/pages/social-page.dart';
import 'package:myfootball/ui/pages/user-page.dart';

class HomePage extends StatelessWidget {
  USER_ROLE _roleType;

  HomePage(User user) {
    _roleType = user.getRoleType();
  }

  final _userTab = BlocProvider<UserBloc>(
    bloc: UserBloc(),
    child: UserPage(),
  );

  final _notifyTab = BlocProvider<NotiBloc>(
    bloc: NotiBloc(),
    child: NotiPage(),
  );

  final _chatTab = BlocProvider<ChatBloc>(
    bloc: ChatBloc(),
    child: ChatPage(),
  );

  final _groupTab = BlocProvider<GroupBloc>(
    bloc: GroupBloc(),
    child: GroupPage(),
  );

  final _groundTab = BlocProvider<GroundBloc>(
    bloc: GroundBloc(),
    child: GroundPage(),
  );

  final _socialTab = BlocProvider<SocialBloc>(
    bloc: SocialBloc(),
    child: SocialPage(),
  );

  final _groundItem = BottomNavigationBarItem(
    icon: Icon(Icons.flag, size: 25),
    title: Text('Sân bóng', style: TextStyle(fontSize: 10)),
  );

  final _groupItem = BottomNavigationBarItem(
    icon: Icon(Icons.group_work, size: 25),
    title: Text('Đội bóng', style: TextStyle(fontSize: 10)),
  );

  List<BottomNavigationBarItem> tabBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.rss_feed, size: 25),
      title: Text('Cộng đồng', style: TextStyle(fontSize: 10)),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.forum, size: 25),
      title: Text('Trò chuyện', style: TextStyle(fontSize: 10)),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.notifications, size: 25),
      title: Text('Thông báo', style: TextStyle(fontSize: 10)),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle, size: 25),
      title: Text(
        'Cá nhân',
        style: TextStyle(fontSize: 10),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (_roleType == USER_ROLE.TEAM_MANAGER ||
        _roleType == USER_ROLE.TEAM_MEMBER) {
      tabBarItems.insert(1, _groupItem);
    } else if (_roleType == USER_ROLE.GROUND_OWNER) {
      tabBarItems.insert(1, _groundItem);
    } else {
      tabBarItems.insert(1, _groundItem);
      tabBarItems.insert(2, _groupItem);
    }
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: AppColor.GREEN,
        items: tabBarItems,
      ),
      tabBuilder: (BuildContext context, int index) {
        if (index == 0)
          return CupertinoTabView(
              builder: (BuildContext context) => _socialTab);
        if (_roleType == USER_ROLE.ALL) {
          if (index == 1) {
            return CupertinoTabView(
                builder: (BuildContext context) => _groundTab);
          }
          if (index == 2) {
            return CupertinoTabView(
                builder: (BuildContext context) => _groupTab);
          }
        } else if (_roleType == USER_ROLE.GROUND_OWNER) {
          if (index == 1) {
            return CupertinoTabView(
                builder: (BuildContext context) => _groundTab);
          }
        } else {
          if (index == 1) {
            return CupertinoTabView(
                builder: (BuildContext context) => _groupTab);
          }
        }
        if (index == tabBarItems.length - 1)
          return CupertinoTabView(builder: (BuildContext context) => _userTab);
        if (index == tabBarItems.length - 2)
          return CupertinoTabView(
              builder: (BuildContext context) => _notifyTab);
        if (index == tabBarItems.length - 3)
          return CupertinoTabView(builder: (BuildContext context) => _chatTab);
      },
    );
  }
}