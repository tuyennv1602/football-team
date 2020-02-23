import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationServices {
  Future<Position> getCurrentLocation() async {
    try {
      return await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } on PlatformException catch (_) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler().requestPermissions([
        PermissionGroup.location,
        PermissionGroup.locationAlways,
        PermissionGroup.locationWhenInUse
      ]);
      if (permissions[PermissionGroup.location] == PermissionStatus.granted &&
          permissions[PermissionGroup.locationAlways] ==
              PermissionStatus.granted &&
          permissions[PermissionGroup.locationWhenInUse] ==
              PermissionStatus.granted) {
        return await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      }
      return Future.value(null);
    }
  }

  Future<double> getDistance2Points(LatLng origin, LatLng destination) async {
    double distanceInMeters = await Geolocator().distanceBetween(
        origin.latitude,
        origin.longitude,
        destination.latitude,
        destination.longitude);
    return distanceInMeters;
  }
}
