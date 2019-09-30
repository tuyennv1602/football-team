import 'package:flutter/material.dart';
import 'package:myfootball/models/user_request.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/stringres.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app-bar-button.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:myfootball/ui/widgets/border-background.dart';
import 'package:myfootball/ui/widgets/bottom-sheet-widget.dart';
import 'package:myfootball/ui/widgets/button-widget.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/image-widget.dart';
import 'package:myfootball/ui/widgets/input_widget.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/utils/constants.dart';
import 'package:myfootball/utils/ui-helper.dart';
import 'package:myfootball/viewmodels/user_request_model.dart';
import 'package:provider/provider.dart';

class UserRequestPage extends StatelessWidget {
  String _content;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _showChooseAction(BuildContext context, UserRequestModel model,
          int index, UserRequest userRequest) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: ['Tuỳ chọn', 'Sửa đăng ký', 'Huỷ đăng ký', 'Huỷ'],
          onClickOption: (position) async {
            if (position == 1) {
              _showEditForm(_scaffoldKey.currentContext, userRequest, () {
                _handleUpdateRequest(
                    model, index, userRequest.idRequest, userRequest.idName);
              });
            } else if (position == 2) {
              UIHelper.showConfirmDialog('Bạn có chắc chắn muốn xoá yêu cầu?',
                  onConfirmed: () => _handleCancelRequest(
                      model, index, userRequest.idRequest));
            }
          },
        ),
      );

  void _handleCancelRequest(
      UserRequestModel model, int index, int requestId) async {
    UIHelper.showProgressDialog;
    var resp = await model.cancelRequest(index, requestId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      UIHelper.showSimpleDialog('Đã huỷ yêu cầu');
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  void _handleUpdateRequest(
      UserRequestModel model, int index, int requestId, int teamId) async {
    UIHelper.showProgressDialog;
    var resp = await model.updateRequest(index, requestId, teamId, _content);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      UIHelper.showSimpleDialog('Đã cập nhật yêu cầu!');
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  void _showEditForm(
          BuildContext context, UserRequest userRequest, Function onSubmit) =>
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UIHelper.size5),
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: UIHelper.screenWidth * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(UIHelper.size10),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Chỉnh sửa yêu cầu',
                        style: textStyleRegular(size: 16),
                        textAlign: TextAlign.center,
                      ),
                      Form(
                        key: _formKey,
                        child: InputWidget(
                          validator: (value) {
                            if (value.isEmpty) return 'Vui lòng nhập nội dung';
                            return null;
                          },
                          initValue: userRequest.content,
                          onSaved: (value) => _content = value,
                          maxLines: 4,
                          inputType: TextInputType.text,
                          inputAction: TextInputAction.done,
                          labelText: 'Nhập nội dung',
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
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(UIHelper.size5)),
                        backgroundColor: Colors.grey,
                        height: UIHelper.size40,
                        child: Text(
                          StringRes.CANCEL,
                          style: textStyleRegular(size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ButtonWidget(
                        onTap: () async {
                          if (validateAndSave()) {
                            Navigator.of(context).pop();
                            onSubmit();
                          }
                        },
                        height: UIHelper.size40,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(UIHelper.size5)),
                        backgroundColor: PRIMARY,
                        child: Text(
                          'Cập nhật',
                          style: textStyleRegular(size: 16, color: Colors.white),
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

  Widget _buildItemRequest(BuildContext context, UserRequestModel model,
      int index, UserRequest request) {
    Color _status;
    switch (request.status) {
      case Constants.REQUEST_REJECTED:
      case Constants.REQUEST_CANCEL:
        _status = Colors.red;
        break;
      case Constants.REQUEST_WAITING:
        _status = Colors.grey;
        break;
      default:
        _status = Colors.green;
    }
    return InkWell(
      onTap: () => _showChooseAction(context, model, index, request),
      child: Padding(
        padding: EdgeInsets.all(UIHelper.size10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ImageWidget(
                source: request.teamLogo, placeHolder: Images.DEFAULT_LOGO),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: UIHelper.size10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Gửi tới: ${request.teamName}',
                      style: textStyleRegularTitle(),
                    ),
                    Text(
                      'Nội dung: ${request.content}',
                      style: textStyleRegularBody(),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Ngày tạo: ${request.getCreateDate}',
                            style: textStyleItalic(color: Colors.grey),
                          ),
                        ),
                        Text(
                          request.getStatus,
                          style: textStyleRegular(color: _status),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Tất cả yêu cầu',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<UserRequestModel>(
                onModelReady: (model) => model.getAllRequest(),
                model: UserRequestModel(api: Provider.of(context)),
                builder: (context, model, child) {
                  if (model.busy) return LoadingWidget();
                  if (model.userRequests == null ||
                      model.userRequests.length == 0)
                    return EmptyWidget(message: 'Chưa có yêu cầu nào');
                  return ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (c, index) => _buildItemRequest(
                          context, model, index, model.userRequests[index]),
                      separatorBuilder: (c, index) => LineWidget(),
                      itemCount: model.userRequests.length);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
