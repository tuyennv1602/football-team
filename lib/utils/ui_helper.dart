import 'package:flutter/material.dart';
import 'package:myfootball/res/styles.dart';
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
    progressDialog = new ProgressDialog(context, isDismissible: false);
  }

  static Widget verticalSpaceSmall = SizedBox(height: size5);
  static Widget verticalSpaceMedium = SizedBox(height: size10);
  static Widget verticalSpaceLarge = SizedBox(height: size20);
  static Widget verticalIndicator = SizedBox(height: size10);

  static Widget horizontalSpaceSmall = SizedBox(width: size5);
  static Widget horizontalSpaceMedium = SizedBox(width: size10);
  static Widget horizontalSpaceLarge = SizedBox(width: size20);

  static Widget homeButtonSpace =
      SizedBox(height: paddingBottom, width: screenWidth);

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

  static void showSimpleDialog(String message, {Function onTap}) => showDialog(
      context: _buildContext,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(size5),
            ),
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: screenWidth * 0.9,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(UIHelper.size15),
                    child: Column(
                      children: <Widget>[
                        Text('Thông báo', style: textStyleSemiBold()),
                        UIHelper.verticalSpaceMedium,
                        Text(
                          message,
                          style: textStyleRegular(size: 16),
                          textAlign: TextAlign.center,
                        ),
                        UIHelper.verticalSpaceMedium,
                      ],
                    ),
                  ),
                  Align(
                    child: ButtonWidget(
                      onTap: () {
                        Navigator.of(context).pop();
                        if (onTap != null) {
                          onTap();
                        }
                      },
                      height: size40,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(size5),
                          bottomRight: Radius.circular(size5)),
                      child: Text(
                        'Xong',
                        style: textStyleSemiBold(size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));

  static void showConfirmDialog(String message, {Function onConfirmed}) =>
      UIHelper.showCustomizeDialog(
        child: Column(
          children: <Widget>[
            Text('Xác nhận', style: textStyleSemiBold()),
            UIHelper.verticalSpaceMedium,
            Text(
              message,
              style: textStyleRegular(size: 16),
              textAlign: TextAlign.center,
            ),
            UIHelper.verticalSpaceMedium,
          ],
        ),
        onConfirmed: () => onConfirmed(),
      );

  static void showCustomizeDialog({Widget child, Function onConfirmed}) =>
      showDialog(
        context: _buildContext,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size5),
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: screenWidth * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(size15),
                  child: child,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ButtonWidget(
                        onTap: () => Navigator.of(context).pop(),
                        height: size40,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(size5)),
                        backgroundColor: Colors.grey,
                        child: Text(
                          'Huỷ',
                          style: textStyleSemiBold(color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ButtonWidget(
                        onTap: () {
                          Navigator.of(context).pop();
                          onConfirmed();
                        },
                        height: size40,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(size5)),
                        child: Text(
                          'Đồng ý',
                          style: textStyleSemiBold(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );

  static void hideKeyBoard() =>
      FocusScope.of(_buildContext).requestFocus(new FocusNode());
}
