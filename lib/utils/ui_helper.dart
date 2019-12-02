import 'package:flutter/material.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/ui/widgets/button_widget.dart';
import 'package:myfootball/ui/widgets/progress_dialog.dart';

class UIHelper {
  static MediaQueryData _mediaQueryData;
  static BuildContext _buildContext;
  static ProgressDialog progressDialog;
  static double paddingTop;
  static double paddingBottom;
  static double screenWidth;
  static double screenHeight;
  static double size5;
  static double size10;
  static double size15;
  static double size20;
  static double size25;
  static double size30;
  static double size35;
  static double size40;
  static double size45;
  static double size50;
  static double radius;
  static double padding;

  void init(BuildContext context) {
    _buildContext = context;
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    paddingTop = _mediaQueryData.padding.top;
    paddingBottom = _mediaQueryData.padding.bottom;
    size5 = size(5);
    size10 = size(10);
    size15 = size(15);
    size20 = size(20);
    size25 = size(25);
    size30 = size(30);
    size35 = size(35);
    size40 = size(40);
    size45 = size(45);
    size50 = size(50);
    radius = size(20);
    padding = size(12);
    progressDialog = new ProgressDialog(context, isDismissible: false);
  }

  static Widget verticalSpaceSmall = SizedBox(height: size5, width: 1);
  static Widget verticalSpaceMedium = SizedBox(height: size10, width: 1);
  static Widget verticalSpaceLarge = SizedBox(height: size20, width: 1);
  static Widget verticalIndicator = SizedBox(height: padding, width: 1);

  static Widget horizontalSpaceSmall = SizedBox(width: size5, height: 1);
  static Widget horizontalSpaceMedium = SizedBox(width: size10, height: 1);
  static Widget horizontalSpaceLarge = SizedBox(width: size20, height: 1);
  static double horizontalIndicator = padding;

  static Widget homeButtonSpace =
      Container(color: Colors.white, height: paddingBottom, width: screenWidth);

  static double size(double size) {
    if (size == 0) return 0;
    const double baseWidth = 375;
    double percent = screenWidth / baseWidth;
    if (percent < 1) {
      return size * percent;
    }
    return size;
  }

  static get showProgressDialog => progressDialog.show();

  static get hideProgressDialog => progressDialog.hide();

  static void showSimpleDialog(String message,
          {bool isSuccess = false, Function onConfirmed}) =>
      showCustomizeDialog('simple_dialog',
          dismissiable: false,
          confirmLabel: 'XONG',
          showCancel: false,
          icon: isSuccess ? Images.SUCCESS : Images.CANCEL,
          gradientColors: isSuccess ? GREEN_GRADIENT : RED_GRADIENT,
          confirmColor: isSuccess ? GREEN_SUCCESS : RED_ERROR, onConfirmed: () {
        NavigationService.instance.goBack();
        if (onConfirmed != null) {
          onConfirmed();
        }
      },
          child: Text(
            message,
            style: textStyleAlert(),
          ));

  static void showConfirmDialog(String message,
          {Widget child,
          String icon = Images.QUESTION,
          @required Function onConfirmed}) =>
      showCustomizeDialog(
        'confirm_dialog',
        dismissiable: true,
        onConfirmed: () {
          NavigationService.instance.goBack();
          onConfirmed();
        },
        child: child ??
            Text(
              message,
              style: textStyleAlert(),
            ),
      );

  static void showCustomizeDialog(String label,
          {@required Widget child,
          bool showCancel = true,
          bool dismissiable = true,
          String confirmLabel = 'ĐỒNG Ý',
          Color confirmColor,
          List<Color> gradientColors,
          String icon = Images.QUESTION,
          Function onConfirmed}) =>
      showGeneralDialog(
        barrierLabel: label,
        barrierDismissible: dismissiable,
        barrierColor: Colors.black.withOpacity(0.6),
        transitionDuration: Duration(milliseconds: 300),
        context: _buildContext,
        pageBuilder: (context, anim1, anim2) => Material(
          child: Align(
            alignment: Alignment.topCenter,
            child: Wrap(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(
                            size30, paddingTop + size15, size30, size30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(UIHelper.size20),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: gradientColors ?? GREEN_GRADIENT,
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              icon,
                              width: size50,
                              height: size50,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: size30),
                              child: child,
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          showCancel
                              ? ButtonWidget(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  width: screenWidth / 3,
                                  backgroundColor: Colors.grey,
                                  height: size40,
                                  borderRadius:
                                      BorderRadius.circular(UIHelper.size40),
                                  child: Text(
                                    'HUỶ',
                                    style: textStyleButton(),
                                  ),
                                )
                              : SizedBox(),
                          Padding(
                            padding: EdgeInsets.all(UIHelper.padding),
                            child: ButtonWidget(
                              onTap: () {
                                if (onConfirmed != null) {
                                  onConfirmed();
                                }
                              },
                              width: screenWidth / 3,
                              backgroundColor: confirmColor ?? GREEN_SUCCESS,
                              height: size40,
                              borderRadius:
                                  BorderRadius.circular(UIHelper.size40),
                              child: Text(
                                confirmLabel,
                                style: textStyleButton(),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(UIHelper.size20),
                      ),
                      color: Colors.white),
                )
              ],
            ),
          ),
        ),
        transitionBuilder: (context, anim1, anim2, child) => SlideTransition(
          position:
              Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
          child: child,
        ),
      );

  static void hideKeyBoard() =>
      FocusScope.of(_buildContext).requestFocus(new FocusNode());
}
