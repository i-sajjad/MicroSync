// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapPage extends StatefulWidget {
  static const String id = 'map_page';
  GoogleMapPage({Key? key}) : super(key: key);

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  static const CameraPosition _atdPosition =
      CameraPosition(target: LatLng(34.1688, 73.2215), zoom: 14.4746);
  final Completer<GoogleMapController> _controller = Completer();
  final List<Marker> _markers = <Marker>[
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(34.1688, 73.2215),
      infoWindow: InfoWindow(title: 'Initial Location'),
    ),
  ];

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print('error' + error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _atdPosition,
        markers: Set<Marker>.of(_markers),
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          getUserCurrentLocation().then(
            (value) async {
              print('my current locaton');
              print(
                  value.latitude.toString() + " " + value.longitude.toString());

              _markers.add(
                Marker(
                  markerId: MarkerId('2'),
                  position: LatLng(value.latitude, value.longitude),
                  infoWindow: InfoWindow(title: 'Current User Location'),
                ),
              );

              CameraPosition cameraPosition = CameraPosition(
                  target: LatLng(value.latitude, value.longitude), zoom: 18);

              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(
                  CameraUpdate.newCameraPosition(cameraPosition));
              setState(() {});
            },
          );
        },
        label: const Text(
          'Get User Location',
          style: TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
        icon: const Icon(Icons.location_on_outlined),
      ),
    );
  }
}