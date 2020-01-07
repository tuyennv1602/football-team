import 'package:flutter/material.dart';
import 'package:myfootball/model/user.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/app_bar_widget.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/empty_widget.dart';
import 'package:myfootball/view/widget/item_comment.dart';
import 'package:myfootball/view/widget/line.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/view/widget/review_dialog.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/user_comment_vm.dart';
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
              leftContent: AppBarButton(
                imageName: Images.BACK,
                onTap: () => Navigation.instance.goBack(),
              ),
              rightContent: userId != user.id
                  ? AppBarButton(
                      imageName: Images.EDIT_PROFILE,
                      onTap: () => _writeReview(
                        context,
                        onSubmit: (rating, comment) =>
                            model.submitReview(userId, rating, comment),
                      ),
                    )
                  : AppBarButton(),
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
