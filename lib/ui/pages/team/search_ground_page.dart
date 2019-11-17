import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/search_widget.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/search_ground_viewmodel.dart';
import 'package:provider/provider.dart';

class SearchGroundPage extends StatefulWidget {
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
    UIHelper.showProgressDialog;
    await model.getGroundsByLocation();
    UIHelper.hideProgressDialog;
  }

  Future<void> _animateToPosition(LatLng target) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 13),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
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
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => NavigationService.instance().goBack(),
            ),
            rightContent: AppBarButtonWidget(
              imageName: Images.HISTORY,
              onTap: () => NavigationService.instance().navigateTo(TICKETS),
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
                                infoWindow: InfoWindow(
                                    title: ground.name,
                                    snippet: ground.address,
                                    onTap: () => NavigationService.instance()
                                        .navigateTo(BOOKING,
                                            arguments: ground)),
                                position: LatLng(ground.lat, ground.lng),
                                icon: _groundMarker),
                          )
                          .toSet(),
                    ),
                    SearchWidget(
//                        keyword: model.key,
                      hintText: 'Nhập tên sân bóng',
                      isLoading: false,
                      onChangedText: (text) {},
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
