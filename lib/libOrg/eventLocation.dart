import 'dart:async';

import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:events/libOrg/blocs/application_bloc.dart';
import 'package:events/libOrg/models/place.dart';
import 'services/places_service.dart';

class EventLocation extends StatefulWidget {
  @override
  _EventLocationState createState() => _EventLocationState();
}

class _EventLocationState extends State<EventLocation> {
  GoogleMapController mapController;
  final placesService = PlaceService();
  List<Marker> location = [];

  _updateLocation(LatLng chosenLoc) {
    setState(() {
      location = [];
      location.add(Marker(
          markerId: MarkerId(chosenLoc.toString()),
          position: chosenLoc,
          draggable: true,
          onDragEnd: (dragEndPosition) {}));
    });
  }

  final TextEditingController searchController = TextEditingController();
  double inputSize = 17;

  Completer<GoogleMapController> _mapController = Completer();
  StreamSubscription locationSubscription;

  Future<void> _goToPlace(Place place) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera((CameraUpdate.newCameraPosition(CameraPosition(
        target:
            LatLng(place.geometry.location.lat, place.geometry.location.lng),
        zoom: 14))));
  }

  @override
  void initState() {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    locationSubscription =
        applicationBloc.selectedLocation.stream.listen((place) {
      if (place != null) _goToPlace(place);
    });
    super.initState();
  }

  @override
  void dispose() {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    applicationBloc.dispose();
    locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double textFieldWidth = width * 0.9;
    double textFieldHeight = height * 0.07;
    double mapHeight = height * 0.8;
    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Event Location",
          style: TextStyle(
              fontFamily: globals.montserrat,
              fontSize: 20,
              color: Colors.white),
        ),
      ),
      body: (applicationBloc.currentLocation == null)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                // Search field
                Container(
                  height: textFieldHeight,
                  width: textFieldWidth,
                  decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.only(bottom: 15),
                  child: Center(
                    child: ListTile(
                      title: TextField(
                        controller: searchController,
                        cursorColor: Colors.white,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: inputSize,
                            fontFamily: globals.montserrat,
                            fontWeight: globals.fontWeight),
                        decoration: InputDecoration(
                            hintText: "Search Location",
                            icon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.white38,
                                fontSize: inputSize,
                                fontFamily: globals.montserrat,
                                fontWeight: globals.fontWeight),
                            border: InputBorder.none,
                            focusColor: Colors.black,
                            fillColor: Colors.black),
                        onChanged: (value) =>
                            applicationBloc.searchPlaces(value),
                      ),
                    ),
                  ),
                ),
                // Map
                Expanded(
                  child: Stack(
                    children: [
                      // Map
                      Container(
                        height: mapHeight,
                        child: GoogleMap(
                            onMapCreated: (GoogleMapController controller) {
                              _mapController.complete(controller);
                            },
                            onTap: _updateLocation,
                            myLocationButtonEnabled: true,
                            myLocationEnabled: true,
                            //mapToolbarEnabled: true,
                            mapType: MapType.normal,
                            markers: Set.from(location),
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  applicationBloc.currentLocation.latitude,
                                  applicationBloc.currentLocation.longitude),
                              zoom: 14.0,
                            )),
                      ),
                      // Darken result area
                      if (applicationBloc.searchResults != null &&
                          applicationBloc.searchResults.length != 0)
                        Container(
                          height: mapHeight,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              backgroundBlendMode: BlendMode.darken),
                        ),
                      // List of results
                      if (applicationBloc.searchResults != null &&
                          applicationBloc.searchResults.length != 0)
                        Container(
                          height: mapHeight,
                          child: ListView.builder(
                            itemCount: applicationBloc.searchResults.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  applicationBloc
                                      .searchResults[index].description,
                                  style: TextStyle(
                                      fontFamily: globals.montserrat,
                                      fontWeight: globals.fontWeight,
                                      fontSize: inputSize,
                                      color: Colors.white),
                                ),
                                onTap: () async {
                                  applicationBloc.setSeletedLocation(
                                      applicationBloc
                                          .searchResults[index].placeId);
                                  Place ll = await placesService.getPlace(
                                      applicationBloc
                                          .searchResults[index].placeId);
                                  _updateLocation(LatLng(
                                      ll.geometry.location.lat,
                                      ll.geometry.location.lng));
                                },
                              );
                            },
                          ),
                        )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
