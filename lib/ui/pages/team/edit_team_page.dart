import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/bottom_sheet_widget.dart';
import 'package:myfootball/ui/widgets/button_widget.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/input_widget.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/update_team_viewmodel.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

class EditTeamPage extends StatelessWidget {
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

  _handleUpdate(BuildContext context, UpdateTeamViewModel model, Team team) async {
    UIHelper.showProgressDialog;
    team.name = _teamName;
    team.bio = _bio;
    var resp = await model.updateTeam(team);
    UIHelper.hideProgressDialog;
    if(resp.isSuccess){
      Navigator.of(context);
    }else{
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    var _team = Provider.of<Team>(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
            centerContent: Text('Chỉnh sửa thông tin',
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
                    child: BaseWidget<UpdateTeamViewModel>(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: UIHelper.size15),
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
                                initValue: _team.name,
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
                                initValue: _team.bio,
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
                      model: UpdateTeamViewModel(
                        api: Provider.of(context),
                        teamServices: Provider.of(context),
                      ),
                      onModelReady: (model) =>
                          model.setDressColor(parseColor(_team.dress)),
                      builder: (context, model, child) => Column(
                        children: <Widget>[
                          Container(
                            height: UIHelper.size(100),
                            width: UIHelper.size(100),
                            margin:
                                EdgeInsets.symmetric(vertical: UIHelper.size10),
                            decoration: BoxDecoration(
                                border: Border.all(color: LINE_COLOR, width: 1),
                                borderRadius:
                                    BorderRadius.circular(UIHelper.size5)),
                            child: InkWell(
                              onTap: () => _showChooseImage(
                                  context, (image) => model.setImage(image)),
                              child: model.image == null
                                  ? ImageWidget(
                                      source: _team.logo,
                                      placeHolder: Images.DEFAULT_LOGO)
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
                                _handleUpdate(context, model, _team);
                              }
                            },
                            margin: EdgeInsets.all(UIHelper.size15),
                            child: Text(
                              'CẬP NHẬT',
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
