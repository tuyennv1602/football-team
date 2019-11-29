import 'package:image_picker/image_picker.dart';
import 'package:myfootball/models/user.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/pages/team/search_team_page.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/bottom_sheet.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/item_option.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/user_viewmodel.dart';
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

  _showChooseImage(BuildContext context, Function onImageReady) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: ['Chọn ảnh logo', 'Từ máy ảnh', 'Từ thư viện', 'Huỷ'],
          paddingBottom: 0,
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var _user = Provider.of<User>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: PRIMARY,
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: UIHelper.size(200) + UIHelper.paddingTop,
            padding: EdgeInsets.symmetric(horizontal: UIHelper.size15),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/user_cover.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          ImageWidget(
                            source: _user.avatar,
                            placeHolder: Images.DEFAULT_AVATAR,
                            size: UIHelper.size(100),
                            radius: UIHelper.size(50),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () =>
                                  _showChooseImage(context, (image) {}),
                              child: Container(
                                width: UIHelper.size35,
                                height: UIHelper.size35,
                                padding: EdgeInsets.all(UIHelper.size(7)),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(
                                      UIHelper.size35 / 2),
                                  border: Border.all(
                                      color: Colors.white, width: 1.5),
                                ),
                                child: Image.asset(Images.CAMERA,
                                    color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                      UIHelper.horizontalSpaceLarge,
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _user.name ?? _user.userName,
                            textAlign: TextAlign.center,
                            style: textStyleSemiBold(
                                size: 22, color: Colors.white),
                          ),
                          Text(
                            _user.email,
                            style: textStyleRegularTitle(color: Colors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ))
                    ],
                  ),
                ),
                UIHelper.verticalSpaceMedium
              ],
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(top: UIHelper.size(180) + UIHelper.paddingTop),
            child: BorderBackground(
              child: Column(children: <Widget>[
//                  Padding(
//                    padding: EdgeInsets.symmetric(
//                        horizontal: UIHelper.size20, vertical: UIHelper.size15),
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        Text(
//                          'Số dư trong ví',
//                          style: textStyleTitle(color: BLACK_TEXT),
//                        ),
//                        Text(
//                          '$wallet',
//                          style: textStyleTitle(color: BLACK_TEXT),
//                        ),
//                      ],
//                    ),
//                  ),
//                  LineWidget(),
                Expanded(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(top: UIHelper.size5),
                    children: <Widget>[
//                        ItemOptionWidget(
//                          Images.WALLET_IN,
//                          'Nạp tiền vào ví',
//                          iconColor: Colors.green,
//                          onTap: () => NavigationService.instance()
//                              .navigateTo(INPUT_MONEY),
//                        ),
//                        ItemOptionWidget(Images.WALLET_OUT, 'Rút tiền',
//                            iconColor: Colors.red),
//                        ItemOptionWidget(
//                          Images.TRANSACTIONS,
//                          'Chuyển tiền',
//                          iconColor: Colors.amber,
//                        ),
                      ItemOptionWidget(
                        Images.TRANSACTION_HISTORY,
                        'Lịch sử giao dịch',
                        iconColor: Colors.amber,
                        onTap: () => NavigationService.instance
                            .navigateTo(USER_TRANSACTION_HISTORY),
                      ),
                      ItemOptionWidget(
                        Images.ADD_REQUEST,
                        'Tham gia đội bóng',
                        iconColor: Colors.cyan,
                        onTap: () => NavigationService.instance.navigateTo(
                            SEARCH_TEAM,
                            arguments: SEARCH_TYPE.REQUEST_MEMBER),
                      ),
                      ItemOptionWidget(
                        Images.ADD_TEAM,
                        'Thành lập đội bóng',
                        iconColor: Colors.orange,
                        onTap: () =>
                            NavigationService.instance.navigateTo(CREATE_TEAM),
                      ),

                      ItemOptionWidget(
                        Images.SHARE,
                        'Chia sẻ ứng dụng',
                        iconColor: Colors.blue,
                      ),
                      ItemOptionWidget(
                        Images.INFO,
                        'Thông tin ứng dụng',
                        iconColor: Colors.teal,
                      ),
                      ItemOptionWidget(
                        Images.PASSWORD,
                        'Đổi mật khẩu',
                        iconColor: Colors.red,
                      ),
                      BaseWidget<UserViewModel>(
                        model: UserViewModel(
                            sharePreferences: Provider.of(context),
                            teamServices: Provider.of(context)),
                        builder: (c, model, child) => ItemOptionWidget(
                            Images.LOGOUT, 'Đăng xuất',
                            iconColor: Colors.grey,
                            onTap: () => UIHelper.showConfirmDialog(
                                'Bạn có chắc chắn muốn đăng xuất?',
                                onConfirmed: () => model.logout())),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
