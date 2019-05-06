import 'package:flutter/material.dart';
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
          imageName: 'icn_request_member.png',
          onTap: () {},
        ),
        rightContent: AppBarButtonWidget(
          imageName: 'icn_add.png',
          onTap: () => Routes.routeToCreateGroupPage(context),
        ),
      );

  @override
  Widget buildLoading(BuildContext context) => null;

  Widget _buildEmptyGroup(BuildContext context, User user) => Column(
        children: <Widget>[
          (user.getRoleType() == USER_ROLE.TEAM_MANAGER ||
                  user.getRoleType() == USER_ROLE.ALL)
              ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () => Routes.routeToCreateGroupPage(context),
                        child: Image.asset(
                          'assets/images/icn_add.png',
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
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(color: AppColor.MAIN_BLACK),
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
                    'assets/images/icn_request_member.png',
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
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(color: AppColor.MAIN_BLACK),
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
            return Container(
              child: Text('has group'),
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

  @override
  bool resizeAvoidPadding() {
    return null;
  }

  @override
  bool showFullScreen() {
    return null;
  }
}
