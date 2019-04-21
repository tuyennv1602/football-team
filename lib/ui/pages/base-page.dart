import 'package:flutter/material.dart';
import 'package:myfootball/blocs/app-bloc.dart';
import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';

abstract class BasePage<T extends BaseBloc> extends StatelessWidget {
  T pageBloc;

  AppBloc appBloc;

  BaseBloc createBloc();

  AppBarWidget buildAppBar(BuildContext context);

  Widget buildMainContainer(BuildContext context);

  Widget buildLoading(BuildContext context);

  bool showFullScreen();

  @override
  Widget build(BuildContext context) {
    appBloc = BlocProvider.of<AppBloc>(context);
    if (createBloc() != null) {
      pageBloc = BlocProvider.of<T>(context);
    }
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: Stack(
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
