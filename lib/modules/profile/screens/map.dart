
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  CameraPosition? _initialPosition;
  Circle? _userLocationCircle;

  @override
  void initState() {
    super.initState();
    _determinePosition().then((position) {
      setState(() {
        LatLng userLocation = LatLng(position.latitude, position.longitude);
        _initialPosition = CameraPosition(
          target: userLocation,
          zoom: 14.4746,
        );
        _userLocationCircle = Circle(
          circleId: const CircleId('userLocation'),
          center: userLocation,
          radius: 50,
          fillColor: Colors.blue.withOpacity(0.5),
          strokeColor: Colors.blue,
          strokeWidth: 1,
        );
      });
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Sevicios de localización denegados.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permisos de localización denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Los permisos de localización están permanentemente denegados.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _goToMyLocation() async {
    final GoogleMapController controller = await _controller.future;
    Position position = await _determinePosition();
    LatLng userLocation = LatLng(position.latitude, position.longitude);
    CameraPosition myLocation = CameraPosition(
      target: userLocation,
      zoom: 14.4746,
    );

    setState(() {
      _userLocationCircle = Circle(
        circleId: const CircleId('userLocation'),
        center: userLocation,
        radius: 50,
        fillColor: Colors.blue.withOpacity(0.5),
        strokeColor: Colors.blue,
        strokeWidth: 1,
      );
    });

    await controller.animateCamera(CameraUpdate.newCameraPosition(myLocation));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _initialPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initialPosition!,
              myLocationButtonEnabled: true,
              circles:
                  _userLocationCircle != null ? {_userLocationCircle!} : {},
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: _goToMyLocation,
            label: const Text('Mi localización'),
            icon: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }
}
