import 'package:events/libOrg/geolocator_service.dart';
import 'package:events/libOrg/place_search.dart';
import 'package:events/libOrg/places_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class ApplicationBloc with ChangeNotifier {
  final geoLocatorService = GeolocatorService();
  final placesService = PlaceService();

  Position currentLocation;
  List<PlaceSearch> searchResults;

  ApplicationBloc() {
    setCurrentLocation();
  }

  setCurrentLocation() async {
      currentLocation = await geoLocatorService.getCurrentLocation();
      notifyListeners();
  }

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutoComplete(searchTerm);
    notifyListeners();
  }
}