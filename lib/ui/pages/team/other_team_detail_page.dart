import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
import 'package:myfootball/ui/widgets/item_option.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/other_team_viewmodel.dart';
import 'package:provider/provider.dart';

class OtherTeamDetailPage extends StatelessWidget {
  final Team team;

  OtherTeamDetailPage({Key key, this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              team.name,
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
              child: BaseWidget<OtherTeamViewModel>(
                model: OtherTeamViewModel(api: Provider.of(context)),
                onModelReady: (model) => model.getTeamDetail(team.id),
                child: ImageWidget(
                  source: team.logo,
                  placeHolder: Images.DEFAULT_LOGO,
                  size: UIHelper.size(90),
                ),
                builder: (c, model, child) {
                  var _team = model.team;
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(UIHelper.size15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            child,
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: UIHelper.size15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Điểm: ${_team != null ? _team.point : 0}',
                                      style: textStyleRegular(),
                                    ),
                                    Text(
                                      'Xếp hạng: ${_team != null ? _team.rank : 0}',
                                      style: textStyleRegular(),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'Đánh giá: ',
                                          style: textStyleRegular(),
                                        ),
                                        FlutterRatingBarIndicator(
                                          rating:
                                              _team != null ? _team.rating : 0,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.only(
                                              left: UIHelper.size(3)),
                                          itemSize: UIHelper.size(18),
                                          emptyColor:
                                              Colors.amber.withAlpha(90),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      height: UIHelper.size15,
                                      color: LINE_COLOR,
                                    ),
                                    Align(
                                      child: Text(
                                        _team != null
                                            ? '\" ${_team.bio} \"'
                                            : '',
                                        textAlign: TextAlign.center,
                                        style: textStyleItalic(
                                            size: 14, color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: model.busy
                            ? LoadingWidget()
                            : Column(
                                children: <Widget>[
                                  ItemOptionWidget(
                                    Images.MEMBER,
                                    'Thành viên',
                                    iconColor: Colors.green,
                                    onTap: () => Routes.routeToMember(
                                        context, _team.members, _team.manager),
                                  ),
                                  LineWidget(),
                                  ItemOptionWidget(
                                    Images.STAR,
                                    'Đánh giá',
                                    iconColor: Colors.amber,
                                    rightContent: Image.asset(
                                      Images.EDIT_PROFILE,
                                      width: UIHelper.size20,
                                      height: UIHelper.size20,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Expanded(
                                      child: EmptyWidget(
                                          message: 'Chưa có đánh giá'))
                                ],
                              ),
                      )
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
