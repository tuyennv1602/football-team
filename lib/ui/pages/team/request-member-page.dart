import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/blocs/request-member-bloc.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/stringres.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/widgets/app-bar-button.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:myfootball/ui/widgets/button-widget.dart';
import 'package:myfootball/ui/widgets/divider.dart';
import 'package:myfootball/ui/widgets/input-widget.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/ui/widgets/search-widget.dart';
import 'package:myfootball/ui/widgets/team-avatar.dart';

// ignore: must_be_immutable
class RequestMemberPage extends BasePage<RequestMemberBloc> {
  final _formKey = GlobalKey<FormState>();

  @override
  AppBarWidget buildAppBar(BuildContext context) => AppBarWidget(
        rightContent: AppBarButtonWidget(
          imageName: Images.STACK,
          onTap: () => Navigator.of(context).pop(),
        ),
        leftContent: AppBarButtonWidget(
          imageName: Images.BACK,
          onTap: () => Navigator.of(context).pop(),
        ),
        centerContent: Text(
          'Tìm kiếm đội bóng',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title,
        ),
      );

  Widget _buildItemTeam(BuildContext context, Team team) => InkWell(
        onTap: () => showRequestForm(context, team),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TeamAvatarWidget(source: team.logo),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            team.name,
                            style: Theme.of(context)
                                .textTheme
                                .body2
                                .copyWith(color: AppColor.MAIN_BLACK),
                          ),
                        ),
                        FlutterRatingBarIndicator(
                          rating: 2.5,
                          itemCount: 5,
                          itemPadding: EdgeInsets.only(left: 2),
                          itemSize: 12,
                          emptyColor: Colors.amber.withAlpha(90),
                        )
                      ],
                    ),
                    Text(
                      team.bio,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Trình độ: Trung bình'),
                        Text('${team.countMember} thành viên')
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );

  void showRequestForm(BuildContext context, Team team) => showDialog(
      context: context,
      barrierDismissible: false,

      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Text(
                        team.name,
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(color: AppColor.MAIN_BLACK),
                      ),
                      Form(
                        key: _formKey,
                        child: InputWidget(
                          validator: (value) {
                            if (value.isEmpty)
                              return StringRes.REQUIRED_CONTENT;
                            return null;
                          },
                          maxLines: 5,
                          maxLength: 150,
                          inputType: TextInputType.text,
                          inputAction: TextInputAction.done,
                          labelText: StringRes.CONTENT,
                          onChangedText: (text) =>
                              pageBloc.changeContentFunc(text),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ButtonWidget(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5)),
                        backgroundColor: Colors.grey,
                        child: Text(
                          StringRes.CANCEL,
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ButtonWidget(
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            Navigator.of(context).pop();
                            pageBloc.submitRequestFunc(team.id);
                          }
                        },
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(5)),
                        backgroundColor: AppColor.GREEN,
                        child: Text(
                          StringRes.SEND_REQUEST,
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ));

  @override
  Widget buildMainContainer(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: SearchWidget(
                hintText: 'Nhập tên đội bóng',
                onChangedText: (text) {
                  pageBloc.searchTeamFunc(text);
                },
              ),
            ),
            ButtonWidget(
              width: 40,
              height: 40,
              margin: EdgeInsets.only(right: 10),
              child: Image.asset(
                Images.QR_SEARCH,
                width: 25,
                height: 25,
                color: Colors.grey,
              ),
              onTap: () {},
            )
          ],
        ),
        Expanded(
          child: StreamBuilder<List<Team>>(
            stream: pageBloc.getAllTeamsStream,
            builder: (c, snap) {
              if (snap.hasData) {
                return ListView.separated(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: snap.data.length,
                  separatorBuilder: (c, index) => DividerWidget(),
                  itemBuilder: (c, index) =>
                      _buildItemTeam(context, snap.data[index]),
                );
              }
              return SizedBox();
            },
          ),
        )
      ],
    );
  }

  @override
  void listenData(BuildContext context) {
    pageBloc.requestMemberStream.listen((resp) {
      if (!resp.isSuccess) {
        showSnackBar(resp.errorMessage);
      } else {
        showSnackBar(StringRes.SENT_REQUEST,
            backgroundColor: AppColor.MAIN_BLUE);
      }
    });
  }
}
