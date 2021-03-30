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

  @override
  Widget build(BuildContext context) {

    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Event Location",
          style: TextStyle(
            fontFamily: globals.montserrat,
            fontSize: 20,
            color: Colors.white
          ),
        ),
      ),
      body: (applicationBloc.currentLocation == null)
        ? Center(child: CircularProgressIndicator(),)
      : GoogleMap(
          //onMapCreated: _onMapCreated,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          //mapToolbarEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(applicationBloc.currentLocation.latitude, applicationBloc.currentLocation.longitude),
            zoom: 14.0,
          )),
    );
  }
}
