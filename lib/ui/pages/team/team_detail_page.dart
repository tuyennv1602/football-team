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
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/other_team_viewmodel.dart';
import 'package:provider/provider.dart';

class TeamDetailPage extends StatelessWidget {
  final Team team;

  TeamDetailPage({Key key, this.team}) : super(key: key);

  _writeReview(BuildContext context, {Function onSubmit}) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UIHelper.size5),
            ),
            contentPadding: EdgeInsets.zero,
            content: ReviewDialog(
                onSubmitReview: (rating, comment) => onSubmit(rating, comment)),
          ));

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      resizeToAvoidBottomPadding: false,
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
              onTap: () => NavigationService.instance().goBack(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<OtherTeamViewModel>(
                model:
                    OtherTeamViewModel(api: Provider.of(context), team: team),
                onModelReady: (model) {
                  model.getTeamDetail();
                  model.getComments();
                },
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
                                      'Điểm: ${_team.point ?? 0}',
                                      style: textStyleRegularTitle(),
                                    ),
                                    Text(
                                      'Xếp hạng: ${_team.rank ?? 0}',
                                      style: textStyleRegularTitle(),
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
                                    onTap: () => NavigationService.instance()
                                        .navigateTo(MEMBERS, arguments: _team),
                                  ),
                                  LineWidget(),
                                  InkWell(
                                    onTap: () => _writeReview(
                                      context,
                                      onSubmit: (rating, comment) =>
                                          model.submitReview(rating, comment),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: UIHelper.size20,
                                          vertical: UIHelper.size15),
                                      child: Row(
                                        children: <Widget>[
                                          Image.asset(
                                            Images.EDIT_PROFILE,
                                            width: UIHelper.size20,
                                            height: UIHelper.size20,
                                            color: Colors.amber,
                                          ),
                                          UIHelper.horizontalSpaceLarge,
                                          Expanded(
                                            child: Text(
                                              'Đánh giá & nhận xét',
                                              style: textStyleRegularTitle(),
                                            ),
                                          ),
                                          RatingBarIndicator(
                                            rating: _team.rating,
                                            itemCount: 5,
                                            itemPadding: EdgeInsets.only(
                                                right: UIHelper.size(2)),
                                            itemSize: UIHelper.size20,
                                            itemBuilder: (context, index) =>
                                                Icon(
                                              Icons.star,
                                              color: PRIMARY,
                                            ),
                                          )
                                        ],
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
                                                padding: EdgeInsets.only(
                                                    left: UIHelper.size50,
                                                    right: UIHelper.size10),
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
