import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:myfootball/blocs/create-group-bloc.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/widgets/app-bar-button.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfootball/ui/widgets/button-widget.dart';
import 'package:myfootball/ui/widgets/choose-image.dart';
import 'package:myfootball/ui/widgets/input-widget.dart';
import 'package:myfootball/utils/device-util.dart';
import 'package:myfootball/utils/validator.dart';

class CreateGroupPage extends BasePage<CreateGroupBloc> with Validator {
  final _formKey = GlobalKey<FormState>();

  @override
  AppBarWidget buildAppBar(BuildContext context) => AppBarWidget(
        rightContent: AppBarButtonWidget(),
        leftContent: AppBarButtonWidget(
          imageName: 'icn_back.png',
          onTap: () => Navigator.of(context).pop(),
        ),
        centerContent: Center(
          child: Text(
            'Đăng ký đội bóng mới',
            style: Theme.of(context).textTheme.title,
          ),
        ),
      );

  @override
  Widget buildLoading(BuildContext context) {
    return null;
  }

  _showChooseImage(BuildContext context) => showModalBottomSheet(
        context: context,
        builder: (c) => ChooseImageWidget(
              onTapCamera: () async {
                var image =
                    await ImagePicker.pickImage(source: ImageSource.camera);
                pageBloc.chooseLogoFunc(image);
              },
              onTapGallery: () async {
                var image =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                pageBloc.chooseLogoFunc(image);
              },
            ),
      );

  Widget _buildItemColor(BuildContext context, Color color) => Padding(
        padding: EdgeInsets.all(5),
        child: Container(
          height: 40,
          width: 40,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 0.5, color: Colors.grey)),
        ),
      );

  @override
  Widget buildMainContainer(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(10),
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
                border: Border.all(color: AppColor.LINE_COLOR, width: 1)),
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
                        'assets/images/icn_gallery.png',
                        width: 50,
                        height: 50,
                        color: Colors.grey,
                      ),
                      Text(
                        'Logo',
                        style: Theme.of(context).textTheme.body2.copyWith(
                            fontFamily: 'semi-bold', color: Colors.grey),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              InputWidget(
                  validator: (value) {
                    if (value.isEmpty) return 'Vui lòng nhập tên đội bóng';
                  },
                  inputType: TextInputType.text,
                  inputAction: TextInputAction.next,
                  labelText: 'Tên đội bóng',
                  onChangedText: (text) => pageBloc.changeNameFunc(text)),
              InputWidget(
                  validator: (value) {
                    if (value.isEmpty) return 'Vui lòng nhập giới thiệu';
                  },
                  maxLines: 5,
                  inputType: TextInputType.text,
                  inputAction: TextInputAction.done,
                  labelText: 'Giới thiệu đội bóng',
                  onChangedText: (text) => pageBloc.changeBioFunc(text)),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Màu áo',
          style: Theme.of(context)
              .textTheme
              .body2
              .copyWith(color: AppColor.SECOND_BLACK),
        ),
        Align(
          alignment: Alignment.center,
          child: StreamBuilder<Color>(
            stream: pageBloc.chooseDressStream,
            builder: (c, snap) => Image.asset(
                  'assets/images/icn_shirt.png',
                  width: 90,
                  height: 100,
                  color: snap.hasData ? snap.data : AppColor.WHITE,
                ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          width: DeviceUtil.getWidth(context),
          child: Swiper(
            physics: BouncingScrollPhysics(),
            viewportFraction: 45 / (DeviceUtil.getWidth(context) - 20),
            scale: 0.1,
            onIndexChanged: (index) =>
                pageBloc.chooseDressFunc(AppColor.DRESS_COLORS[index]),
            itemBuilder: (BuildContext context, int index) =>
                _buildItemColor(context, AppColor.DRESS_COLORS[index]),
            itemCount: AppColor.DRESS_COLORS.length,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: ButtonWidget(
            height: 40,
            width: 150,
            onTap: () {
              if (_formKey.currentState.validate()) {
                pageBloc.submitRegisterFunc(true);
              }
            },
            borderRadius: 5,
            margin: EdgeInsets.only(top: 30),
            backgroundColor: AppColor.GREEN,
            child: Text(
              'ĐĂNG KÝ',
              style: Theme.of(context)
                  .textTheme
                  .body2
                  .copyWith(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  @override
  void listenAppData(BuildContext context) {}

  @override
  void listenPageData(BuildContext context) {}

  @override
  bool resizeAvoidPadding() => true;

  @override
  bool showFullScreen() => null;
}
