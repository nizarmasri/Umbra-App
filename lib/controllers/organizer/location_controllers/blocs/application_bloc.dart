import 'dart:async';

import 'package:events/controllers/organizer/location_controllers/models/place.dart';
import 'package:events/controllers/organizer/location_controllers/models/place_search.dart';
import 'package:events/controllers/organizer/location_controllers/services/geolocator_service.dart';
import 'package:events/controllers/organizer/location_controllers/services/places_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class ApplicationBloc with ChangeNotifier {
  final geoLocatorService = GeolocatorService();
  final placesService = PlaceService();

  Position currentLocation;
  List<PlaceSearch> searchResults;
  StreamController<Place> selectedLocation = StreamController<Place>();

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

  setSeletedLocation(String placeId) async {
    selectedLocation.add((await placesService.getPlace(placeId)));
    searchResults = null;
    notifyListeners();
  }

  @override
  void dispose() {
    selectedLocation.close();
    super.dispose();
  }
}
