import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/blocs/team-bloc.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/user.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/routes/routes.dart';
import 'package:myfootball/ui/widgets/app-bar-button.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:myfootball/ui/widgets/border-frame.dart';
import 'package:myfootball/ui/widgets/item-option.dart';
import 'package:myfootball/ui/widgets/team-avatar.dart';

// ignore: must_be_immutable
class TeamPage extends BasePage<TeamBloc> {
  Widget _buildEmptyGroup(BuildContext context) => Column(
        children: <Widget>[
          Expanded(
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
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(color: AppColor.MAIN_BLACK),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () => Routes.routeToRequestMemberPage(context),
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

  Widget _buildGroupPanel(BuildContext context, Team team) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: BorderFrameWidget(
        child: GridView.count(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          physics: ClampingScrollPhysics(),
          mainAxisSpacing: 10,
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

  Widget _buildGroupManager(BuildContext context, Team team) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              'Quản trị đội bóng',
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(color: AppColor.MAIN_BLACK),
            ),
          ),
          BorderFrameWidget(
            child: GridView.count(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              physics: ClampingScrollPhysics(),
              mainAxisSpacing: 10,
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
  AppBarWidget buildAppBar(BuildContext context) => AppBarWidget(
        leftContent: StreamBuilder<User>(
          stream: appBloc.userStream,
          builder: (c, snap) {
            if (snap.hasData && snap.data.teams.length > 1) {
              return AppBarButtonWidget(
                imageName: Images.SWITCH_TEAM,
                onTap: () => {},
              );
            }
            return AppBarButtonWidget();
          },
        ),
        rightContent: AppBarButtonWidget(),
        centerContent: StreamBuilder<Team>(
          stream: pageBloc.changeTeamStream,
          builder: (c, snap) {
            return Text(
              (snap.hasData && snap.data != null) ? snap.data.name : 'Đội bóng',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.title,
            );
          },
        ),
      );

  @override
  Widget buildMainContainer(BuildContext context) {
    return StreamBuilder<Team>(
      stream: pageBloc.changeTeamStream,
      builder: (c, snap) {
        if (snap.hasData) {
          var team = snap.data;
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                  color: AppColor.GREEN,
                ),
                child: Row(
                  children: <Widget>[
                    TeamAvatarWidget(source: team.logo, size: 80),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              team.bio,
                              style: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .copyWith(color: AppColor.WHITE),
                            ),
                            Divider(
                              height: 10,
                              color: AppColor.WHITE,
                            ),
                            Text('Trình độ: Trung bình',
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(color: AppColor.WHITE)),
                            Row(
                              children: <Widget>[
                                Text('Đánh giá:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .body1
                                        .copyWith(color: AppColor.WHITE)),
                                FlutterRatingBarIndicator(
                                  rating: 2.5,
                                  itemCount: 5,
                                  itemSize: 15,
                                  emptyColor: Colors.amber.withAlpha(90),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    _buildGroupPanel(context, team),
                    _buildGroupManager(context, team)
                  ],
                ),
              )
            ],
          );
        }
        return _buildEmptyGroup(context);
      },
    );
  }

  @override
  void listenData(BuildContext context) {
    appBloc.userStream.listen((user) {
      if (user.teams.length > 0) {
        pageBloc.changeTeamFunc(user.teams[0]);
      }
    });
  }

  @override
  bool get hasBottomBar => true;
}
