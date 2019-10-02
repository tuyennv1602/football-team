import 'package:myfootball/models/user.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/routes/routes.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/item_option.dart';
import 'package:myfootball/utils/ui-helper.dart';
import 'package:myfootball/utils/string-util.dart';
import 'package:myfootball/viewmodels/user_view_model.dart';
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    UIHelper().init(context);
    var _user = Provider.of<User>(context);
    var wallet = _user.wallet != null
        ? StringUtil.formatCurrency(_user.wallet * 1000)
        : '0đ';
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: PRIMARY,
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(bottom: UIHelper.size20),
                child: Column(
                  children: <Widget>[
                    BaseWidget<UserViewModel>(
                      model:
                          UserViewModel(sharePreferences: Provider.of(context)),
                      builder: (context, model, child) => AppBarWidget(
                        leftContent: AppBarButtonWidget(
                          imageName: Images.LOGOUT,
                          onTap: () async {
                            UIHelper.showProgressDialog;
                            await model.logout();
                            UIHelper.hideProgressDialog;
                            Routes.routeToLogin(_scaffoldKey.currentContext);
                          },
                        ),
                        centerContent: Text(_user.name ?? _user.userName,
                            textAlign: TextAlign.center,
                            style: textStyleTitle()),
                        rightContent: AppBarButtonWidget(
                          imageName: Images.EDIT,
                          onTap: () {},
                        ),
                      ),
                    ),
                    ImageWidget(
                      source: _user.avatar,
                      placeHolder: Images.DEFAULT_AVATAR,
                      size: UIHelper.size(100),
                      radius: UIHelper.size(50),
                    )
                  ],
                )),
            Expanded(
              child: BorderBackground(
                child: Column(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: UIHelper.size20, vertical: UIHelper.size10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Số dư trong ví',
                          style: textStyleTitle(color: BLACK_TEXT),
                        ),
                        Text(
                          '$wallet',
                          style: textStyleTitle(color: BLACK_TEXT),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        LineWidget(),
                        ItemOptionWidget(Images.WALLET_IN, 'Nạp tiền vào ví',
                            iconColor: Colors.green),
                        LineWidget(),
                        ItemOptionWidget(Images.WALLET_OUT, 'Rút tiền',
                            iconColor: Colors.red),
                        LineWidget(),
                        ItemOptionWidget(
                          Images.TRANSACTIONS,
                          'Chuyển tiền',
                          iconColor: Colors.amber,
                        ),
                        LineWidget(),
                        ItemOptionWidget(
                          Images.TRANSACTION_HISTORY,
                          'Lịch sử giao dịch',
                          iconColor: Colors.teal,
                        ),
                        LineWidget(),
                        ItemOptionWidget(
                          Images.ADD_REQUEST,
                          'Tham gia đội bóng',
                          iconColor: Colors.cyan,
                          onTap: () => Routes.routeToRequestMember(context),
                        ),
                        LineWidget(),
                        ItemOptionWidget(
                          Images.ADD_TEAM,
                          'Đăng ký đội bóng',
                          iconColor: Colors.indigoAccent,
                          onTap: () => Routes.routeToCreateGroup(context),
                        ),
                        LineWidget(),
                        ItemOptionWidget(
                          Images.SHARE,
                          'Chia sẻ ứng dụng',
                          iconColor: Colors.blueAccent,
                        ),
                        LineWidget(),
                        ItemOptionWidget(
                          Images.INFO,
                          'Thông tin ứng dụng',
                          iconColor: Colors.blue,
                        ),
                        LineWidget(),
                        ItemOptionWidget(
                          Images.SETTING,
                          'Cài đặt',
                          iconColor: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}