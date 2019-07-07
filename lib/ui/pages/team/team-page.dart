import 'package:flutter/material.dart';
import 'package:myfootball/blocs/team-bloc.dart';
import 'package:myfootball/models/type-user.dart';
import 'package:myfootball/models/user.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/routes/routes.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:myfootball/ui/widgets/border-frame.dart';
import 'package:myfootball/ui/widgets/item-option.dart';

class TeamPage extends BasePage<TeamBloc> {
  @override
  AppBarWidget buildAppBar(BuildContext context) => AppBarWidget(
        centerContent: Text(
          'Đội bóng',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title,
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
                          Images.ADD_GROUP,
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
                    Images.ADD_REQUEST,
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

  Widget _buildGroupPanel(BuildContext context, User user) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: BorderFrameWidget(
        child: GridView.count(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          crossAxisCount: 3,
          crossAxisSpacing: 15,
          physics: ClampingScrollPhysics(),
          mainAxisSpacing: 15,
          children: <Widget>[
            ItemOptionWidget(Images.MEMBER, 'Thành viên'),
            ItemOptionWidget(Images.SCHEDULE, 'Lịch thi đấu'),
            ItemOptionWidget(Images.GOAL, 'Thành tích'),
            ItemOptionWidget(Images.COMMENT, 'Thảo luận'),
            ItemOptionWidget(Images.INVITE, 'Mời bạn bè vào đội'),
            ItemOptionWidget(Images.FEEDBACK, 'Đề xuất'),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupManager(BuildContext context, User user) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              'Quản trị đội bóng',
              style: Theme.of(context).textTheme.title.copyWith(color: AppColor.MAIN_BLACK),
            ),
          ),
          BorderFrameWidget(
            child: GridView.count(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              crossAxisCount: 3,
              crossAxisSpacing: 15,
              physics: ClampingScrollPhysics(),
              mainAxisSpacing: 15,
              children: <Widget>[
                ItemOptionWidget(Images.FIND, 'Tìm đối'),
                ItemOptionWidget(Images.BOOKING, 'Đặt sân'),
                ItemOptionWidget(Images.MEMBER_MANAGE, 'Quản lý thành viên'),
                ItemOptionWidget(Images.EDIT_PROFILE, 'Sửa hồ sơ'),
                ItemOptionWidget(Images.ANALYTIC, 'Quản lý tài chính'),
                ItemOptionWidget(Images.ADMIN, 'Quản lý đội bóng'),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget buildMainContainer(BuildContext context) {
    return StreamBuilder<User>(
      stream: appBloc.userStream,
      builder: (c, snap) {
        if (snap.hasData) {
          var _groups = snap.data.groups;
          if (_groups != null && _groups.length != 0) {
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                    color: AppColor.GREEN,
                  ),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: _groups[0].logo != null
                            ? NetworkImage(_groups[0].logo)
                            : AssetImage('assets/images/icn_man.png'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _groups[0].name,
                              style: Theme.of(context).textTheme.title,
                            ),
                            Text(
                              _groups[0].bio,
                              style:
                                  Theme.of(context).textTheme.body2.copyWith(color: AppColor.WHITE),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      _buildGroupPanel(context, snap.data),
                      _buildGroupManager(context, snap.data)
                    ],
                  ),
                )
              ],
            );
          } else {
            return _buildEmptyGroup(context, snap.data);
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
