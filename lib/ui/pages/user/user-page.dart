import 'package:myfootball/blocs/user-bloc.dart';
import 'package:myfootball/models/user.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/routes/routes.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/ui/widgets/border-frame.dart';
import 'package:myfootball/ui/widgets/item-option.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/utils/string-util.dart';

// ignore: must_be_immutable
class UserPage extends BasePage<UserBloc> {
  @override
  AppBarWidget buildAppBar(BuildContext context) {
    return AppBarWidget(
      centerContent: Text(
        'Thông tin cá nhân',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.title,
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
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
              color: AppColor.GREEN,
            ),
            child: StreamBuilder<User>(
              stream: appBloc.userStream,
              builder: (c, snap) {
                if (snap.hasData) {
                  var _user = snap.data;
                  var wallet = _user.wallet != null
                      ? StringUtil.formatCurrency(snap.data.wallet * 1000)
                      : '0đ';
                  return Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: _user.avatar != null
                            ? NetworkImage(_user.avatar)
                            : AssetImage(Images.DEFAULT_AVATAR),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _user.userName,
                              style: Theme.of(context).textTheme.title,
                            ),
                            Text(
                              'Số dư trong ví: $wallet',
                              style:
                                  Theme.of(context).textTheme.body2,
                            )
                          ],
                        ),
                      )
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.all(10),
              children: <Widget>[
                BorderFrameWidget(
                  child: GridView.count(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    physics: ClampingScrollPhysics(),
                    mainAxisSpacing: 10,
                    children: <Widget>[
                      ItemOptionWidget(Images.EDIT_PROFILE, 'Sửa hồ sơ'),
                      ItemOptionWidget(Images.WALLET_IN, 'Nạp tiền'),
                      ItemOptionWidget(Images.WALLET_OUT, 'Rút tiền'),
                      ItemOptionWidget(
                        Images.TRANSACTIONS,
                        'Chuyển tiền',
                      ),
                      ItemOptionWidget(Images.TRANSACTION_HISTORY, 'Lịch sử giao dịch'),
                      ItemOptionWidget(
                        Images.INVITE,
                        'Tham gia đội bóng',
                        onTap: () => Routes.routeToRequestMemberPage(context),
                      ),
                      ItemOptionWidget(
                        Images.CREATE_GROUP,
                        'Thành lập đội bóng',
                        onTap: () => Routes.routeToCreateGroupPage(context),
                      ),
                      ItemOptionWidget(Images.SETTING, 'Cài đặt'),
                      ItemOptionWidget(
                        Images.LOGOUT,
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
  void listenData(BuildContext context) {
    pageBloc.logoutStream.listen((result) {
      if (result) {
        Routes.routeToLoginPage(context);
      } else {
        showSnackBar('Lỗi');
      }
    });
  }

  @override
  bool get hasBottomBar => true;
}
