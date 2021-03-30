import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:events/libOrg/application_bloc.dart';

class EventLocation extends StatefulWidget {
  @override
  _EventLocationState createState() => _EventLocationState();
}

class _EventLocationState extends State<EventLocation> {
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

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
                            //suffixIcon: Icon(Icons.search, color: Colors.white,),
                            icon: Icon(Icons.search, color: Colors.white,),
                            hintStyle: TextStyle(
                                color: Colors.white38,
                                fontSize: inputSize,
                                fontFamily: globals.montserrat,
                                fontWeight: globals.fontWeight),
                            border: InputBorder.none,
                            focusColor: Colors.black,
                            fillColor: Colors.black),
                        onChanged: (value) => applicationBloc.searchPlaces(value),
                      ),
                    ),
                  ),
                ),
                // Map
                Stack(
                  children: [
                    // Map
                  Container(
                      height: mapHeight,
                      child: GoogleMap(
                          //onMapCreated: _onMapCreated,
                          onTap: _updateLocation,
                          myLocationButtonEnabled: true,
                          myLocationEnabled: true,
                          //mapToolbarEnabled: true,
                          mapType: MapType.normal,
                          markers: Set.from(location),
                          initialCameraPosition: CameraPosition(
                            target: LatLng(applicationBloc.currentLocation.latitude,
                                applicationBloc.currentLocation.longitude),
                            zoom: 14.0,
                          )),
                    ),
                    // Darken result area
                    if(applicationBloc.searchResults != null &&
                        applicationBloc.searchResults.length != 0)
                    Container(
                      height: mapHeight,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        backgroundBlendMode: BlendMode.darken
                      ),
                    ),
                    // List of results
                    if(applicationBloc.searchResults != null)
                      Container(
                        height: mapHeight,
                        child: ListView.builder(
                          itemCount: applicationBloc.searchResults.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                applicationBloc.searchResults[index].description,
                                style: TextStyle(
                                  fontFamily: globals.montserrat,
                                  fontWeight: globals.fontWeight,
                                  fontSize: inputSize,
                                  color: Colors.white
                                ),
                              )
                            );
                          },
                        ),
                      )
                  ],
                )
              ],
            ),
    );
  }
}
