import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:myfootball/models/user.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/stringres.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/bottom_sheet_widget.dart';
import 'package:myfootball/ui/widgets/button_widget.dart';
import 'package:myfootball/ui/widgets/input_widget.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/create_team_viewmodel.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CreateTeamPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String _teamName;
  String _bio;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _showChooseImage(BuildContext context, Function onImageReady) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: ['Chọn ảnh logo', 'Từ máy ảnh', 'Từ thư viện', 'Huỷ'],
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

  Widget _buildItemColor(BuildContext context, Color color) => Padding(
        padding: EdgeInsets.all(UIHelper.size5),
        child: Container(
          height: UIHelper.size40,
          width: UIHelper.size40,
          padding: EdgeInsets.all(UIHelper.size10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(UIHelper.size20),
            border: Border.all(width: 0.5, color: Colors.grey),
          ),
        ),
      );

  void _handleSubmit(CreateTeamViewModel model, User user) async {
    UIHelper.showProgressDialog;
    var resp = await model.createTeam(user, _teamName, _bio);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      UIHelper.showSimpleDialog('Đăng ký đội bóng thành công');
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
            centerContent: Text('Đăng ký đội bóng',
                textAlign: TextAlign.center, style: textStyleTitle()),
          ),
          Expanded(
            child: BorderBackground(
              child: ListView(
                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: BaseWidget<CreateTeamViewModel>(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: UIHelper.size10),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              InputWidget(
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'Vui lòng nhập tên đội bóng';
                                  return null;
                                },
                                inputType: TextInputType.text,
                                inputAction: TextInputAction.next,
                                labelText: 'Tên đội bóng',
                                onSaved: (value) => _teamName = value,
                              ),
                              InputWidget(
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'Vui lòng nhập giới thiệu';
                                  return null;
                                },
                                maxLines: 3,
                                inputType: TextInputType.text,
                                inputAction: TextInputAction.done,
                                labelText: 'Giới thiệu đội bóng',
                                onSaved: (value) => _bio = value,
                              ),
                              Text(
                                'Màu áo',
                                style: textStyleInput(color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                      ),
                      model: CreateTeamViewModel(
                        api: Provider.of(context),
                        authServices: Provider.of(context),
                        sharePreferences: Provider.of(context),
                      ),
                      builder: (context, model, child) => Column(
                        children: <Widget>[
                          Container(
                            height: UIHelper.size(100),
                            width: UIHelper.size(100),
                            margin:
                                EdgeInsets.symmetric(vertical: UIHelper.size10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: LINE_COLOR,
                                    width: model.image != null ? 0 : 1),
                                borderRadius:
                                    BorderRadius.circular(UIHelper.size5)),
                            child: InkWell(
                              onTap: () => _showChooseImage(
                                  context, (image) => model.setImage(image)),
                              child: model.image == null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(Images.DEFAULT_LOGO,
                                            width: UIHelper.size50,
                                            height: UIHelper.size50,
                                            color: Colors.grey),
                                        Text('Logo',
                                            style: textStyleSemiBold(
                                                color: Colors.grey))
                                      ],
                                    )
                                  : Image.file(model.image, fit: BoxFit.cover),
                            ),
                          ),
                          child,
                          Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Image.asset(
                                Images.SHIRT,
                                width: UIHelper.size(93),
                                height: UIHelper.size(93),
                                color: Colors.grey,
                              ),
                              Image.asset(
                                Images.SHIRT,
                                width: UIHelper.size(90),
                                height: UIHelper.size(90),
                                color: model.dressColor,
                              )
                            ],
                          ),
                          UIHelper.verticalSpaceMedium,
                          SizedBox(
                            height: UIHelper.size50,
                            width: UIHelper.screenWidth,
                            child: Swiper(
                              physics: BouncingScrollPhysics(),
                              viewportFraction:
                                  UIHelper.size50 / (UIHelper.screenWidth),
                              scale: 0.1,
                              onIndexChanged: (index) =>
                                  model.setDressColor(DRESS_COLORS[index]),
                              itemBuilder: (BuildContext context, int index) =>
                                  _buildItemColor(context, DRESS_COLORS[index]),
                              itemCount: DRESS_COLORS.length,
                            ),
                          ),
                          ButtonWidget(
                            onTap: () {
                              if (validateAndSave()) {
                                _handleSubmit(
                                    model, Provider.of<User>(context));
                              }
                            },
                            margin: EdgeInsets.symmetric(
                                horizontal: UIHelper.size10,
                                vertical: UIHelper.size15),
                            child: Text(
                              StringRes.REGISTER.toUpperCase(),
                              style: textStyleButton(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
