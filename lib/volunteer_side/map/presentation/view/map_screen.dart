import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(33.6844, 73.0479), // Any real location
          minZoom: 1,
          maxZoom: 18,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),

          CurrentLocationLayer(
            style: const LocationMarkerStyle(
              marker: DefaultLocationMarker(
                color: Colors.blue,
                child: Icon(Icons.my_location, color: Colors.white),
              ),
              markerAlignment: Alignment.center,
              markerSize: Size(100, 100),
              markerDirection: MarkerDirection.heading,
            ),
          ),
        ],
      ),
    );
  }
}
