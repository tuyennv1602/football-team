import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myfootball/model/ground.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/app_bar_widget.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/border_item.dart';
import 'package:myfootball/view/widget/input_search.dart';
import 'package:myfootball/router/paths.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/search_ground_vm.dart';
import 'package:provider/provider.dart';

enum BOOKING_TYPE { NORMAL, FIXED }

class SearchGroundPage extends StatefulWidget {
  final BOOKING_TYPE type;

  SearchGroundPage({Key key, @required this.type}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SearchGroundState();
  }
}

class _SearchGroundState extends State<SearchGroundPage> {
  static final CameraPosition _kPlaceInit = CameraPosition(
    target: LatLng(21.026099, 105.833273),
    zoom: 10,
  );

  final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor _groundMarker;

  _buildItemGround(BuildContext context, int index, Ground ground) =>
      BorderItem(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        onTap: () {
          if (widget.type == BOOKING_TYPE.NORMAL) {
            Navigation.instance.navigateTo(BOOKING, arguments: ground);
          } else {
            Navigation.instance.navigateTo(BOOKING_FIXED, arguments: ground);
          }
        },
        child: Hero(
          tag: ground.tag,
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(UIHelper.padding),
                child: SizedBox.expand(
                  child: FadeInImage.assetNetwork(
                    placeholder: Images.DEFAULT_GROUND,
                    image: ground.avatar,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: UIHelper.screenWidth * 0.5,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(UIHelper.size10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: BLACK_GRADIENT,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(UIHelper.size15),
                      bottomRight: Radius.circular(UIHelper.size15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        ground.name,
                        maxLines: 1,
                        style: textStyleMediumTitle(color: Colors.white),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: UIHelper.size5),
                        child: Text(
                          ground.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textStyleRegularBody(color: Colors.white),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              ground.getDistance,
                              style: textStyleRegularBody(color: Colors.white),
                            ),
                          ),
                          RatingBarIndicator(
                            rating: ground.rating,
                            itemCount: 5,
                            itemPadding:
                                EdgeInsets.only(right: UIHelper.size(2)),
                            itemSize: UIHelper.size20,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(
                size: Platform.isAndroid
                    ? Size(UIHelper.size50, UIHelper.size50)
                    : Size(UIHelper.size25, UIHelper.size25),
                devicePixelRatio: 2),
            Images.MARKER)
        .then((value) {
      _groundMarker = value;
    });
  }

  Future<void> _updateMyLocation(SearchGroundViewModel model) async {
    await model.getMyLocation();
    _animateToPosition(model.myPosition);
    await model.getGroundsByLocation();
    if (model.currentGround != null) {
      _animateToPosition(
          LatLng(model.currentGround.lat, model.currentGround.lng));
    }
  }

  Future<void> _animateToPosition(LatLng target) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 13),
      ),
    );
  }

  _buildItemSearchGround(Ground ground) => InkWell(
        onTap: () =>
            Navigation.instance.navigateTo(GROUND_DETAIL, arguments: ground.id),
        borderRadius: BorderRadius.circular(UIHelper.size5),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(UIHelper.size5)),
          padding: EdgeInsets.all(UIHelper.size10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      ground.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textStyleRegular(size: 16),
                    ),
                    Text(
                      ground.address,
                      maxLines: 1,
                      style: textStyleRegularBody(color: Colors.grey),
                    )
                  ],
                ),
              ),
              Image.asset(
                Images.NEXT,
                width: UIHelper.size10,
                height: UIHelper.size10,
                color: LINE_COLOR,
              )
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
          AppBarWidget(
            centerContent: Text(
              'Tìm kiếm sân bóng',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButton(
              imageName: Images.BACK,
              onTap: () => Navigation.instance.goBack(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<SearchGroundViewModel>(
                model: SearchGroundViewModel(api: Provider.of(context)),
                builder: (c, model, child) => Stack(
                  children: <Widget>[
                    GoogleMap(
                      myLocationButtonEnabled: false,
                      myLocationEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: _kPlaceInit,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                        _updateMyLocation(model);
                      },
                      markers: model.grounds
                          .map(
                            (ground) => Marker(
                              markerId: MarkerId(
                                ground.id.toString(),
                              ),
                              alpha:
                                  model.currentGround.id == ground.id ? 1 : 0.5,
                              position: LatLng(ground.lat, ground.lng),
                              icon: _groundMarker,
                            ),
                          )
                          .toSet(),
                    ),
                    InputSearch(
                      hintText: 'Nhập tên sân bóng',
                      isLoading: model.isSearching,
                      keyword: model.key,
                      onChangedText: (text) => model.searchGroundByKey(text),
                    ),
                    model.searchResults.length > 0
                        ? Positioned(
                            top: UIHelper.size(69),
                            left: 0,
                            right: 0,
                            bottom: UIHelper.size(200) + UIHelper.paddingBottom,
                            child: ListView.separated(
                              padding: EdgeInsets.symmetric(
                                  horizontal: UIHelper.padding),
                              itemBuilder: (c, index) => _buildItemSearchGround(
                                model.searchResults[index],
                              ),
                              separatorBuilder: (c, index) => SizedBox(
                                height: UIHelper.size5,
                                width: UIHelper.screenWidth,
                              ),
                              itemCount: model.searchResults.length,
                            ),
                          )
                        : SizedBox(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: UIHelper.size(180),
                        margin: EdgeInsets.only(
                            bottom: UIHelper.paddingBottom + UIHelper.size10),
                        child: model.grounds.length == 0
                            ? SizedBox()
                            : Swiper(
                                itemBuilder: (BuildContext context, int index) {
                                  var _ground = model.grounds[index];
                                  return _buildItemGround(
                                      context, index, _ground);
                                },
                                onIndexChanged: (index) {
                                  var _ground = model.grounds[index];
                                  _animateToPosition(
                                      LatLng(_ground.lat, _ground.lng));
                                  model.changeCurrentGround(_ground);
                                },
                                itemCount: model.grounds.length,
                                scale: 0.8,
                                viewportFraction: 0.7,
                                loop: true,
                              ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () => _updateMyLocation(model),
                        child: Padding(
                          padding: EdgeInsets.all(UIHelper.size5),
                          child: Image.asset(
                            Images.MY_LOCATION,
                            width: UIHelper.size(60),
                            height: UIHelper.size(60),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
