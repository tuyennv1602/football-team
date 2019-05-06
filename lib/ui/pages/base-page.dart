import 'package:flutter/material.dart';
import 'package:myfootball/blocs/app-bloc.dart';
import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:myfootball/ui/widgets/button-widget.dart';

abstract class BasePage<T extends BaseBloc> extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  T pageBloc;

  AppBloc appBloc;

  Widget buildMainContainer(BuildContext context);

  void listenPageData(BuildContext context);

  void listenAppData(BuildContext context);

  AppBarWidget buildAppBar(BuildContext context);

  Widget buildLoading(BuildContext context);

  bool showFullScreen();

  bool resizeAvoidPadding();

  void showSnackBar(String message,
      {Color backgroundColor, Duration duration}) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      duration: duration ?? Duration(milliseconds: 5000),
      backgroundColor: backgroundColor ?? Colors.red,
      content: Text(message),
    ));
  }

  showSimpleDialog(BuildContext context, String message, {Function onTap}) =>
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                contentPadding: EdgeInsets.all(10),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Thông báo',
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(color: AppColor.MAIN_BLACK),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.body2,
                    ),
                    ButtonWidget(
                      onTap: () {
                        onTap();
                        Navigator.of(context).pop();
                      },
                      borderRadius: 5,
                      margin: EdgeInsets.only(top: 15),
                      width: 100,
                      height: 40,
                      backgroundColor: AppColor.GREEN,
                      child: Text(
                        'Đồng ý',
                        style: Theme.of(context)
                            .textTheme
                            .body2
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ));

  showConfirmDialog(BuildContext context, String message,
          {Function onConfirmed}) =>
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                contentPadding: EdgeInsets.all(10),
                actions: <Widget>[
                  ButtonWidget(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: 5,
                    margin: EdgeInsets.only(top: 15),
                    width: 100,
                    height: 40,
                    backgroundColor: Colors.grey,
                    child: Text(
                      'Huỷ',
                      style: Theme.of(context)
                          .textTheme
                          .body2
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  ButtonWidget(
                    onTap: () {
                      onConfirmed();
                      Navigator.of(context).pop();
                    },
                    borderRadius: 5,
                    margin: EdgeInsets.only(top: 15),
                    width: 100,
                    height: 40,
                    backgroundColor: AppColor.GREEN,
                    child: Text(
                      'Đồng ý',
                      style: Theme.of(context)
                          .textTheme
                          .body2
                          .copyWith(color: Colors.white),
                    ),
                  )
                ],
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Thông báo',
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(color: AppColor.MAIN_BLACK),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.body2,
                    ),
                  ],
                ),
              ));

  hideKeyBoard(BuildContext context) =>
      FocusScope.of(context).requestFocus(new FocusNode());

  @override
  Widget build(BuildContext context) {
    if (appBloc == null) {
      appBloc = BlocProvider.of<AppBloc>(context);
      listenAppData(context);
    }
    if (pageBloc == null) {
      pageBloc = BlocProvider.of<T>(context);
      listenPageData(context);
    }
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColor.WHITE,
      resizeToAvoidBottomPadding: resizeAvoidPadding() ?? true,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                (showFullScreen() == null || !showFullScreen())
                    ? Container(
                        height: MediaQuery.of(context).padding.top,
                        color: AppColor.GREEN,
                      )
                    : SizedBox(),
                buildAppBar(context) ?? SizedBox(),
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: buildMainContainer(context),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                )
              ],
            ),
            buildLoading(context) ?? SizedBox()
          ],
        ),
      ),
    );
  }
}
