import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/routes/routes.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/search_widget.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/search_team_viewmodel.dart';
import 'package:provider/provider.dart';

class SearchTeamPage extends StatelessWidget {
  Widget _buildItemTeam(BuildContext context, Team team) => InkWell(
        onTap: () => Routes.routeToCompareTeam(context, team),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: UIHelper.size15, vertical: UIHelper.size10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ImageWidget(
                source: team.logo,
                placeHolder: Images.DEFAULT_LOGO,
              ),
              UIHelper.horizontalSpaceMedium,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      team.name,
                      style: textStyleSemiBold(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: UIHelper.size(2)),
                      child: Text(
                        'Xếp hạng: ${team.rank} (${team.point} điểm)',
                        style: textStyleRegularBody(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Đánh giá: ',
                          style: textStyleRegularBody(),
                        ),
                        team.rated
                            ? FlutterRatingBarIndicator(
                                rating: team.rating,
                                itemCount: 5,
                                itemPadding: EdgeInsets.only(left: 2),
                                itemSize: UIHelper.size(12),
                                emptyColor: Colors.amber.withAlpha(90),
                              )
                            : Text(
                                'Chưa có đánh giá',
                                style: textStyleRegularBody(),
                              ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Tìm kiếm đối tác',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<SearchTeamViewModel>(
                model: SearchTeamViewModel(api: Provider.of(context)),
                onModelReady: (model) => model.searchTeamByKey(''),
                builder: (context, model, child) => Column(
                  children: <Widget>[
                    SearchWidget(
                      keyword: model.key,
                      hintText: 'Nhập tên đội bóng',
                      isLoading: model.isLoading,
                      onChangedText: (text) => model.searchTeamByKey(text),
                    ),
                    model.teams == null
                        ? SizedBox()
                        : Expanded(
                            child: model.teams.length == 0
                                ? EmptyWidget(message: 'Không tìm thấy kết quả')
                                : ListView.separated(
                                    physics: BouncingScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemCount: model.teams.length,
                                    separatorBuilder: (c, index) =>
                                        LineWidget(),
                                    itemBuilder: (c, index) => _buildItemTeam(
                                        context, model.teams[index]),
                                  ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
