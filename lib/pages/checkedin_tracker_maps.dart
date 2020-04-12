import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sskcovid19/pages/checkedin_tracker.dart';

class TrackerMapsPage extends StatefulWidget {

  TrackerMapsPage({Key key}) : super(key: key);

  @override
  _TrackerMapsPageState createState() => _TrackerMapsPageState();
}

class _TrackerMapsPageState extends State<TrackerMapsPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm");

  //Google Maps
  GoogleMapController mapController;
  LatLng _center;

  //Set google maps marker;
  Map<String, Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    //Get value from previous page
    CheckedInHistory history = ModalRoute.of(context).settings.arguments;

    //Set Google Maps Center
    _center = new LatLng(history.latitude, history.longitude);

    //Set Google Maps Marker
    final marker = new Marker(
      markerId: MarkerId('Hello'),
      position: LatLng(history.latitude, history.longitude),
      infoWindow: InfoWindow(
        title: history.route+", "+history.subDistrict+", "+history.district+", "+history.province+", "+history.postcode,
        snippet: history.date,
      ),
    );

    _markers["0"] = marker;

    return Scaffold(
      appBar: AppBar(
        title: Text('ตำแหน่งที่เคยเดินทาง'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 15.0,
        ),
        markers: _markers.values.toSet(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context);
        },
        label: Text('ย้อยกลับ'),
        icon: Icon(Icons.arrow_back),
      ),
    );
  }
}
