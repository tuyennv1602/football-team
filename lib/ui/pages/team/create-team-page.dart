import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:myfootball/blocs/create-team-bloc.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/stringres.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/widgets/app-bar-button.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfootball/ui/widgets/border-background.dart';
import 'package:myfootball/ui/widgets/bottom-sheet-widget.dart';
import 'package:myfootball/ui/widgets/button-widget.dart';
import 'package:myfootball/utils/ui-helper.dart';
import 'package:myfootball/utils/validator.dart';

// ignore: must_be_immutable
class CreateTeamPage extends BasePage<CreateTeamBloc> with Validator {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget buildAppBar(BuildContext context) => AppBarWidget(
        leftContent: AppBarButtonWidget(
          imageName: Images.BACK,
          onTap: () => Navigator.of(context).pop(),
        ),
        centerContent: Text(
          'Đăng ký đội bóng',
          textAlign: TextAlign.center,
          style: textStyleTitle(),
        ),
      );

  _showChooseImage(BuildContext context) => showModalBottomSheet(
      context: context,
      builder: (c) => BottomSheetWidget(
            options: ['Chọn ảnh logo', 'Từ máy ảnh', 'Từ thư viện', 'Huỷ'],
            onClickOption: (index) async {
              if (index == 1) {
                var image = await ImagePicker.pickImage(
                    source: ImageSource.camera, maxHeight: 500, maxWidth: 500);
                pageBloc.chooseLogoFunc(image);
                Navigator.of(context).pop();
              } else if (index == 2) {
                var image = await ImagePicker.pickImage(
                    source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
                pageBloc.chooseLogoFunc(image);
                Navigator.of(context).pop();
              }
            },
          ));

  Widget _buildItemColor(BuildContext context, Color color) => Padding(
        padding: EdgeInsets.all(size5),
        child: Container(
          height: size40,
          width: size40,
          padding: EdgeInsets.all(size10),
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(size20),
              border: Border.all(width: 0.5, color: Colors.grey)),
        ),
      );

  @override
  Widget buildMainContainer(BuildContext context) {
    return BorderBackground(
      child: ListView(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              height: UIHelper.size(120),
              width: UIHelper.size(120),
              margin: EdgeInsets.symmetric(vertical: size20),
              decoration: BoxDecoration(
                  border: Border.all(color: LINE_COLOR, width: 1)),
              child: InkWell(
                onTap: () => _showChooseImage(context),
                child: StreamBuilder<File>(
                  stream: pageBloc.chooseLogoStream,
                  builder: (c, snap) {
                    if (snap.hasData) {
                      return Image.file(
                        snap.data,
                        fit: BoxFit.cover,
                      );
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          Images.DEFAULT_LOGO,
                          width: size50,
                          height: size50,
                          color: Colors.grey,
                        ),
                        Text(
                          'Logo',
                          style: textStyleSemiBold(color: Colors.grey),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size10),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
//                  InputWidget(
//                      validator: (value) {
//                        if (value.isEmpty) return 'Vui lòng nhập tên đội bóng';
//                        return null;
//                      },
//                      inputType: TextInputType.text,
//                      inputAction: TextInputAction.next,
//                      labelText: 'Tên đội bóng',
//                      onChangedText: (text) => pageBloc.changeNameFunc(text)),
//                  InputWidget(
//                      validator: (value) {
//                        if (value.isEmpty) return 'Vui lòng nhập giới thiệu';
//                        return null;
//                      },
//                      maxLines: 3,
//                      maxLength: 150,
//                      inputType: TextInputType.text,
//                      inputAction: TextInputAction.done,
//                      labelText: 'Giới thiệu đội bóng',
//                      onChangedText: (text) => pageBloc.changeBioFunc(text)),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(size10),
            child: Text(
              'Màu áo',
              style: textStyleInput(color: Colors.grey),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Color>(
              stream: pageBloc.chooseDressStream,
              builder: (c, snap) => Image.asset(
                Images.SHIRT,
                width: UIHelper.size(90),
                height: UIHelper.size(100),
                color: snap.hasData ? snap.data : Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: size10,
          ),
          SizedBox(
            height: size50,
            width: UIHelper.screenWidth,
            child: Swiper(
              physics: BouncingScrollPhysics(),
              viewportFraction: size50 / (UIHelper.screenWidth),
              scale: 0.1,
              onIndexChanged: (index) =>
                  pageBloc.chooseDressFunc(DRESS_COLORS[index]),
              itemBuilder: (BuildContext context, int index) =>
                  _buildItemColor(context, DRESS_COLORS[index]),
              itemCount: DRESS_COLORS.length,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ButtonWidget(
              onTap: () {
                if (_formKey.currentState.validate()) {
                  pageBloc.submitRegisterFunc(true);
                }
              },
              borderRadius: BorderRadius.circular(size5),
              margin: EdgeInsets.all(size20),
              backgroundColor: PRIMARY,
              child: Text(
                StringRes.REGISTER.toUpperCase(),
                style: textStyleButton(),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void listenData(BuildContext context) {
    pageBloc.submitRegisterStream.listen((res) {
      if (!res.isSuccess) {
        showSnackBar(res.errorMessage);
      } else {
        appBloc.updateUser();
        showSimpleDialog(context, 'Tạo đội bóng thành công',
            onTap: () => Navigator.of(context).pop());
      }
    });
  }
}
