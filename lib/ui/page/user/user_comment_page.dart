import 'package:flutter/material.dart';
import 'package:myfootball/model/user.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/service/navigation_services.dart';
import 'package:myfootball/ui/page/base_widget.dart';
import 'package:myfootball/ui/widget/app_bar.dart';
import 'package:myfootball/ui/widget/app_bar_button.dart';
import 'package:myfootball/ui/widget/border_background.dart';
import 'package:myfootball/ui/widget/empty_widget.dart';
import 'package:myfootball/ui/widget/item_comment.dart';
import 'package:myfootball/ui/widget/line.dart';
import 'package:myfootball/ui/widget/loading.dart';
import 'package:myfootball/ui/widget/review_dialog.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/user_comment_viewmodel.dart';
import 'package:provider/provider.dart';

class UserCommentPage extends StatelessWidget {
  final int userId;

  UserCommentPage({Key key, @required this.userId}) : super(key: key);

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
    var user = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: BaseWidget<UserCommentViewModel>(
        model: UserCommentViewModel(api: Provider.of(context)),
        onModelReady: (model) => model.getComments(userId),
        builder: (c, model, child) => Column(
          children: <Widget>[
            AppBarWidget(
              centerContent: Text(
                'Đánh giá & nhận xét',
                textAlign: TextAlign.center,
                style: textStyleTitle(),
              ),
              leftContent: AppBarButtonWidget(
                imageName: Images.BACK,
                onTap: () => NavigationService.instance.goBack(),
              ),
              rightContent: userId != user.id
                  ? AppBarButtonWidget(
                      imageName: Images.EDIT_PROFILE,
                      onTap: () => _writeReview(
                        context,
                        onSubmit: (rating, comment) =>
                            model.submitReview(userId, rating, comment),
                      ),
                    )
                  : AppBarButtonWidget(),
            ),
            Expanded(
              child: BorderBackground(
                child: model.busy
                    ? LoadingWidget()
                    : model.comments.length == 0
                        ? EmptyWidget(message: 'Chưa có nhận xét & đánh giá')
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(
                                vertical: UIHelper.padding),
                            itemBuilder: (c, index) =>
                                ItemComment(comment: model.comments[index]),
                            separatorBuilder: (c, index) => LineWidget(),
                            itemCount: model.comments.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
