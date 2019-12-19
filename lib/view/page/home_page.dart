import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/fonts.dart';
import 'package:myfootball/view/page/social/ranking_page.dart';
import 'package:myfootball/view/page/social/social_page.dart';
import 'package:myfootball/view/page/team/team_page.dart';
import 'package:myfootball/view/page/user/user_page.dart';

import 'notification/notification_page.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  final List<BottomNavigationBarItem> tabBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.rss_feed, size: 25),
      title: Text('Cộng đồng',
          style: TextStyle(fontSize: 10, fontFamily: REGULAR)),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.equalizer, size: 25),
      title:
          Text('Xếp hạng', style: TextStyle(fontSize: 10, fontFamily: REGULAR)),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.people, size: 25),
      title:
          Text('Đội bóng', style: TextStyle(fontSize: 10, fontFamily: REGULAR)),
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

  //verified_user

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        activeColor: PRIMARY,
        items: tabBarItems,
        currentIndex: 2,
      ),
      tabBuilder: (BuildContext context, int index) {
        if (index == 0)
          return CupertinoTabView(
              builder: (BuildContext context) => SocialPage());
        if (index == 1)
          return CupertinoTabView(
              builder: (BuildContext context) => RankingPage());
        if (index == 2)
          return CupertinoTabView(
              builder: (BuildContext context) => TeamPage());
        if (index == 3)
          return CupertinoTabView(
              builder: (BuildContext context) => NotificationPage());
        if (index == 4)
          return CupertinoTabView(
              builder: (BuildContext context) => UserPage());
        return null;
      },
    );
  }
}
