import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/blocs/noti-bloc.dart';
import 'package:myfootball/blocs/user-bloc.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/ui/pages/noti-page.dart';
import 'package:myfootball/ui/pages/user-page.dart';

class HomePage extends StatelessWidget {
  final _userTab = BlocProvider<UserBloc>(
    bloc: UserBloc(),
    child: UserPage(),
  );

  final _notifyTab = BlocProvider<NotiBloc>(
    bloc: NotiBloc(),
    child: NotiPage(),
  );

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: AppColor.GREEN,
        currentIndex: 1,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, size: 25),
            title: Text('Thông báo',
                style: TextStyle(fontFamily: 'semi-bold', fontSize: 10)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 25),
            title: Text(
              'Cá nhân',
              style: TextStyle(fontFamily: 'semi-bold', fontSize: 10),
            ),
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        assert(index >= 0 && index <= 4);
        switch (index) {
          case 0:
            return CupertinoTabView(
                builder: (BuildContext context) => _notifyTab);
            break;
          case 1:
            return CupertinoTabView(
                builder: (BuildContext context) => _userTab);
            break;
        }
        return null;
      },
    );
  }
}
