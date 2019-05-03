import 'package:myfootball/blocs/user-bloc.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/ui/widgets/border-frame.dart';
import 'package:myfootball/ui/widgets/item-option.dart';
import 'package:myfootball/ui/widgets/loading.dart';

class UserPage extends BasePage<UserBloc> {
  @override
  AppBarWidget buildAppBar(BuildContext context) {
    return AppBarWidget(
      centerContent: Center(
        child: Text(
          "User",
          style: Theme.of(context).textTheme.title,
        ),
      ),
    );
  }

  @override
  Widget buildLoading(BuildContext context) {
    return LoadingWidget(
      show: false,
    );
  }

  @override
  Widget buildMainContainer(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            color: AppColor.GREEN,
          ),
          child: Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://as00.epimg.net/en/imagenes/2019/01/13/football/1547404844_886837_1547406152_noticia_normal.jpg'),
            ),
          ),
        ),
        BorderFrameWidget(
          margin: EdgeInsets.all(15),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Số dư trong ví',
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(color: AppColor.MAIN_BLACK),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                '100.000đ',
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: AppColor.MAIN_BLACK),
              )
            ],
          ),
        ),
        BorderFrameWidget(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: GridView.count(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            crossAxisCount: 3,
            childAspectRatio: 1.2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: <Widget>[
              ItemOptionWidget('assets/images/icn_facebook.png', 'Chỉnh sửa'),
              ItemOptionWidget('assets/images/icn_facebook.png', 'Chỉnh sửa'),
              ItemOptionWidget('assets/images/icn_facebook.png', 'Chỉnh sửa'),
              ItemOptionWidget('assets/images/icn_facebook.png', 'Chỉnh sửa'),
              ItemOptionWidget('assets/images/icn_facebook.png', 'Chỉnh sửa'),
              ItemOptionWidget('assets/images/icn_facebook.png', 'Chỉnh sửa'),
              ItemOptionWidget('assets/images/icn_facebook.png', 'Chỉnh sửa'),
              ItemOptionWidget('assets/images/icn_facebook.png', 'Chỉnh sửa'),
              ItemOptionWidget('assets/images/icn_facebook.png', 'Chỉnh sửa')
            ],
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
  bool resizeAvoidPadding() => null;

  @override
  bool showFullScreen() => false;
}
