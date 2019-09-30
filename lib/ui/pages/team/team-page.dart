import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/routes/routes.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:myfootball/ui/widgets/back-drop.dart';
import 'package:myfootball/ui/widgets/border-background.dart';
import 'package:myfootball/ui/widgets/button-widget.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/item-option.dart';
import 'package:myfootball/ui/widgets/image-widget.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/utils/ui-helper.dart';
import 'package:myfootball/viewmodels/team_view_model.dart';
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

  Widget _buildEmptyTeam(BuildContext context) => BorderBackground(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () => Routes.routeToCreateGroup(context),
                    child: Image.asset(
                      Images.ADD_TEAM,
                      color: PRIMARY,
                      width: UIHelper.size50,
                      height: UIHelper.size50,
                    ),
                  ),
                  UIHelper.verticalSpaceMedium,
                  Text(
                    'Đăng ký đội bóng mới',
                    style: textStyleTitle(color: BLACK_TEXT),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () => Routes.routeToRequestMember(context),
                    child: Image.asset(
                      Images.ADD_REQUEST,
                      color: PRIMARY,
                      width: UIHelper.size50,
                      height: UIHelper.size50,
                    ),
                  ),
                  UIHelper.verticalSpaceMedium,
                  Text(
                    'Tham gia đội bóng',
                    style: textStyleTitle(color: BLACK_TEXT),
                  )
                ],
              ),
            )
          ],
        ),
      );

  Widget _buildTeamMember(BuildContext context, Team team) {
    return Column(children: <Widget>[
      ItemOptionWidget(
        Images.MEMBER,
        'Thành viên',
        iconColor: Colors.indigoAccent,
        onTap: () => Routes.routeToMember(context, team.manager, team.members),
      ),
      LineWidget(),
      ItemOptionWidget(
        Images.SCHEDULE,
        'Lịch thi đấu',
        iconColor: Colors.deepOrange,
      ),
      LineWidget(),
      ItemOptionWidget(
        Images.RANK,
        'Thành tích',
        iconColor: Colors.amber,
      ),
      LineWidget(),
      ItemOptionWidget(
        Images.MATCH_HISTORY,
        'Lịch sử đối đầu',
        iconColor: Colors.lightGreen,
      ),
      LineWidget(),
      ItemOptionWidget(
        Images.COMMENT,
        'Thảo luận',
        iconColor: Colors.cyan,
      ),
      LineWidget(),
      ItemOptionWidget(
        Images.INVITE,
        'Mời bạn bè vào đội',
        iconColor: Colors.green,
      ),
      LineWidget(),
      ItemOptionWidget(
        Images.LEAVE_TEAM,
        'Rời đội bóng',
        iconColor: Colors.blueGrey,
      ),
      LineWidget(),
    ]);
  }

  Widget _buildTeamManager(BuildContext context, Team team) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              top: UIHelper.size20,
              left: UIHelper.size10,
              right: UIHelper.size10,
              bottom: UIHelper.size10),
          child: Text(
            'Quản trị đội bóng',
            style: textStyleSemiBold(color: PRIMARY),
          ),
        ),
        LineWidget(),
        ItemOptionWidget(
          Images.FIND_MATCH,
          'Tìm đối',
          iconColor: Colors.red,
        ),
        LineWidget(),
        ItemOptionWidget(
          Images.BOOKING,
          'Đặt sân',
          iconColor: Colors.green,
        ),
        LineWidget(),
        ItemOptionWidget(
          Images.EDIT_TEAM,
          'Sửa hồ sơ',
          iconColor: Colors.blue,
        ),
        LineWidget(),
        ItemOptionWidget(
          Images.MEMBER_MANAGE,
          'Quản lý thành viên',
          iconColor: Colors.amberAccent,
          onTap: () => Routes.routeToMemberManager(context),
        ),
        LineWidget(),
        ItemOptionWidget(
          Images.BUDGET,
          'Quản lý tài chính',
          iconColor: Colors.amber,
        ),
      ],
    );
  }

  Widget _buildHeaderWidget(BuildContext context, Team team) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: UIHelper.size15, vertical: UIHelper.size15),
      child: Row(
        children: <Widget>[
          ImageWidget(
              source: team.logo,
              placeHolder: Images.DEFAULT_LOGO,
              size: UIHelper.size(80)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: UIHelper.size15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    team.bio,
                    style: textStyleRegular(size: 16),
                  ),
                  Divider(
                    height: UIHelper.size10,
                    color: LINE_COLOR,
                  ),
                  Text('Trình độ: Trung bình', style: textStyleRegular()),
                  Row(
                    children: <Widget>[
                      Text('Đánh giá: ', style: textStyleRegular()),
                      team.rating != null
                          ? FlutterRatingBarIndicator(
                              rating: 2.5,
                              itemCount: 5,
                              itemSize: UIHelper.size15,
                              emptyColor: Colors.amber.withAlpha(90),
                            )
                          : Text('Chưa có đánh giá', style: textStyleRegular()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectTeam(BuildContext context, List<Team> teams,
          Function onChangeTeam(Team team)) =>
      ListView.separated(
          physics: BouncingScrollPhysics(),
          itemBuilder: (c, index) => ButtonWidget(
                backgroundColor: Colors.green,
                onTap: () {
                  onChangeTeam(teams[index]);
                  _backdropKey.currentState.toggleFrontLayer();
                },
                child: Text(
                  teams[index].name,
                  style: textStyleRegular(color: Colors.white, size: 16),
                ),
              ),
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
            sharePreferences: Provider.of(context),
            api: Provider.of(context)),
        onModelReady: (model) async {
          var resp = await model.refreshToken();
          if (!resp.isSuccess) {
            UIHelper.showSimpleDialog(resp.errorMessage,
                onTap: () => Routes.routeToLogin(context));
          }
        },
        builder: (context, model, child) {
          var _teams = model.teams;
          var _team = model.currentTeam;
          var _hasGroup = _team != null;
          return Column(
            children: <Widget>[
              _hasGroup
                  ? SizedBox()
                  : AppBarWidget(
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
                            padding: EdgeInsets.only(top: UIHelper.paddingTop),
                            color: PRIMARY,
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
                                  padding:
                                      EdgeInsets.only(top: UIHelper.size10),
                                  physics: BouncingScrollPhysics(),
                                  children: <Widget>[
                                    _buildHeaderWidget(context, _team),
                                    LineWidget(),
                                    _buildTeamMember(context, _team),
                                    _buildTeamManager(context, _team)
                                  ],
                                ),
                              ),
                              backLayer: Container(
                                color: Colors.green,
                                child: _buildSelectTeam(context, _teams,
                                    (team) => model.changeTeam(team)),
                              ),
                              frontTitle: Align(
                                child: Text(
                                  _team.name,
                                  style: textStyleTitle(),
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
