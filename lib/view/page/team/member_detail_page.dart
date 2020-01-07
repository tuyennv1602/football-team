import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/model/member.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/model/user.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/fonts.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/bottom_sheet.dart';
import 'package:myfootball/view/widget/customize_app_bar.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/empty_widget.dart';
import 'package:myfootball/view/widget/customize_image.dart';
import 'package:myfootball/view/widget/input_text.dart';
import 'package:myfootball/view/widget/item_comment.dart';
import 'package:myfootball/view/widget/item_position.dart';
import 'package:myfootball/view/widget/line.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/view/widget/multichoice_position.dart';
import 'package:myfootball/view/widget/review_dialog.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/member_detail_vm.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class MemberDetailPage extends StatelessWidget {
  final Member member;
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

  _showEditForm(BuildContext context, Member member, {Function onSubmit}) {
    String _number;
    List<String> _position;
    return UIHelper.showCustomizeDialog(
      'edit_member',
      icon: Images.EDIT_PROFILE,
      confirmLabel: 'CẬP NHẬT',
      onConfirmed: () {
        if (validateAndSave()) {
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
            child: InputText(
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

  _showManagerOptions(BuildContext context,
          {Function onCall, Function onAddCaptain, Function onRemove}) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: [
            'Tuỳ chọn',
            'Gọi điện',
            'Thêm quyền đội trưởng',
            'Xoá khỏi đội',
            'Huỷ'
          ],
          onClickOption: (index) {
            if (index == 1) {
              onCall();
            }
            if (index == 2) {
              onAddCaptain();
            }
            if (index == 3) {
              onRemove();
            }
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    var userId = Provider.of<User>(context).id;
    var team = Provider.of<Team>(context);
    var isManager = userId == team.managerId;
    return Scaffold(
      backgroundColor: PRIMARY,
      body: BaseWidget<MemberDetailViewModel>(
        model: MemberDetailViewModel(
            api: Provider.of(context),
            team: team,
            teamServices: Provider.of(context)),
        onModelReady: (model) {
          model.initMember(member);
          model.getCommentsByUser(member.id, 1);
        },
        builder: (c, model, child) => Column(
          children: <Widget>[
            CustomizeAppBar(
              centerContent: Text(
                'Thông tin thành viên',
                textAlign: TextAlign.center,
                style: textStyleTitle(),
              ),
              leftContent: AppBarButton(
                imageName: Images.BACK,
                onTap: () => Navigator.of(context).pop(),
              ),
              rightContent: userId == member.id
                  ? AppBarButton(
                      imageName: Images.EDIT_PROFILE,
                      onTap: () => _showEditForm(
                        context,
                        member,
                        onSubmit: (position, number) =>
                            model.updateInfo(position, number),
                      ),
                    )
                  : isManager
                      ? AppBarButton(
                          imageName: Images.MORE,
                          onTap: () => _showManagerOptions(
                            context,
                            onCall: () => launch('tel://${member.phone}'),
                            onAddCaptain: () => UIHelper.showConfirmDialog(
                              'Bạn có chắc chắn muốn thêm quyền đội trưởng cho ${member.name}?',
                              onConfirmed: () => model.addCaptain(member.id),
                            ),
                            onRemove: () => UIHelper.showConfirmDialog(
                              'Bạn có chắc chắn muốn xoá ${member.name} khỏi đội bóng?',
                              onConfirmed: () => model.kickMember(member.id),
                            ),
                          ),
                        )
                      : AppBarButton(
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
                            child: CustomizeImage(
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
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        member.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: textStyleSemiBold(size: 20),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 3),
                                    child: Row(
                                      children: member.getPositions
                                          .map<Widget>(
                                            (pos) => ItemPosition(
                                              position: pos,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: 'Exp: ',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: UIHelper.size(17),
                                                ),
                                              ),
                                              TextSpan(
                                                text: member.getExp,
                                                style: TextStyle(
                                                    fontFamily: MEDIUM,
                                                    color: Colors.black,
                                                    fontSize:
                                                        UIHelper.size(18)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: 'Trận: ',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: UIHelper.size(17),
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    member.teamGame.toString(),
                                                style: TextStyle(
                                                    fontFamily: MEDIUM,
                                                    color: Colors.black,
                                                    fontSize:
                                                        UIHelper.size(18)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
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
                              EdgeInsets.symmetric(vertical: UIHelper.size15),
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
                                    itemCount: model.comments.length),
                      )
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
