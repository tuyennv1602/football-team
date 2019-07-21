import 'package:flutter/material.dart';
import 'package:myfootball/blocs/app-bloc.dart';
import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/strings.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:myfootball/ui/widgets/button-widget.dart';
import 'package:myfootball/utils/device-util.dart';

abstract class BasePage<T extends BaseBloc> extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  T pageBloc;

  AppBloc appBloc;

  Widget buildMainContainer(BuildContext context);

  void listenData(BuildContext context);

  AppBarWidget buildAppBar(BuildContext context);

  Widget buildLoading(BuildContext context);

  bool showFullScreen = false;

  bool isRootLevel = false;

  // set true if need scroll all textfield

  bool resizeAvoidPadding = false;

  void showSnackBar(String message, {Color backgroundColor, Duration duration}) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      duration: duration ?? Duration(milliseconds: 5000),
      backgroundColor: backgroundColor ?? Colors.red,
      content: Text(message),
    ));
  }

  void showSimpleDialog(BuildContext context, String message, {Function onTap}) => showDialog(
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
                  Strings.NOTIFY,
                  style: Theme.of(context).textTheme.title.copyWith(color: AppColor.MAIN_BLACK),
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
                  borderRadius: BorderRadius.circular(5),
                  margin: EdgeInsets.only(top: 15),
                  width: 110,
                  height: 40,
                  backgroundColor: AppColor.GREEN,
                  child: Text(
                    Strings.OK,
                    style: Theme.of(context).textTheme.body2.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ));

  void showConfirmDialog(BuildContext context, String message, {Function onConfirmed}) =>
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
                      Strings.NOTIFY,
                      style: Theme.of(context).textTheme.title.copyWith(color: AppColor.MAIN_BLACK),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.body2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        ButtonWidget(
                          onTap: () => Navigator.of(context).pop(),
                          borderRadius: BorderRadius.circular(5),
                          margin: EdgeInsets.only(top: 15),
                          width: 110,
                          height: 40,
                          backgroundColor: Colors.grey,
                          child: Text(
                            Strings.CANCEL,
                            style: Theme.of(context).textTheme.body2.copyWith(color: Colors.white),
                          ),
                        ),
                        ButtonWidget(
                          onTap: () {
                            onConfirmed();
                            Navigator.of(context).pop();
                          },
                          borderRadius: BorderRadius.circular(5),
                          margin: EdgeInsets.only(top: 15),
                          width: 110,
                          height: 40,
                          backgroundColor: AppColor.GREEN,
                          child: Text(
                            Strings.OK,
                            style: Theme.of(context).textTheme.body2.copyWith(color: Colors.white),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ));

  void hideKeyBoard(BuildContext context) => FocusScope.of(context).requestFocus(new FocusNode());

  @override
  Widget build(BuildContext context) {
    if (appBloc == null) {
      appBloc = BlocProvider.of<AppBloc>(context);
    }
    if (pageBloc == null) {
      pageBloc = BlocProvider.of<T>(context);
    }
    listenData(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: resizeAvoidPadding,
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              !showFullScreen
                  ? Container(
                      height: DeviceUtil.getPaddingTop(context),
                      color: AppColor.GREEN,
                    )
                  : SizedBox(),
              buildAppBar(context) ?? SizedBox(),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => hideKeyBoard(context),
                  child: SizedBox(
                    width: DeviceUtil.getWidth(context),
                    child: buildMainContainer(context),
                  ),
                ),
              ),
              !showFullScreen
                  ? SizedBox(
                      height: isRootLevel
                          ? MediaQuery.of(context).padding.bottom
                          : DeviceUtil.getPaddingBottom(context),
                    )
                  : SizedBox()
            ],
          ),
          buildLoading(context) ?? SizedBox()
        ],
      ),
    );
  }
}
