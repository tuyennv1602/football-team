import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:myfootball/blocs/social-bloc.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:myfootball/utils/device-util.dart';

class SocialPage extends BasePage<SocialBloc> {
  Widget _buildCateTitle(String title) => Text(
        title,
        style: TextStyle(
            color: AppColor.MAIN_BLACK, fontFamily: 'semi-bold', fontSize: 18),
      );

  Widget _buildItemNew(BuildContext context, int index) => Container(
        width: DeviceUtil.getWidth(context) / 2,
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            color: AppColor.GREY_BACKGROUND,
            borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.all(10),
        child: Text("Item $index"),
      );

  Widget _buildNewsest(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildCateTitle('Tin tức mới nhất'),
        SizedBox(
          height: 10,
        ),
        Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 150,
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (c, index) => _buildItemNew(context, index),
            )),
      ],
    );
  }

  @override
  AppBarWidget buildAppBar(BuildContext context) => AppBarWidget(
        centerContent: Center(
          child: Text(
            'Cộng đồng',
            style: Theme.of(context).textTheme.title,
          ),
        ),
      );

  @override
  Widget buildLoading(BuildContext context) {
    return null;
  }

  @override
  Widget buildMainContainer(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(10),
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[_buildNewsest(context)],
    );
  }

  @override
  void listenAppData(BuildContext context) {}

  @override
  void listenPageData(BuildContext context) {}

  @override
  bool resizeAvoidPadding() {
    return null;
  }

  @override
  bool showFullScreen() {
    return null;
  }
}
