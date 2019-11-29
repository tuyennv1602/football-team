import 'dart:core';

import 'package:flutter/material.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/user.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/choose_transaction_type.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/input_price_widget.dart';
import 'package:myfootball/ui/widgets/input_text_widget.dart';
import 'package:myfootball/ui/widgets/select_date.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/string_util.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/finance_viewmodel.dart';
import 'package:provider/provider.dart';

class FinancePage extends StatelessWidget {
  final _formTransactionKey = GlobalKey<FormState>();
  final _formNotifyKey = GlobalKey<FormState>();

  String _transaction;

  bool validateAndSaveNotification() {
    final form = _formNotifyKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget _buildItemIntro(String image, String action) => Padding(
        padding: EdgeInsets.symmetric(
            horizontal: UIHelper.size15, vertical: UIHelper.size5),
        child: Row(
          children: <Widget>[
            Container(
              height: UIHelper.size30,
              width: UIHelper.size30,
              padding: EdgeInsets.all(UIHelper.size5),
              decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(UIHelper.size15)),
              child: Image.asset(
                image,
                color: Colors.white,
              ),
            ),
            UIHelper.horizontalSpaceMedium,
            Expanded(
              child: Text(
                '$action',
                style: textStyleRegular(),
              ),
            )
          ],
        ),
      );

  Widget _buildIntroView() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: UIHelper.size15, vertical: UIHelper.size10),
            child: Text(
              'Hướng dẫn',
              style: textStyleSemiBold(),
            ),
          ),
          _buildItemIntro(
              Images.BUDGET, 'Xem danh sách thông báo đóng quỹ'),
          UIHelper.verticalSpaceSmall,
          _buildItemIntro(
              Images.FUND_NOTIFY, 'Tạo thông báo đóng quỹ tới thành viên'),
          UIHelper.verticalSpaceSmall,
          _buildItemIntro(Images.TRANSACTIONS, 'Thêm giao dịch thu/chi'),
        ],
      );

  _createFundNotification(BuildContext context, {Function onSubmit}) {
    var price;
    var expireDate;
    var title;
    return UIHelper.showCustomizeDialog(
      'create noti',
      icon: Images.FUND_NOTIFY,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Số tiền cần thu',
            style: textStyleRegularTitle(color: Colors.white),
          ),
          UIHelper.verticalSpaceSmall,
          InputPriceWidget(
              textStyle: textStyleSemiBold(size: 20, color: Colors.white),
              hint: '0đ',
              hintTextStyle: textStyleSemiBold(size: 20, color: Colors.white),
              onChangedText: (text) => price = text),
          UIHelper.verticalSpaceMedium,
          Text(
            'Chọn hạn thu quỹ',
            style: textStyleRegularTitle(color: Colors.white),
          ),
          UIHelper.verticalSpaceSmall,
          SelectDateWidget(
            textStyle: textStyleSemiBold(size: 20, color: Colors.white),
            onSelectedDate: (date) => expireDate = date,
          ),
          UIHelper.verticalSpaceMedium,
          Form(
            key: _formNotifyKey,
            child: InputTextWidget(
              validator: (value) {
                if (value.isEmpty) return 'Vui lòng nhập tiêu đề';
                return null;
              },
              onSaved: (value) => title = value,
              maxLines: 1,
              inputType: TextInputType.text,
              inputAction: TextInputAction.done,
              labelText: 'Tiêu đề',
              textStyle: textStyleInput(color: Colors.white),
              hintTextStyle: textStyleInput(color: Colors.white),
            ),
          ),
        ],
      ),
      onConfirmed: () {
        if (validateAndSaveNotification()) {
          NavigationService.instance.goBack();
          onSubmit(title, price, expireDate);
        }
      },
    );
  }

  _createTransaction(BuildContext context) => UIHelper.showCustomizeDialog(
        'create_transaction',
        icon: Images.EDIT_PROFILE,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Số tiền giao dịch',
              style: textStyleRegularTitle(color: Colors.white),
            ),
            UIHelper.verticalSpaceSmall,
            InputPriceWidget(
                textStyle: textStyleSemiBold(size: 20, color: Colors.white),
                hint: '0đ',
                hintTextStyle: textStyleSemiBold(size: 20, color: Colors.white),
                onChangedText: (text) {}),
            Padding(
              padding:
                  EdgeInsets.only(top: UIHelper.size5, bottom: UIHelper.size20),
              child: ChooseTransactionTypeWidget(onSelectedType: (type) {}),
            ),
            Form(
              key: _formTransactionKey,
              child: InputTextWidget(
                validator: (value) {
                  if (value.isEmpty) return 'Vui lòng nhập nội dung';
                  return null;
                },
                onSaved: (value) => _transaction = value,
                maxLines: 1,
                inputType: TextInputType.text,
                inputAction: TextInputAction.done,
                labelText: 'Nôi dung giao dịch',
                textStyle: textStyleInput(color: Colors.white),
                hintTextStyle: textStyleInput(color: Colors.white),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    var team = Provider.of<Team>(context);
    bool isManager = team.manager == Provider.of<User>(context).id;
    return Scaffold(
      backgroundColor: PRIMARY,
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: UIHelper.size(150) + UIHelper.paddingTop,
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(
                bottom: UIHelper.size30,
                left: UIHelper.size15,
                right: UIHelper.size15),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/wallet_bg.jpg'),
                    fit: BoxFit.cover)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Đã thu',
                      style: textStyleTitle(),
                    ),
                    Expanded(
                      child: Text(
                        StringUtil.formatCurrency(0),
                        style: textStyleTitle(),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                UIHelper.verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Đã chi',
                      style: textStyleTitle(),
                    ),
                    Expanded(
                      child: Text(
                        StringUtil.formatCurrency(0),
                        textAlign: TextAlign.right,
                        style: textStyleTitle(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          BaseWidget<FinanceViewModel>(
            model: FinanceViewModel(api: Provider.of(context)),
            builder: (c, model, child) => AppBarWidget(
              centerContent: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  AppBarButtonWidget(
                      imageName: Images.BUDGET,
                      onTap: () =>
                          NavigationService.instance.navigateTo(TEAM_FUND)),
                  isManager
                      ? AppBarButtonWidget(
                          imageName: Images.FUND_NOTIFY,
                          onTap: () => _createFundNotification(
                            context,
                            onSubmit: (title, price, expiredDate) =>
                                model.createFundNotify(
                                    team.id, title, price, expiredDate),
                          ),
                          padding: UIHelper.size(12),
                        )
                      : SizedBox(),
                  isManager
                      ? AppBarButtonWidget(
                          imageName: Images.TRANSACTIONS,
                          onTap: () => _createTransaction(context),
                        )
                      : SizedBox(),
                ],
              ),
              leftContent: AppBarButtonWidget(
                imageName: Images.BACK,
                onTap: () => NavigationService.instance.goBack(),
              ),
              backgroundColor: Colors.transparent,
              rightContent: SizedBox(),
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(top: UIHelper.size(130) + UIHelper.paddingTop),
            child: BorderBackground(
              child: BaseWidget<FinanceViewModel>(
                model: FinanceViewModel(
                  api: Provider.of(context),
                ),
                builder: (c, model, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    isManager ? _buildIntroView() : SizedBox(),
                    Expanded(
                      child: Center(
                        child: EmptyWidget(message: 'Chưa có giao dịch nào'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
