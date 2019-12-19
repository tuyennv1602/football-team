import 'package:flutter/material.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/line.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:local_auth/local_auth.dart';

typedef void OnAuthentication(bool isSuccess);

class AuthenticationWidget extends StatefulWidget {
  final OnAuthentication onAuthentication;

  AuthenticationWidget({Key key, @required this.onAuthentication})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AuthenticationState();
  }
}

class _AuthenticationState extends State<AuthenticationWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  String password = '';
  bool error = false;

  @override
  void initState() {
    super.initState();
    _showBiometricsAuth();
    controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
  }

  Future<void> _showBiometricsAuth() async {
    var _localAuth = LocalAuthentication();
    var _canCheck = await _localAuth.canCheckBiometrics;
    try {
      if (_canCheck) {
        bool didAuthenticate = await _localAuth.authenticateWithBiometrics(
          stickyAuth: true,
          localizedReason: 'Vui lòng xác thực để thực hiện giao dịch',
          androidAuthStrings: AndroidAuthMessages(
            signInTitle: 'Xác thực',
            cancelButton: 'Huỷ',
            fingerprintHint: 'Đặt tay vào cảm biến',
            fingerprintSuccess: 'Xác thực thành công',
            fingerprintNotRecognized: 'Không khớp',
          ),
          iOSAuthStrings: IOSAuthMessages(
              cancelButton: 'Huỷ',
              goToSettingsButton: 'Cài đặt',
              goToSettingsDescription:
                  'Touch ID hoặc Face ID chưa được bật. Vui lòng bật Touch ID hoặc Face ID trong mục Cài đặt'),
        );
        widget.onAuthentication(didAuthenticate);
      }
    } catch (e) {
      print(e);
    }
  }

  Widget _buildIndicator(bool isSelected) => Container(
        width: 12,
        height: 12,
        margin: EdgeInsets.symmetric(
            horizontal: UIHelper.size10, vertical: UIHelper.size25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: isSelected ? (error ? Colors.red : PRIMARY) : Colors.grey[300],
        ),
      );

  Widget _buildItemNumber(String title) => InkWell(
        onTap: () {
          if (password.length < 6) {
            setState(() {
              password = password + title;
            });
            print(password);
          }
          if (password.length == 6) {
            if (password == "000000") {
              widget.onAuthentication(true);
            } else {
              setState(() {
                error = true;
              });
              controller.forward(from: 0.0);
              Future.delayed(Duration(seconds: 1), () {
                setState(() {
                  error = false;
                  password = '';
                });
              });
            }
          }
        },
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Text(
            title,
            style: textStyleSemiBold(size: 18),
            textAlign: TextAlign.center,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 25.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            }
          });
    return Container(
      color: Colors.transparent,
      child: Wrap(
        children: <Widget>[
          Container(
            width: UIHelper.screenWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(UIHelper.size15),
                  topLeft: Radius.circular(UIHelper.size15)),
            ),
            padding: EdgeInsets.only(bottom: UIHelper.paddingBottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    AppBarButtonWidget(),
                    Expanded(
                      child: Text(
                        'Xác thực',
                        style: textStyleSemiBold(size: 17),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    AppBarButtonWidget(
                      imageName: Images.CLOSE,
                      onTap: () => Navigator.of(context).pop(),
                      iconColor: Colors.grey,
                      padding: UIHelper.size(18),
                    ),
                  ],
                ),
                LineWidget(indent: 0),
                AnimatedBuilder(
                  animation: offsetAnimation,
                  builder: (c, child) {
                    if (offsetAnimation.value < 0.0)
                      print('${offsetAnimation.value + 8.0}');
                    return Padding(
                      padding: EdgeInsets.only(
                          left: offsetAnimation.value + 25,
                          right: 25 - offsetAnimation.value),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _buildIndicator(password.length > 0),
                          _buildIndicator(password.length > 1),
                          _buildIndicator(password.length > 2),
                          _buildIndicator(password.length > 3),
                          _buildIndicator(password.length > 4),
                          _buildIndicator(password.length > 5),
                        ],
                      ),
                    );
                  },
                ),
                InkWell(
                  onTap: () => _showBiometricsAuth(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        Images.FINGERPRINT,
                        width: UIHelper.size25,
                        height: UIHelper.size25,
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: UIHelper.size10),
                        child: Text(
                          'Xác thực vân tay/Face Id',
                          style: textStyleRegular(color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: LINE_COLOR,
                  margin: EdgeInsets.only(top: UIHelper.size30),
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    childAspectRatio: 2.5,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    padding: EdgeInsets.only(bottom: 1, top: 1),
                    physics: ClampingScrollPhysics(),
                    children: <Widget>[
                      _buildItemNumber('1'),
                      _buildItemNumber('2'),
                      _buildItemNumber('3'),
                      _buildItemNumber('4'),
                      _buildItemNumber('5'),
                      _buildItemNumber('6'),
                      _buildItemNumber('7'),
                      _buildItemNumber('8'),
                      _buildItemNumber('9'),
                      SizedBox(),
                      _buildItemNumber('0'),
                      InkWell(
                        onTap: () {
                          if (password.length > 0) {
                            setState(() {
                              password =
                                  password.substring(0, password.length - 1);
                            });
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(UIHelper.size15),
                          child: Image.asset(
                            Images.DELETE,
                            scale: 0.5,
                            width: UIHelper.size10,
                            height: UIHelper.size10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
