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
import 'package:myfootball/ui/widgets/input-widget.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/ui/widgets/search-widget.dart';
import 'package:myfootball/ui/widgets/team-avatar.dart';

// ignore: must_be_immutable
class RequestMemberPage extends BasePage<RequestMemberBloc> {
  final _formKey = GlobalKey<FormState>();

  Widget _buildItemTeam(BuildContext context, Team team) => InkWell(
        onTap: () => showRequestForm(context, team),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: AppColor.GREY_BACKGROUND),
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
            contentPadding: EdgeInsets.all(10),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  team.name,
                  style: Theme.of(context).textTheme.title.copyWith(color: AppColor.MAIN_BLACK),
                ),
                Form(
                  key: _formKey,
                  child: InputWidget(
                    validator: (value) {
                      if (value.isEmpty) return StringRes.REQUIRED_CONTENT;
                      return null;
                    },
                    maxLines: 5,
                    maxLength: 150,
                    inputType: TextInputType.text,
                    inputAction: TextInputAction.done,
                    labelText: StringRes.CONTENT,
                    onChangedText: (text) => pageBloc.changeContentFunc(text),
                  ),
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
                        StringRes.CANCEL,
                        style: Theme.of(context).textTheme.body2,
                      ),
                    ),
                    ButtonWidget(
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          Navigator.of(context).pop();
                          pageBloc.submitRequestFunc(team.id);
                        }
                      },
                      borderRadius: BorderRadius.circular(5),
                      margin: EdgeInsets.only(top: 15),
                      width: 110,
                      height: 40,
                      backgroundColor: AppColor.GREEN,
                      child: Text(
                        StringRes.SEND_REQUEST,
                        style: Theme.of(context).textTheme.body2,
                      ),
                    )
                  ],
                )
              ],
            ),
          ));

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
          'Yêu cầu gia nhập đội bóng',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title,
        ),
      );

  @override
  Widget buildLoading(BuildContext context) => StreamBuilder<bool>(
        stream: pageBloc.loadingStream,
        builder: (c, snap) {
          bool isLoading = snap.hasData && snap.data;
          return LoadingWidget(
            show: isLoading,
          );
        },
      );

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
                  padding: EdgeInsets.all(10),
                  itemCount: snap.data.length,
                  separatorBuilder: (c, index) => Divider(
                    height: 10,
                    color: AppColor.WHITE,
                  ),
                  itemBuilder: (c, index) => _buildItemTeam(context, snap.data[index]),
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
        showSnackBar(StringRes.SENT_REQUEST, backgroundColor: AppColor.MAIN_BLUE);
      }
    });
  }
}
