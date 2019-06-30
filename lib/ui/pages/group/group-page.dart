import 'package:flutter/material.dart';
import 'package:myfootball/blocs/app-bloc.dart';
import 'package:myfootball/blocs/group-bloc.dart';
import 'package:myfootball/models/type-user.dart';
import 'package:myfootball/models/user.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/routes/routes.dart';
import 'package:myfootball/ui/widgets/app-bar-button.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';

class GroupPage extends BasePage<GroupBloc> {
  @override
  AppBarWidget buildAppBar(BuildContext context) => AppBarWidget(
        centerContent: Center(
          child: Text(
            'Đội bóng',
            style: Theme.of(context).textTheme.title,
          ),
        ),
        leftContent: AppBarButtonWidget(
          padding: 12,
          imageName: 'icn_add_request.png',
          onTap: () => Routes.routeToRequestMemberPage(context),
        ),
        rightContent: AppBarButtonWidget(
          padding: 12,
          imageName: 'icn_add_group.png',
          onTap: () => Routes.routeToCreateGroupPage(context),
        ),
      );

  @override
  Widget buildLoading(BuildContext context) => null;

  Widget _buildEmptyGroup(BuildContext context, User user) => Column(
        children: <Widget>[
          (user.getRoleType() == USER_ROLE.TEAM_MANAGER || user.getRoleType() == USER_ROLE.ALL)
              ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () => Routes.routeToCreateGroupPage(context),
                        child: Image.asset(
                          'assets/images/icn_add_group.png',
                          color: AppColor.GREEN,
                          width: 50,
                          height: 50,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Đăng ký đội bóng mới',
                        style:
                            Theme.of(context).textTheme.title.copyWith(color: AppColor.MAIN_BLACK),
                      )
                    ],
                  ),
                )
              : SizedBox(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () => print('create'),
                  child: Image.asset(
                    'assets/images/icn_add_request.png',
                    color: AppColor.GREEN,
                    width: 50,
                    height: 50,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Tham gia đội bóng',
                  style: Theme.of(context).textTheme.title.copyWith(color: AppColor.MAIN_BLACK),
                )
              ],
            ),
          )
        ],
      );

  @override
  Widget buildMainContainer(BuildContext context) {
    return StreamBuilder<User>(
      stream: appBloc.userStream,
      builder: (c, snap) {
        if (snap.hasData) {
          var _user = snap.data;
          if (_user.groups != null && _user.groups.length != 0) {
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                    color: AppColor.GREEN,
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(_user.groups[0].logo),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child:
                              Text(_user.groups[0].name, style: Theme.of(context).textTheme.title),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return _buildEmptyGroup(context, _user);
          }
        }
        return SizedBox();
      },
    );
  }

  @override
  void listenAppData(BuildContext context) {}

  @override
  void listenPageData(BuildContext context) {}
}
