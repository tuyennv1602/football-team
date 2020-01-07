import 'package:flutter/material.dart';
import 'package:myfootball/model/ground.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/page/team/search_ground_page.dart';
import 'package:myfootball/view/widget/customize_app_bar.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/border_item.dart';
import 'package:myfootball/view/widget/item_option.dart';
import 'package:myfootball/view/widget/line.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/router/paths.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/booking_manager_vm.dart';
import 'package:provider/provider.dart';

class BookingManagePage extends StatelessWidget {
  _buildItemGround(Ground ground) => BorderItem(
        padding: EdgeInsets.zero,
        onTap: () =>
            Navigation.instance.navigateTo(BOOKING, arguments: ground),
        child: Container(
          height: UIHelper.size(75),
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(UIHelper.padding),
                  bottomLeft: Radius.circular(UIHelper.padding),
                ),
                child: FadeInImage.assetNetwork(
                  image: ground.avatar,
                  placeholder: Images.DEFAULT_GROUND,
                  width: UIHelper.size(90),
                  height: double.infinity,
                  fit: BoxFit.cover,
                  fadeInDuration: Duration(milliseconds: 100),
                  fadeOutDuration: Duration(milliseconds: 100),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: UIHelper.padding, vertical: UIHelper.size10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        ground.name,
                        style: textStyleMedium(),
                      ),
                      Text(
                        ground.address,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textStyleRegularBody(),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          CustomizeAppBar(
            centerContent: Text(
              'Quản lý đặt sân',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButton(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ItemOption(
                    Images.TICKET,
                    'Vé đặt sân',
                    iconColor: Colors.redAccent,
                    onTap: () => Navigation.instance.navigateTo(TICKETS),
                  ),
                  ItemOption(
                    Images.BOOKING,
                    'Đặt sân bóng',
                    iconColor: Colors.green,
                    onTap: () =>
                        Navigation.instance.navigateTo(SEARCH_GROUND, arguments: BOOKING_TYPE.NORMAL),
                  ),
                  ItemOption(
                    Images.HISTORY,
                    'Sân cố định',
                    iconColor: Colors.blue,
                    onTap: () =>
                        Navigation.instance.navigateTo(FIXED_TIME),
                  ),
                  LineWidget(),
                  Padding(
                    padding: EdgeInsets.all(UIHelper.padding),
                    child: Text(
                      'Sân bóng gợi ý',
                      style: textStyleSemiBold(),
                    ),
                  ),
                  Expanded(
                    child: BaseWidget<BookingManagerViewModel>(
                      model: BookingManagerViewModel(
                        api: Provider.of(context),
                      ),
                      onModelReady: (model) => model.getSuggestGrounds(),
                      builder: (c, model, child) => model.busy
                          ? LoadingWidget()
                          : ListView.separated(
                              padding: EdgeInsets.symmetric(
                                  vertical: UIHelper.padding),
                              itemBuilder: (c, index) =>
                                  _buildItemGround(model.grounds[index]),
                              separatorBuilder: (c, index) =>
                                  UIHelper.verticalIndicator,
                              itemCount: model.grounds.length),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
