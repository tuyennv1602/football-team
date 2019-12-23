import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/model/member.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/model/user.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/app_bar.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/empty_widget.dart';
import 'package:myfootball/view/widget/image_widget.dart';
import 'package:myfootball/view/widget/input_text_widget.dart';
import 'package:myfootball/view/widget/item_comment.dart';
import 'package:myfootball/view/widget/item_position.dart';
import 'package:myfootball/view/widget/line.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/view/widget/multichoice_position.dart';
import 'package:myfootball/view/widget/review_dialog.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/member_detail_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class MemberDetailPage extends StatelessWidget {
  final Member member;
  final _formKey = GlobalKey<FormState>();

  MemberDetailPage({Key key, this.member}) : super(key: key);

  _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

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

  _showEditForm(BuildContext context, Member member, {Function onSubmit}) {
    String _number;
    List<String> _position;
    return UIHelper.showCustomizeDialog(
      'edit_member',
      icon: Images.EDIT_PROFILE,
      confirmLabel: 'CẬP NHẬT',
      onConfirmed: () {
        if (_validateAndSave()) {
          Navigation.instance.goBack();
          onSubmit(_position != null ? _position.join(',') : member.position,
              _number.isEmpty ? null : _number);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Form(
            key: _formKey,
            child: InputTextWidget(
              onSaved: (value) => _number = value,
              maxLines: 1,
              initValue: member.number,
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
            onChangePositions: (positions) => _position = positions,
          )
        ],
      ),
    );
  }

  _handleSubmitReview(int userId, double rating, String comment,
      MemberDetailViewModel model) async {
    UIHelper.showProgressDialog;
    var resp = await model.submitReview(userId, rating, comment);
    UIHelper.hideProgressDialog;
    if (!resp.isSuccess) {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  _handleUpdateInfo(int teamId, String position, String number,
      MemberDetailViewModel model) async {
    UIHelper.showProgressDialog;
    var resp = await model.updateInfo(teamId, position, number);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      UIHelper.showSimpleDialog('Đã cập nhật thông tin cá nhân',
          isSuccess: true);
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    var userId = Provider.of<User>(context).id;
    var teamId = Provider.of<Team>(context).id;
    return Scaffold(
      backgroundColor: PRIMARY,
      body: BaseWidget<MemberDetailViewModel>(
        model: MemberDetailViewModel(api: Provider.of(context)),
        onModelReady: (model) {
          model.initMember(member);
          model.getCommentsByUser(member.id, 1);
        },
        builder: (c, model, child) => Column(
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
                      onTap: () => _showEditForm(
                        context,
                        member,
                        onSubmit: (position, number) =>
                            _handleUpdateInfo(teamId, position, number, model),
                      ),
                    )
                  : AppBarButtonWidget(
                      imageName: Images.CALL,
                      onTap: () => launch('tel://${member.phone}'),
                    ),
            ),
            Expanded(
              child: BorderBackground(
                child: Padding(
                  padding: EdgeInsets.all(UIHelper.padding),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Hero(
                            tag: member.tag,
                            child: ImageWidget(
                              source: member.avatar,
                              placeHolder: Images.DEFAULT_AVATAR,
                              size: UIHelper.size(80),
                              radius: UIHelper.size(40),
                              boxFit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: UIHelper.padding,
                                  bottom: UIHelper.size10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    member.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: textStyleSemiBold(size: 18),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: UIHelper.size5, bottom: 2),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            'Số trận: ${member.teamGame}',
                                            style: textStyleMedium(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Kinh nghiệm: ${member.getExp}',
                                            style: textStyleMedium(),
                                          ),
                                        ),
                                      ],
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
                            _writeReview(
                              context,
                              onSubmit: (rating, comment) =>
                                  _handleSubmitReview(
                                      member.id, rating, comment, model),
                            );
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
            )
          ],
        ),
      ),
    );
  }
}
