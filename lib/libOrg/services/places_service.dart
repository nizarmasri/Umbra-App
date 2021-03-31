import 'package:events/libOrg/models/place.dart';
import 'package:events/libOrg/models/place_search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PlaceService {
  final key = 'AIzaSyAoD2ihWV0wo2X2jHZ2iYzbkjQVuzciE-I';

  Future<List<PlaceSearch>> getAutoComplete(String search) async {
    var url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(cities)&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<Place> getPlace(String placeId) async {
    var url = 'https://maps.googleapis.com/maps/api/place/details/json?key=$key&place_id=$placeId';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['result'] as Map<String, dynamic>;
    return Place.fromJson(jsonResult);
  }
}