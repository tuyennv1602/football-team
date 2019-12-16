import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:myfootball/model/invite_team_arg.dart';
import 'package:myfootball/model/matching.dart';
import 'package:myfootball/model/matching_time_slot.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/service/navigation_services.dart';
import 'package:myfootball/ui/page/base_widget.dart';
import 'package:myfootball/ui/widget/app_bar_button.dart';
import 'package:myfootball/ui/widget/app_bar.dart';
import 'package:myfootball/ui/widget/border_background.dart';
import 'package:myfootball/ui/widget/button_widget.dart';
import 'package:myfootball/ui/widget/clipper_left_widget.dart';
import 'package:myfootball/ui/widget/clipper_right_widget.dart';
import 'package:myfootball/ui/widget/empty_widget.dart';
import 'package:myfootball/ui/widget/image_widget.dart';
import 'package:myfootball/ui/widget/line.dart';
import 'package:myfootball/ui/widget/loading.dart';
import 'package:myfootball/ui/widget/tabbar_widget.dart';
import 'package:myfootball/utils/date_util.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/find_matching_viewmodel.dart';
import 'package:provider/provider.dart';

class FindMatchingPage extends StatelessWidget {
  Widget _renderNoMatchingInfo(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: UIHelper.size20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '- Tiêu chí ghép đối sẽ giúp bạn tự động tìm kiếm những đối tác phù hợp nhất với đội bóng của bạn',
              style: textStyleRegular(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
              child: Text(
                '- Tiêu chí ghép đối sẽ giúp mọi người có thể tìm đến bạn phù hợp với những tiêu chí bạn đã đặt ra',
                style: textStyleRegular(),
              ),
            ),
            Text(
              '- Thay đổi tiêu chí ghép đối trong mục thiết lập ghép đối',
              style: textStyleRegular(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
              child: Text(
                '- Bạn có thể chọn nhiều thời gian và nhiều khu vực có thể chơi để ghép đói',
                style: textStyleRegular(),
              ),
            ),
            Text(
              '- Sử dụng chức năng tìm kiếm để tìm kiếm thủ công đối tác mà bạn muốn ghép',
              style: textStyleRegular(),
            ),
            ButtonWidget(
                child: Text(
                  'THIẾT LẬP GHÉP ĐỐI',
                  style: textStyleButton(),
                ),
                margin: EdgeInsets.only(top: UIHelper.size(60)),
                onTap: () =>
                    NavigationService.instance.navigateTo(SETUP_MATCHING))
          ],
        ),
      );

  Widget _buildItemCompare(String title, String left, String right) => Padding(
        padding: EdgeInsets.symmetric(vertical: UIHelper.size5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: Text(left,
                    textAlign: TextAlign.left, style: textStyleMediumTitle())),
            Text(title, style: textStyleRegular()),
            Expanded(
                child: Text(right,
                    textAlign: TextAlign.right, style: textStyleMediumTitle())),
          ],
        ),
      );

  Widget _buildItemTimeSlot(BuildContext context, MatchingTimeSlot timeSlot) =>
      InkWell(
        onTap: () => NavigationService.instance
            .navigateTo(GROUND_DETAIL, arguments: timeSlot.groundId),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: UIHelper.size5, right: UIHelper.size10),
                child: Column(
                  children: <Widget>[
                    Text(
                      timeSlot.getStartTime,
                      style: textStyleRegular(),
                    ),
                    Container(
                      height: 1,
                      width: UIHelper.size45,
                      padding: EdgeInsets.symmetric(horizontal: UIHelper.size5),
                      color: PRIMARY,
                    ),
                    Text(
                      timeSlot.getEndTime,
                      style: textStyleRegular(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      timeSlot.groundName,
                      maxLines: 1,
                      style: textStyleRegular(size: 15),
                    ),
                    Text(
                      'Giá sân: ${timeSlot.getPrice}',
                      maxLines: 1,
                      style: textStyleRegularBody(color: Colors.grey),
                    )
                  ],
                ),
              ),
              Image.asset(
                Images.NEXT,
                width: UIHelper.size10,
                height: UIHelper.size10,
                color: LINE_COLOR,
              )
            ],
          ),
        ),
      );

  Widget _buildSwiperItem(BuildContext context, Team team1, Matching team2) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(UIHelper.size10),
        border: Border.all(color: PRIMARY),
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: UIHelper.size10),
              child: DefaultTabController(
                length: team2.getMappedTimeSlot.length,
                child: NestedScrollView(
                  body: TabBarView(
                    children: team2.getMappedTimeSlot.values
                        .toList()
                        .map((timeSlots) => ListView.separated(
                            padding: EdgeInsets.zero,
                            itemBuilder: (c, index) =>
                                _buildItemTimeSlot(context, timeSlots[index]),
                            separatorBuilder: (c, index) =>
                                LineWidget(indent: 0),
                            itemCount: timeSlots.length))
                        .toList(),
                  ),
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                      child: SliverAppBar(
                        expandedHeight: UIHelper.size(180),
                        forceElevated: false,
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.white,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: UIHelper.size5),
                                child: _buildItemCompare(
                                    'Điểm',
                                    '${team1.point.toStringAsFixed(1)}',
                                    '${team2.point.toStringAsFixed(1)}'),
                              ),
                              _buildItemCompare(
                                  'Xếp hạng', '${team1.rank}', '${team2.rank}'),
                              _buildItemCompare(
                                  'Đối đầu',
                                  '${team2.confrontation1}',
                                  '${team2.confrontation2}'),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: UIHelper.size5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RatingBarIndicator(
                                      rating: team1.rating,
                                      itemCount: 5,
                                      itemPadding: EdgeInsets.only(right: 2),
                                      itemSize: UIHelper.size15,
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                    ),
                                    Text(
                                      'Đánh giá',
                                      style: textStyleRegular(),
                                    ),
                                    RatingBarIndicator(
                                      rating: team2.rating,
                                      itemCount: 5,
                                      itemPadding: EdgeInsets.only(left: 2),
                                      itemSize: UIHelper.size15,
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: UIHelper.size5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      height: UIHelper.size10,
                                      width: 100,
                                      child: ClipPath(
                                        clipper: ClipperLeftWidget(),
                                        child: Container(
                                          color: parseColor(team1.dress),
                                          child: SizedBox(),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Màu áo',
                                      style: textStyleRegular(),
                                    ),
                                    Container(
                                      height: UIHelper.size10,
                                      width: 100,
                                      child: ClipPath(
                                        clipper: ClipperRightWidget(),
                                        child: Container(
                                          color: parseColor(team2.dress),
                                          child: SizedBox(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Gợi ý sân thi đấu',
                                style: textStyleSemiBold(),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: UIHelper.size5),
                                child: TabBarWidget(
                                  titles: team2.getMappedTimeSlot.keys
                                      .toList()
                                      .map((item) => DateFormat('dd/MM')
                                          .format(DateUtil.getDateMatching(item)))
                                      .toList(),
                                  isScrollable: true,
                                  height: UIHelper.size35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Team team = Provider.of<Team>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: BaseWidget<FindMatchingViewModel>(
          model: FindMatchingViewModel(
              api: Provider.of(context), teamServices: Provider.of(context)),
          onModelReady: (model) {
            if (team.groupMatchingInfo.length > 0) {
              model.findMatching(team);
            }
          },
          child: AppBarWidget(
            centerContent: SizedBox(),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => NavigationService.instance.goBack(),
            ),
            backgroundColor: Colors.transparent,
          ),
          builder: (c, model, child) {
            return Stack(
              children: <Widget>[
                Container(
                  height: UIHelper.size(200) + UIHelper.paddingTop,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Images.GROUND), fit: BoxFit.fill),
                  ),
                  child: Column(
                    children: <Widget>[
                      child,
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  ImageWidget(
                                    source: team.logo,
                                    placeHolder: Images.DEFAULT_LOGO,
                                    size: UIHelper.size(70),
                                  ),
                                  Container(
                                    height: UIHelper.size(70),
                                    padding: EdgeInsets.all(UIHelper.size5),
                                    child: Text(
                                      team.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: textStyleSemiBold(
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  model.currentTeam != null
                                      ? InkWell(
                                          onTap: () => NavigationService
                                              .instance
                                              .navigateTo(TEAM_DETAIL,
                                                  arguments: Team(
                                                      id: model
                                                          .currentTeam.groupId,
                                                      name:
                                                          model.currentTeam
                                                              .groupName,
                                                      rank: model
                                                          .currentTeam.rank,
                                                      rating: model
                                                          .currentTeam.rating,
                                                      logo: model
                                                          .currentTeam.logo)),
                                          child: Hero(
                                            tag: model.currentTeam.groupId,
                                            child: ImageWidget(
                                              source: model.currentTeam.logo,
                                              placeHolder: Images.DEFAULT_LOGO,
                                              size: UIHelper.size(70),
                                            ),
                                          ),
                                        )
                                      : Image.asset(
                                          Images.DEFAULT_LOGO,
                                          height: UIHelper.size(70),
                                          width: UIHelper.size(70),
                                        ),
                                  Container(
                                    height: UIHelper.size(70),
                                    padding: EdgeInsets.all(UIHelper.size5),
                                    child: Text(
                                      model.currentTeam != null
                                          ? model.currentTeam.groupName
                                          : '?',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: textStyleSemiBold(
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: UIHelper.size(170) + UIHelper.paddingTop),
                  child: BorderBackground(
                    child: team.groupMatchingInfo.length == 0
                        ? _renderNoMatchingInfo(context)
                        : (model.busy
                            ? LoadingWidget()
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: UIHelper.size10),
                                child: model.matchings.length > 0
                                    ? Column(
                                        children: <Widget>[
                                          Expanded(
                                            child: Swiper(
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                var _matching =
                                                    model.matchings[index];
                                                return _buildSwiperItem(
                                                    context, team, _matching);
                                              },
                                              onIndexChanged: (index) =>
                                                  model.changeCurrentTeam(
                                                      model.matchings[index]),
                                              itemCount: model.matchings.length,
                                              itemWidth: UIHelper.screenWidth,
                                              scale: 0.9,
                                              viewportFraction: 0.87,
                                              loop: false,
                                            ),
                                          ),
                                          ButtonWidget(
                                            child: Text(
                                              'MỜI GHÉP ĐỐI',
                                              style: textStyleButton(),
                                            ),
                                            margin: EdgeInsets.symmetric(
                                              vertical: UIHelper.size10,
                                                horizontal: UIHelper.size25),
                                            onTap: () => NavigationService
                                                .instance
                                                .navigateTo(
                                              INVITE_TEAM,
                                              arguments: InviteTeamArgument(
                                                  fromTeamId: team.id,
                                                  toTeamId: int.parse(
                                                      model.currentTeam.id),
                                                  mappedTimeSlots: model
                                                      .currentTeam
                                                      .getMappedTimeSlot),
                                            ),
                                          )
                                        ],
                                      )
                                    : EmptyWidget(
                                        message: 'Không tìm thấy kết quả'),
                              )),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
