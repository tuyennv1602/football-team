import 'package:myfootball/blocs/user-bloc.dart';
import 'package:myfootball/models/user.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/routes/routes.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/ui/widgets/border-frame.dart';
import 'package:myfootball/ui/widgets/item-option.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/utils/string-util.dart';

class UserPage extends BasePage<UserBloc> {
  @override
  AppBarWidget buildAppBar(BuildContext context) {
    return AppBarWidget(
      centerContent: Center(
        child: StreamBuilder<User>(
          stream: appBloc.userStream,
          builder: (c, snap) => Text(
                snap.hasData ? snap.data.userName : '',
                style: Theme.of(context).textTheme.title,
              ),
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
  Widget buildMainContainer(BuildContext context) => Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              color: AppColor.GREEN,
            ),
            child: Center(
              child: StreamBuilder<User>(
                stream: appBloc.userStream,
                builder: (c, snap) {
                  if (snap.hasData && snap.data.avatar != null) {
                    return CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(snap.data.avatar),
                    );
                  } else {
                    return CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/icn_man.png'),
                    );
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.all(10),
              children: <Widget>[
                BorderFrameWidget(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Ví cá nhân',
                          style: Theme.of(context)
                              .textTheme
                              .title
                              .copyWith(color: AppColor.MAIN_BLACK),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      StreamBuilder<User>(
                        stream: appBloc.userStream,
                        builder: (c, snap) => Text(
                              (snap.hasData && snap.data.wallet != null)
                                  ? StringUtil.formatCurrency(
                                      snap.data.wallet * 1000)
                                  : '0đ',
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .copyWith(color: AppColor.MAIN_BLACK),
                            ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                BorderFrameWidget(
                  child: GridView.count(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    physics: ClampingScrollPhysics(),
                    mainAxisSpacing: 15,
                    children: <Widget>[
                      ItemOptionWidget(
                          'assets/images/icn_edit.png', 'Sửa hồ sơ'),
                      ItemOptionWidget(
                          'assets/images/icn_wallet_in.png', 'Nạp tiền'),
                      ItemOptionWidget(
                          'assets/images/icn_wallet_out.png', 'Rút tiền'),
                      ItemOptionWidget(
                          'assets/images/icn_transaction.png', 'Chuyển tiền'),
                      ItemOptionWidget(
                          'assets/images/icn_history.png', 'Lịch sử giao dịch'),
                      ItemOptionWidget(
                          'assets/images/icn_invite.png', 'Mời bạn bè'),
                      ItemOptionWidget(
                          'assets/images/icn_settings.png', 'Cài đặt'),
                      ItemOptionWidget(
                          'assets/images/icn_help.png', 'Trợ giúp'),
                      ItemOptionWidget(
                        'assets/images/icn_logout.png',
                        'Đăng xuất',
                        onTap: () => pageBloc.logoutFunc(true),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      );

  @override
  void listenAppData(BuildContext context) {}

  @override
  void listenPageData(BuildContext context) {
    pageBloc.logoutStream.listen((result) {
      if (result) {
        Routes.routeToLoginPage(context);
      } else {
        showSnackBar('Lỗi');
      }
    });
  }

  @override
  bool resizeAvoidPadding() => null;

  @override
  bool showFullScreen() => false;
}
