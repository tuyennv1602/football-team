import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/item_comment.dart';
import 'package:myfootball/ui/widgets/item_option.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/ui/widgets/review_dialog.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/other_team_viewmodel.dart';
import 'package:provider/provider.dart';

class TeamDetailPage extends StatelessWidget {
  final Team team;

  TeamDetailPage({Key key, this.team}) : super(key: key);

  _writeReview(BuildContext context, {Function onSubmit}) => showGeneralDialog(
        barrierLabel: 'review_team',
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.6),
        transitionDuration: Duration(milliseconds: 300),
        context: context,
        pageBuilder: (context, anim1, anim2) => ReviewDialog(
            onSubmitReview: (rating, comment) => onSubmit(rating, comment)),
        transitionBuilder: (context, anim1, anim2, child) => SlideTransition(
          position:
              Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
          child: child,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY,
      resizeToAvoidBottomPadding: false,
      body: BaseWidget<OtherTeamViewModel>(
        model: OtherTeamViewModel(api: Provider.of(context), team: team),
        child: Hero(
          tag: team.id,
          child: ImageWidget(
            source: team.logo,
            placeHolder: Images.DEFAULT_LOGO,
            size: UIHelper.size(90),
          ),
        ),
        onModelReady: (model) {
          model.getTeamDetail();
          model.getComments();
        },
        builder: (c, model, child) {
          var _team = model.team;
          return Column(
            children: <Widget>[
              AppBarWidget(
                centerContent: Text(
                  team.name,
                  textAlign: TextAlign.center,
                  style: textStyleTitle(),
                ),
                leftContent: AppBarButtonWidget(
                  imageName: Images.BACK,
                  onTap: () => NavigationService.instance.goBack(),
                ),
                rightContent: AppBarButtonWidget(
                  imageName: Images.EDIT_TEAM,
                  onTap: () => _writeReview(
                    context,
                    onSubmit: (rating, comment) =>
                        model.submitReview(rating, comment),
                  ),
                ),
              ),
              Expanded(
                child: BorderBackground(
                  child: Column(
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
                                      'Điểm: ${_team.point.toStringAsFixed(1) ?? 0}',
                                      style:
                                          textStyleAlert(color: Colors.black87),
                                    ),
                                    Text(
                                      'Xếp hạng: ${_team.rank ?? 0}',
                                      style:
                                          textStyleAlert(color: Colors.black87),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'Đánh giá: ',
                                          style: textStyleAlert(
                                              color: Colors.black87),
                                        ),
                                        RatingBarIndicator(
                                          rating: _team.rating,
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
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.all(UIHelper.padding),
                                      child: Text(
                                        'Đánh giá và nhận xét',
                                        style: textStyleSemiBold(),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: model.comments == null
                                        ? LoadingWidget(type: LOADING_TYPE.WAVE)
                                        : model.comments.length == 0
                                            ? EmptyWidget(
                                                message: 'Chưa có nhận xét nào')
                                            : ListView.separated(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: UIHelper.padding),
                                                itemBuilder: (c, index) =>
                                                    ItemComment(
                                                        comment: model
                                                            .comments[index]),
                                                separatorBuilder: (c, index) =>
                                                    LineWidget(),
                                                itemCount:
                                                    model.comments.length),
                                  ),
                                ],
                              ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
