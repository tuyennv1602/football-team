import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/model/user.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/service/navigation_services.dart';
import 'package:myfootball/ui/page/base_widget.dart';
import 'package:myfootball/ui/page/team/search_team_page.dart';
import 'package:myfootball/ui/widget/app_bar.dart';
import 'package:myfootball/ui/widget/app_bar_button.dart';
import 'package:myfootball/ui/widget/backdrop.dart';
import 'package:myfootball/ui/widget/border_background.dart';
import 'package:myfootball/ui/widget/line.dart';
import 'package:myfootball/ui/widget/item_option.dart';
import 'package:myfootball/ui/widget/image_widget.dart';
import 'package:myfootball/ui/widget/loading.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/team_viewmodel.dart';
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
              child: InkWell(
                onTap: () => NavigationService.instance.navigateTo(CREATE_TEAM),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      Images.ADD_TEAM,
                      color: PRIMARY,
                      width: UIHelper.size50,
                      height: UIHelper.size50,
                    ),
                    UIHelper.verticalSpaceMedium,
                    Text(
                      'Thành lập đội bóng',
                      style: textStyleTitle(color: BLACK_TEXT),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => NavigationService.instance.navigateTo(SEARCH_TEAM,
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
                    UIHelper.verticalSpaceMedium,
                    Text(
                      'Tham gia đội bóng',
                      style: textStyleTitle(color: BLACK_TEXT),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );

  Widget _buildTeamOptions(BuildContext context, Team team) {
    List<Widget> _children = [];
    List<Widget> _manager = [];
    bool isManager = team.isManager(Provider.of<User>(context).id);
    if (isManager) {
      _manager.addAll([
        ItemOptionWidget(
          Images.FIND_MATCH,
          'Tìm đối tác',
          iconColor: Colors.red,
          onTap: () => NavigationService.instance.navigateTo(FIND_MATCHING),
        ),
        ItemOptionWidget(
          Images.INVITE,
          'Lời mời ghép đối',
          iconColor: Colors.pinkAccent,
          onTap: () => NavigationService.instance.navigateTo(INVITE_REQUESTS),
        ),
        ItemOptionWidget(
          Images.BOOKING,
          'Đặt sân bóng',
          iconColor: Colors.green,
          onTap: () => NavigationService.instance.navigateTo(SEARCH_GROUND),
        ),
        ItemOptionWidget(
          Images.MEMBER_MANAGE,
          'Yêu cầu gia nhập đội bóng',
          iconColor: Colors.green,
          onTap: () => NavigationService.instance.navigateTo(REQUEST_MEMBER),
        ),
      ]);
    }
    return Column(
      children: _children
        ..addAll(
          [
            ItemOptionWidget(Images.MEMBER, 'Thành viên',
                iconColor: Colors.green,
                onTap: () => NavigationService.instance
                    .navigateTo(MEMBERS, arguments: team)),
            ItemOptionWidget(
              Images.SCHEDULE,
              'Lịch thi đấu',
              iconColor: Colors.deepOrange,
              onTap: () =>
                  NavigationService.instance.navigateTo(MATCH_SCHEDULE),
            ),
            ItemOptionWidget(
              Images.MATCH_HISTORY,
              'Lịch sử thi đấu',
              iconColor: Colors.blue,
              onTap: () => NavigationService.instance.navigateTo(MATCH_HISTORY),
            ),
            ItemOptionWidget(
              Images.COMMENT,
              'Thảo luận',
              iconColor: Colors.cyan,
            ),
          ]
            ..addAll(_manager)
            ..addAll([
              ItemOptionWidget(
                Images.TRANSACTION_HISTORY,
                'Quỹ đội bóng',
                iconColor: Colors.amber,
                onTap: () => NavigationService.instance.navigateTo(FINANCE),
              ),
              ItemOptionWidget(
                Images.CONNECT,
                'Mời bạn bè vào đội',
                iconColor: Colors.blueAccent,
              ),
            ])
            ..add(isManager
                ? ItemOptionWidget(
                    Images.SETTING,
                    'Thiết lập đội bóng',
                    iconColor: Colors.orange,
                    onTap: () =>
                        NavigationService.instance.navigateTo(SETUP_TEAM),
                  )
                : SizedBox())
            ..add(
              ItemOptionWidget(
                Images.LEAVE_TEAM,
                'Rời đội bóng',
                iconColor: Colors.blueGrey,
              ),
            ),
        ),
    );
  }

  Widget _buildHeaderWidget(BuildContext context, Team team) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: UIHelper.size15),
      child: Row(
        children: <Widget>[
          ImageWidget(
              source: team.logo,
              placeHolder: Images.DEFAULT_LOGO,
              size: UIHelper.size(90)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: UIHelper.size15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Điểm: ${team.point.toStringAsFixed(1)}',
                    style: textStyleAlert(color: Colors.black87),
                  ),
                  Text(
                    'Xếp hạng: ${team.rank}',
                    style: textStyleAlert(color: Colors.black87),
                  ),
                  InkWell(
                    onTap: () =>
                        NavigationService.instance.navigateTo(TEAM_COMMENT),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Đánh giá: ',
                          style: textStyleAlert(color: Colors.black87),
                        ),
                        RatingBarIndicator(
                          rating: team.rating,
                          itemCount: 5,
                          itemPadding: EdgeInsets.only(left: 2),
                          itemSize: UIHelper.size20,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: UIHelper.size15,
                    color: LINE_COLOR,
                  ),
                  Align(
                    child: Text(
                      '\" ${team.bio} \"',
                      textAlign: TextAlign.center,
                      style: textStyleItalic(size: 14, color: Colors.grey),
                    ),
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
                    ImageWidget(
                      source: _team.logo,
                      placeHolder: Images.DEFAULT_LOGO,
                      size: UIHelper.size35,
                    ),
                    UIHelper.horizontalSpaceMedium,
                    Expanded(
                      child: Text(
                        _team.name,
                        style: textStyleMediumTitle(),
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
                                      EdgeInsets.only(top: UIHelper.size15),
                                  physics: BouncingScrollPhysics(),
                                  children: <Widget>[
                                    _buildHeaderWidget(context, _team),
                                    UIHelper.verticalSpaceSmall,
                                    _buildTeamOptions(context, _team),
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
                              frontTrailing: AppBarButtonWidget(
                                imageName: Images.SEARCH,
                                iconColor: Colors.white,
                                onTap: () => NavigationService.instance
                                    .navigateTo(SEARCH_TEAM,
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
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 3,
                                      offset: Offset(0, -1),
                                    )
                                  ],
                                ),
                                child: Container(
                                  height: UIHelper.size(8),
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
