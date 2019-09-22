import 'package:flutter/material.dart';
import 'package:myfootball/blocs/app-bloc.dart';
import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/stringres.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/widgets/button-widget.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/utils/ui-helper.dart';

// ignore: must_be_immutable
abstract class BasePage<T extends BaseBloc> extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  T pageBloc;

  AppBloc appBloc;

  Widget buildMainContainer(BuildContext context);

  void listenData(BuildContext context);

  Widget buildAppBar(BuildContext context);

  bool showFullScreen = false;

  // set true if need scroll all textfield

  bool resizeAvoidPadding = false;

  double get size5 => UIHelper.size(5);

  double get size10 => UIHelper.size(10);

  double get size15 => UIHelper.size(15);

  double get size20 => UIHelper.size(20);

  double get size25 => UIHelper.size(25);

  double get size30 => UIHelper.size(30);

  double get size35 => UIHelper.size(35);

  double get size40 => UIHelper.size(40);

  double get size45 => UIHelper.size(45);

  double get size50 => UIHelper.size(50);

  void showSnackBar(String message,
      {Color backgroundColor, Duration duration}) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      duration: duration ?? Duration(milliseconds: 5000),
      backgroundColor: backgroundColor ?? Colors.red,
      content: Text(message),
    ));
  }

  void showSimpleDialog(BuildContext context, String message,
          {Function onTap}) =>
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(size5),
                ),
                contentPadding: EdgeInsets.zero,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(size15),
                      child: Column(
                        children: <Widget>[
                          Text(
                            StringRes.NOTIFY,
                            style: textStyleSemiBold(size: 18),
                          ),
                          SizedBox(
                            height: size10,
                          ),
                          Text(message, style: textStyleRegular(size: 16))
                        ],
                      ),
                    ),
                    Align(
                      child: ButtonWidget(
                        onTap: () {
                          onTap();
                          Navigator.of(context).pop();
                        },
                        height: size40,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(size5),
                            bottomRight: Radius.circular(size5)),
                        backgroundColor: PRIMARY,
                        child: Text(
                          StringRes.OK,
                          style: textStyleButton(),
                        ),
                      ),
                    ),
                  ],
                ),
              ));

  void showConfirmDialog(BuildContext context, String message,
          {Function onConfirmed}) =>
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(size5),
                ),
                contentPadding: EdgeInsets.zero,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(size15),
                      child: Column(
                        children: <Widget>[
                          Text(
                            StringRes.NOTIFY,
                            style: textStyleSemiBold(size: 18),
                          ),
                          SizedBox(
                            height: size10,
                          ),
                          Text(
                            message,
                            style: textStyleRegular(size: 16),
                          )
                        ],
                      ),
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
                              StringRes.CANCEL,
                              style: textStyleButton(),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ButtonWidget(
                            onTap: () {
                              onConfirmed();
                              Navigator.of(context).pop();
                            },
                            height: size40,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(size5)),
                            backgroundColor: PRIMARY,
                            child: Text(
                              StringRes.OK,
                              style: textStyleButton(),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ));

  void hideKeyBoard(BuildContext context) =>
      FocusScope.of(context).requestFocus(new FocusNode());

  @override
  Widget build(BuildContext context) {
    if (appBloc == null) {
      appBloc = BlocProvider.of<AppBloc>(context);
    }
    if (pageBloc == null) {
      pageBloc = BlocProvider.of<T>(context);
    }
    listenData(context);
    UIHelper().init(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: PRIMARY,
      resizeToAvoidBottomPadding: resizeAvoidPadding,
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              !showFullScreen
                  ? Container(
                      height: UIHelper.paddingTop,
                      color: PRIMARY,
                    )
                  : SizedBox(),
              buildAppBar(context) ?? SizedBox(),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => hideKeyBoard(context),
                  child: SizedBox(
                    width: UIHelper.screenWidth,
                    child: buildMainContainer(context),
                  ),
                ),
              ),
              !showFullScreen
                  ? SizedBox(height: UIHelper.paddingBottom)
                  : SizedBox()
            ],
          ),
          StreamBuilder<bool>(
            stream: pageBloc.loadingStream,
            builder: (c, snap) {
              bool isLoading = snap.hasData && snap.data;
              return LoadingWidget(
                show: isLoading,
              );
            },
          )
        ],
      ),
    );
  }
}
