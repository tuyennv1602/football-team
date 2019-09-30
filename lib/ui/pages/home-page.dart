import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/fonts.dart';
import 'package:myfootball/ui/pages/notify/notification-page.dart';
import 'package:myfootball/ui/pages/social/social-page.dart';
import 'package:myfootball/ui/pages/team/team-page.dart';
import 'package:myfootball/ui/pages/user/user-page.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  final List<BottomNavigationBarItem> tabBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.people, size: 25),
      title:
          Text('Đội bóng', style: TextStyle(fontSize: 10, fontFamily: REGULAR)),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.rss_feed, size: 25),
      title: Text('Cộng đồng',
          style: TextStyle(fontSize: 10, fontFamily: REGULAR)),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.notifications, size: 25),
      title: Text('Thông báo',
          style: TextStyle(fontSize: 10, fontFamily: REGULAR)),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle, size: 25),
      title: Text(
        'Cá nhân',
        style: TextStyle(fontSize: 10, fontFamily: REGULAR),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        activeColor: PRIMARY,
        items: tabBarItems,
        currentIndex: 0,
      ),
      tabBuilder: (BuildContext context, int index) {
        if (index == 0)
          return CupertinoTabView(
              builder: (BuildContext context) => TeamPage());
        if (index == 1)
          return CupertinoTabView(
              builder: (BuildContext context) => SocialPage());
        if (index == 2)
          return CupertinoTabView(
              builder: (BuildContext context) => NotificationPage());
        if (index == 3)
          return CupertinoTabView(
              builder: (BuildContext context) => UserPage());
        return null;
      },
    );
  }
}
