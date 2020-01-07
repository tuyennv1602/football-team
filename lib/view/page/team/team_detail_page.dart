import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/app_bar_widget.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/empty_widget.dart';
import 'package:myfootball/view/widget/image_widget.dart';
import 'package:myfootball/view/widget/item_comment.dart';
import 'package:myfootball/view/widget/line.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/view/widget/review_dialog.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/view/widget/team_header.dart';
import 'package:myfootball/viewmodel/other_team_vm.dart';
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
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              team.name,
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButton(
              imageName: Images.BACK,
              onTap: () => Navigation.instance.goBack(),
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
                builder: (c, model, child) {
                  var _team = model.team;
                  return Column(
                    children: <Widget>[
                      TeamHeader(team: _team, anim: true),
                      InkWell(
                        onTap: () => _writeReview(
                          context,
                          onSubmit: (rating, comment) =>
                              model.submitReview(rating, comment),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(UIHelper.padding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Đánh giá và nhận xét',
                                style: textStyleSemiBold(),
                              ),
                              Image.asset(
                                Images.EDIT_PROFILE,
                                width: UIHelper.size20,
                                height: UIHelper.size20,
                                color: Colors.green,
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: model.busy
                            ? LoadingWidget()
                            : model.comments == null
                                ? LoadingWidget(type: LOADING_TYPE.WAVE)
                                : model.comments.length == 0
                                    ? EmptyWidget(
                                        message: 'Chưa có nhận xét nào')
                                    : ListView.separated(
                                        padding: EdgeInsets.symmetric(
                                            vertical: UIHelper.padding),
                                        itemBuilder: (c, index) => ItemComment(
                                            comment: model.comments[index]),
                                        separatorBuilder: (c, index) =>
                                            LineWidget(),
                                        itemCount: model.comments.length),
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
