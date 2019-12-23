import 'dart:io';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfootball/model/user.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/page/team/search_team_page.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/bottom_sheet.dart';
import 'package:myfootball/view/widget/image_widget.dart';
import 'package:myfootball/view/widget/input_text_widget.dart';
import 'package:myfootball/view/widget/item_option.dart';
import 'package:myfootball/view/router/router_paths.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserState();
  }
}

class UserState extends State<UserPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final _formName = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _validateAndSave() {
    final form = _formName.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _showChooseImage(BuildContext context, Function onImageReady) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: ['Chọn ảnh đại diện', 'Từ máy ảnh', 'Từ thư viện', 'Huỷ'],
          paddingBottom: 0,
          onClickOption: (index) async {
            if (index == 1) {
              var image = await ImagePicker.pickImage(
                  source: ImageSource.camera, maxHeight: 500, maxWidth: 500);
              onImageReady(image);
            } else if (index == 2) {
              var image = await ImagePicker.pickImage(
                  source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
              onImageReady(image);
            }
          },
        ),
      );

  _showInputName(String name, {Function onSubmit}) {
    var _name;
    UIHelper.showCustomizeDialog(
      'input_invite',
      icon: Images.PEN,
      child: Form(
        key: _formName,
        child: InputTextWidget(
          validator: (value) {
            if (value.isEmpty) return 'Vui lòng nhập tên của bạn';
            return null;
          },
          onSaved: (value) => _name = value,
          maxLines: 1,
          initValue: name,
          inputType: TextInputType.text,
          inputAction: TextInputAction.done,
          labelText: 'Tên hiển thị',
          focusedColor: Colors.white,
          textStyle: textStyleInput(size: 18, color: Colors.white),
          hintTextStyle: textStyleInput(size: 18, color: Colors.white),
        ),
      ),
      onConfirmed: () {
        if (_validateAndSave()) {
          Navigation.instance.goBack();
          onSubmit(_name);
        }
      },
    );
  }

  _handleUpdateAvatar(User user, File image, UserViewModel model) async {
    UIHelper.showProgressDialog;
    var resp = await model.updateAvatar(user, image);
    UIHelper.hideProgressDialog;
    if (!resp.isSuccess) {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  _handleUpdateName(User user, String name, UserViewModel model) async {
    UIHelper.showProgressDialog;
    var resp = await model.updateName(user, name);
    UIHelper.hideProgressDialog;
    if (!resp.isSuccess) {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  _handleLogout(UserViewModel model) => UIHelper.showConfirmDialog(
        'Bạn có chắc chắn muốn đăng xuất?',
        onConfirmed: () async {
          UIHelper.showProgressDialog;
          var resp = await model.logout();
          UIHelper.hideProgressDialog;
          if (resp) {
            Navigation.instance.navigateAndRemove(LOGIN);
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: PRIMARY,
      body: BaseWidget<UserViewModel>(
          model: UserViewModel(
              sharePreferences: Provider.of(context),
              teamServices: Provider.of(context),
              api: Provider.of(context),
              authServices: Provider.of(context)),
          child: Column(
            children: <Widget>[
              ItemOptionWidget(
                Images.MEMBER_MANAGE,
                'Yêu cầu tham gia trận đấu',
                iconColor: Colors.teal,
                onTap: () => Navigation.instance.navigateTo(USER_JOIN_MATCH),
              ),
              ItemOptionWidget(
                Images.ADD_REQUEST,
                'Tham gia đội bóng',
                iconColor: Colors.cyan,
                onTap: () => Navigation.instance.navigateTo(SEARCH_TEAM,
                    arguments: SEARCH_TYPE.REQUEST_MEMBER),
              ),
              ItemOptionWidget(
                Images.ADD_TEAM,
                'Thành lập đội bóng',
                iconColor: Colors.orange,
                onTap: () => Navigation.instance.navigateTo(CREATE_TEAM),
              ),
              ItemOptionWidget(
                Images.SHARE,
                'Chia sẻ ứng dụng',
                iconColor: Colors.blue,
              ),
              ItemOptionWidget(
                Images.INFO,
                'Thông tin ứng dụng',
                iconColor: Colors.purple,
              ),
              ItemOptionWidget(
                Images.PASSWORD,
                'Đổi mật khẩu',
                iconColor: Colors.red,
              ),
            ],
          ),
          builder: (c, model, child) {
            var _user = Provider.of<User>(context);
            return Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: UIHelper.size(200) + UIHelper.paddingTop,
                  padding: EdgeInsets.symmetric(horizontal: UIHelper.size15),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/user_cover.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: UIHelper.size10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  ImageWidget(
                                    source: _user.avatar,
                                    placeHolder: Images.DEFAULT_AVATAR,
                                    size: UIHelper.size(100),
                                    radius: UIHelper.size(50),
                                    boxFit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () => _showChooseImage(
                                        context,
                                        (image) => _handleUpdateAvatar(
                                            _user, image, model),
                                      ),
                                      child: Container(
                                        width: UIHelper.size35,
                                        height: UIHelper.size35,
                                        padding:
                                            EdgeInsets.all(UIHelper.size(7)),
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(
                                              UIHelper.size35 / 2),
                                          border: Border.all(
                                              color: Colors.white, width: 1.5),
                                        ),
                                        child: Image.asset(Images.CAMERA,
                                            color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: UIHelper.size20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () => _showInputName(
                                          _user.name,
                                          onSubmit: (name) => _handleUpdateName(
                                              _user, name, model),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: UIHelper.size5),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  _user.name,
                                                  maxLines: 2,
                                                  style: textStyleSemiBold(
                                                      size: 20,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Image.asset(
                                                Images.PEN,
                                                width: UIHelper.size15,
                                                height: UIHelper.size15,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Số trận: ${_user.totalGame}',
                                        style: textStyleRegular(
                                            color: Colors.white),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'Kinh nghiệm: ${_user.getExp}',
                                        style: textStyleRegular(
                                            color: Colors.white),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      InkWell(
                                        onTap: () => Navigation.instance
                                            .navigateTo(USER_COMMENT,
                                                arguments: _user.id),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: UIHelper.size5),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  'Đánh giá',
                                                  style: textStyleRegular(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              RatingBarIndicator(
                                                rating: _user.rating,
                                                itemCount: 5,
                                                itemPadding:
                                                    EdgeInsets.only(right: 2),
                                                itemSize: UIHelper.size20,
                                                itemBuilder: (context, index) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: UIHelper.size(180) + UIHelper.paddingTop),
                  child: BorderBackground(
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(top: UIHelper.size5),
                      children: <Widget>[
                        child,
                        ItemOptionWidget(
                          Images.LOGOUT,
                          'Đăng xuất',
                          iconColor: Colors.grey,
                          onTap: () => _handleLogout(model),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
