import 'package:events/libOrg/geolocator_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class ApplicationBloc with ChangeNotifier {
  final geoLocatorService = GeolocatorService();

  Position currentLocation;

  ApplicationBloc() {
    setCurrentLocation();
  }

  setCurrentLocation() async {
      currentLocation = await geoLocatorService.getCurrentLocation();
      notifyListeners();
  }
}