import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/models/member.dart';
import 'package:myfootball/models/member_arg.dart';
import 'package:myfootball/models/user.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/item_comment.dart';
import 'package:myfootball/ui/widgets/item_position.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/ui/widgets/review_dialog.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/member_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberDetailPage extends StatelessWidget {
  final MemberArgument memberArgument;
  final bool isShowFull;
  final Member member;

  MemberDetailPage({Key key, this.memberArgument})
      : this.member = memberArgument.member,
        this.isShowFull = memberArgument.showFull,
        super(key: key);

  _writeReview(BuildContext context, {Function onSubmit}) => showGeneralDialog(
        barrierLabel: 'review_member',
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.6),
        transitionDuration: Duration(milliseconds: 300),
        context: context,
        pageBuilder: (context, anim1, anim2) => ReviewDialog(
          onSubmitReview: (rating, comment) => onSubmit(rating, comment),
        ),
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
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Hồ sơ thành viên',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
            rightContent: isShowFull
                ? AppBarButtonWidget(
                    imageName: Images.CALL,
                    onTap: () => launch('tel://${member.phone}'),
                  )
                : SizedBox(),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<MemberViewModel>(
                model: MemberViewModel(api: Provider.of(context)),
                onModelReady: (model) {
                  model.initMember(member);
                  model.getCommentsByUser(member.id, 1);
                },
                builder: (c, model, child) => Padding(
                  padding: EdgeInsets.all(UIHelper.padding),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Hero(
                            tag: member.id,
                            child: ImageWidget(
                              source: member.avatar,
                              placeHolder: Images.DEFAULT_AVATAR,
                              size: UIHelper.size(80),
                              radius: UIHelper.size(40),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: UIHelper.padding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    member.name ?? member.userName,
                                    style: textStyleSemiBold(size: 18),
                                  ),
                                  Text(
                                    member.email,
                                    style: textStyleRegular(),
                                  ),
                                  UIHelper.verticalSpaceSmall,
                                  Row(
                                    children: member.getPositions
                                        .map<Widget>(
                                          (pos) => ItemPosition(
                                            position: pos,
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      UIHelper.verticalSpaceMedium,
                      InkWell(
                        onTap: () {
                          if (Provider.of<User>(context).id != member.id) {
                            _writeReview(context,
                                onSubmit: (rating, comment) =>
                                    model.submitReview(
                                        member.id, rating, comment));
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: UIHelper.padding),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  'Đánh giá & nhận xét',
                                  style: textStyleSemiBold(),
                                ),
                              ),
                              RatingBarIndicator(
                                rating: model.member.getRating,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.only(right: UIHelper.size(2)),
                                itemSize: UIHelper.size20,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          child: model.busy
                              ? LoadingWidget()
                              : model.comments.length == 0
                                  ? EmptyWidget(
                                      message: 'Chưa có đánh giá & nhận xét')
                                  : ListView.separated(
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (c, index) => ItemComment(
                                          comment: model.comments[index]),
                                      separatorBuilder: (c, index) =>
                                          LineWidget(),
                                      itemCount: model.comments.length))
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
