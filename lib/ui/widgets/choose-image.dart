import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/ui/widgets/button-widget.dart';

class ChooseImageWidget extends StatelessWidget {
  final Function onTapGallery;
  final Function onTapCamera;

  ChooseImageWidget({this.onTapCamera, this.onTapGallery});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.all(15),
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ButtonWidget(
            onTap: () {
              this.onTapGallery();
              Navigator.of(context).pop();
            },
            backgroundColor: AppColor.WHITE,
            height: 42,
            borderRadius: BorderRadius.circular(21),
            child: Text(
              'Chọn từ thư viện',
              style: Theme.of(context).textTheme.body2,
            ),
          ),
          Container(
            color: Colors.transparent,
            height: 5,
          ),
          ButtonWidget(
            onTap: () {
              this.onTapCamera();
              Navigator.of(context).pop();
            },
            backgroundColor: AppColor.WHITE,
            height: 42,
            borderRadius: BorderRadius.circular(21),
            child: Text(
              'Chọn từ máy ảnh',
              style: Theme.of(context).textTheme.body2,
            ),
          ),
          Container(
            color: Colors.transparent,
            height: 5,
          ),
          ButtonWidget(
            onTap: () => Navigator.of(context).pop(),
            backgroundColor: AppColor.RED,
            height: 42,
            borderRadius: BorderRadius.circular(21),
            child: Text(
              'Huỷ',
              style: Theme.of(context).textTheme.body2.copyWith(color: AppColor.WHITE),
            ),
          ),
        ],
      ),
    );
    ;
  }
}