import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/model/member.dart';
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
import 'package:myfootball/ui/widget/image_widget.dart';
import 'package:myfootball/ui/widget/input_text_widget.dart';
import 'package:myfootball/ui/widget/item_comment.dart';
import 'package:myfootball/ui/widget/item_position.dart';
import 'package:myfootball/ui/widget/line.dart';
import 'package:myfootball/ui/widget/loading.dart';
import 'package:myfootball/ui/widget/multichoice_position.dart';
import 'package:myfootball/ui/widget/review_dialog.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/member_detail_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class MemberDetailPage extends StatelessWidget {
  final Member member;
  String _number;
  List<String> _positions;
  final _formKey = GlobalKey<FormState>();

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  MemberDetailPage({Key key, this.member}) : super(key: key);

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

  _showEditForm(BuildContext context, Member member, {Function onSubmit}) =>
      UIHelper.showCustomizeDialog(
        'edit_member',
        icon: Images.EDIT_PROFILE,
        confirmLabel: 'CẬP NHẬT',
        onConfirmed: () {
          if (validateAndSave()) {
            NavigationService.instance.goBack();
            onSubmit();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              key: _formKey,
              child: InputTextWidget(
                validator: (value) {
                  if (value.isEmpty) return 'Vui lòng nhập số áo';
                  return null;
                },
                initValue: '0',
                onSaved: (value) => _number = value,
                maxLines: 1,
                focusedColor: Colors.white,
                inputType: TextInputType.number,
                inputAction: TextInputAction.done,
                labelText: 'Số áo',
                textStyle: textStyleMediumTitle(size: 20, color: Colors.white),
                hintTextStyle:
                    textStyleMediumTitle(size: 20, color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: UIHelper.size5),
              child: Text(
                'Vị trí có thể chơi',
                style: textStyleRegularBody(color: Colors.white),
              ),
            ),
            MultiChoicePosition(
              initPositions: member.getPositions,
              onChangePositions: (positions) => _positions = positions,
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    var userId = Provider.of<User>(context).id;
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Thông tin cá nhân',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
            rightContent: userId == member.id
                ? AppBarButtonWidget(
                    imageName: Images.EDIT_PROFILE,
                    onTap: () =>
                        _showEditForm(context, member, onSubmit: () {}),
                  )
                : AppBarButtonWidget(
                    imageName: Images.CALL,
                    onTap: () => launch('tel://${member.phone}'),
                  ),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<MemberDetailViewModel>(
                model: MemberDetailViewModel(api: Provider.of(context)),
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
                            tag: 'member - ${member.userId ?? member.id}',
                            child: ImageWidget(
                              source: member.avatar,
                              placeHolder: Images.DEFAULT_AVATAR,
                              size: UIHelper.size(80),
                              radius: UIHelper.size(40),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: UIHelper.padding, bottom: UIHelper.size10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    member.name ?? member.userName,
                                    style: textStyleSemiBold(size: 18),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: UIHelper.size5),
                                    child: Text(
                                      member.email,
                                      style: textStyleRegular(),
                                    ),
                                  ),
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
                      InkWell(
                        onTap: () {
                          if (Provider.of<User>(context).id != member.id) {
                            _writeReview(context,
                                onSubmit: (rating, comment) => model
                                    .submitReview(member.id, rating, comment));
                          }
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: UIHelper.padding),
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
