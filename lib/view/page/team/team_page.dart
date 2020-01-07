import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/model/user.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/page/team/search_team_page.dart';
import 'package:myfootball/view/widget/customize_app_bar.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/backdrop.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/item_achievement.dart';
import 'package:myfootball/view/widget/line.dart';
import 'package:myfootball/view/widget/item_option.dart';
import 'package:myfootball/view/widget/customize_image.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/router/paths.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/view/widget/oval_bottom_clipper.dart';
import 'package:myfootball/view/widget/team_header.dart';
import 'package:myfootball/viewmodel/team_vm.dart';
import 'package:provider/provider.dart';

class TeamPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TeamState();
  }
}

class _TeamState extends State<TeamPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final GlobalKey<BackdropState> _backdropKey =
      GlobalKey<BackdropState>(debugLabel: 'Backdrop');

  _buildEmptyTeam(BuildContext context) => BorderBackground(
        child: Column(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () => Navigation.instance.navigateTo(CREATE_TEAM),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      Images.ADD_TEAM,
                      color: PRIMARY,
                      width: UIHelper.size50,
                      height: UIHelper.size50,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: UIHelper.size10),
                      child: Text(
                        'Thành lập đội bóng',
                        style: textStyleTitle(color: BLACK_TEXT),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => Navigation.instance.navigateTo(SEARCH_TEAM,
                    arguments: SEARCH_TYPE.REQUEST_MEMBER),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      Images.ADD_REQUEST,
                      color: PRIMARY,
                      width: UIHelper.size50,
                      height: UIHelper.size50,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: UIHelper.size10),
                      child: Text(
                        'Tham gia đội bóng',
                        style: textStyleTitle(color: BLACK_TEXT),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );

  _buildTeamOptions(BuildContext context, Team team, {Function onLeaveTeam}) {
    List<Widget> _children = [];
    List<Widget> _manager = [];
    var userId = Provider.of<User>(context).id;
    bool isManager = team.hasManager(userId);
    if (isManager) {
      _manager.addAll([
        ItemOption(
          Images.FIND_MATCH,
          'Tìm đối tác',
          iconColor: Colors.red,
          onTap: () => Navigation.instance.navigateTo(FIND_MATCHING),
        ),
        ItemOption(
          Images.INVITE,
          'Lời mời ghép đối',
          iconColor: Colors.purple,
          onTap: () => Navigation.instance.navigateTo(INVITE_REQUESTS),
        ),
        ItemOption(
          Images.BOOKING,
          'Quản lý đặt sân',
          iconColor: Colors.green,
          onTap: () => Navigation.instance.navigateTo(BOOKING_MANAGE),
        ),
        ItemOption(
          Images.MEMBER_MANAGE,
          'Yêu cầu gia nhập đội bóng',
          iconColor: Colors.teal,
          onTap: () => Navigation.instance.navigateTo(REQUEST_MEMBER),
        ),
      ]);
    }
    return Column(
      children: _children
        ..addAll(
          [
            ItemOption(Images.MEMBER, 'Thành viên',
                iconColor: Colors.green,
                onTap: () => Navigation.instance.navigateTo(MEMBERS)),
            ItemOption(
              Images.SCHEDULE,
              'Lịch thi đấu',
              iconColor: Colors.deepOrange,
              onTap: () => Navigation.instance.navigateTo(MATCH_SCHEDULE),
            ),
            ItemOption(
              Images.MATCH_HISTORY,
              'Lịch sử thi đấu',
              iconColor: Colors.blue,
              onTap: () => Navigation.instance.navigateTo(MATCH_HISTORY),
            ),
            ItemOption(
              Images.COMMENT,
              'Thảo luận',
              iconColor: Colors.green,
              onTap: () => Navigation.instance.navigateTo(CONVERSATION),
            ),
          ]
            ..addAll(_manager)
            ..addAll([
              ItemOption(
                Images.TRANSACTION_HISTORY,
                'Quỹ đội bóng',
                iconColor: Colors.amber,
                onTap: () => Navigation.instance.navigateTo(FINANCE),
              ),
              ItemOption(
                Images.CONNECT,
                'Mời bạn bè vào đội',
                iconColor: Colors.blueAccent,
              ),
            ])
            ..add(isManager
                ? ItemOption(
                    Images.SETTING,
                    'Thiết lập đội bóng',
                    iconColor: Colors.orange,
                    onTap: () => Navigation.instance.navigateTo(SETUP_TEAM),
                  )
                : SizedBox())
            ..add(
              team.managerId != userId
                  ? ItemOption(
                      Images.LEAVE_TEAM,
                      'Rời đội bóng',
                      iconColor: Colors.blueGrey,
                      onTap: () {
                        UIHelper.showConfirmDialog(
                            'Bạn có chắc chắn muốn rời đội bóng ${team.name}?',
                            onConfirmed: onLeaveTeam);
                      },
                    )
                  : SizedBox(),
            ),
        ),
    );
  }

  _buildSelectTeam(BuildContext context, List<Team> teams,
          Future onChangeTeam(Team team)) =>
      ListView.separated(
          padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
          physics: BouncingScrollPhysics(),
          itemBuilder: (c, index) {
            var _team = teams[index];
            return InkWell(
              onTap: () {
                onChangeTeam(_team);
                _backdropKey.currentState.toggleFrontLayer();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: UIHelper.size15, vertical: UIHelper.size10),
                child: Row(
                  children: <Widget>[
                    CustomizeImage(
                      source: _team.logo,
                      placeHolder: Images.DEFAULT_LOGO,
                      size: UIHelper.size35,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: UIHelper.size10),
                        child: Text(
                          _team.name,
                          style: textStyleMediumTitle(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (c, index) => LineWidget(),
          itemCount: teams.length);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    UIHelper().init(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: BaseWidget<TeamViewModel>(
        model: TeamViewModel(
          authServices: Provider.of(context),
          teamServices: Provider.of(context),
          api: Provider.of(context),
        ),
        onModelReady: (model) => model.refreshToken(),
        builder: (context, model, child) {
          var _teams = model.teams;
          var _team = Provider.of<Team>(context);
          var _hasGroup = _team != null;
          return Column(
            children: <Widget>[
              _hasGroup
                  ? SizedBox()
                  : CustomizeAppBar(
                      centerContent: Text(
                        'Đội bóng',
                        textAlign: TextAlign.center,
                        style: textStyleTitle(),
                      ),
                    ),
              Expanded(
                child: model.busy
                    ? BorderBackground(
                        child: LoadingWidget(),
                      )
                    : _hasGroup
                        ? Container(
                            child: Backdrop(
                              key: _backdropKey,
                              color: Colors.white,
                              backTitle: Align(
                                child: Text(
                                  'Chọn đội bóng',
                                  style: textStyleTitle(),
                                ),
                              ),
                              frontLayer: Container(
                                color: Colors.white,
                                child: ListView(
                                  padding: EdgeInsets.zero,
                                  physics: BouncingScrollPhysics(),
                                  children: <Widget>[
                                    TeamHeader(team: _team),
                                    _buildTeamOptions(
                                      context,
                                      _team,
                                      onLeaveTeam: () =>
                                          model.leaveTeam(_team.id),
                                    ),
                                  ],
                                ),
                              ),
                              backLayer: BorderBackground(
                                child: _buildSelectTeam(
                                  context,
                                  _teams,
                                  (team) async {
                                    UIHelper.showProgressDialog;
                                    await model.changeTeam(team);
                                    UIHelper.hideProgressDialog;
                                  },
                                ),
                              ),
                              frontTitle: Align(
                                child: Text(
                                  _team.name,
                                  style: textStyleTitle(),
                                ),
                              ),
                              frontTrailing: AppBarButton(
                                imageName: Images.SEARCH,
                                iconColor: Colors.white,
                                onTap: () => Navigation.instance.navigateTo(
                                    SEARCH_TEAM,
                                    arguments: SEARCH_TYPE.TEAM_DETAIL),
                              ),
                              frontHeading: Container(
                                width: double.infinity,
                                height: UIHelper.size40,
                                padding: EdgeInsets.only(top: UIHelper.size10),
                                alignment: Alignment.topCenter,
                                decoration: BoxDecoration(
                                  color: PRIMARY,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(UIHelper.radius),
                                    topRight: Radius.circular(UIHelper.radius),
                                  ),
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Color(0xFF02DC37), PRIMARY]),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 3,
                                      offset: Offset(0, -1),
                                    )
                                  ],
                                ),
                                child: Container(
                                  height: UIHelper.size5,
                                  width: UIHelper.size50,
                                  decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius:
                                        BorderRadius.circular(UIHelper.size(4)),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : _buildEmptyTeam(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
