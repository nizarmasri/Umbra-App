import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:events/libOrg/place_search.dart';

class PlaceService {
  final key = 'AIzaSyAoD2ihWV0wo2X2jHZ2iYzbkjQVuzciE-I';

  Future<List<PlaceSearch>> getAutoComplete(String search) async {
    var url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(cities)&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }
}