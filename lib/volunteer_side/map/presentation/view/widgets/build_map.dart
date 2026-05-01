import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fyp_source_code/volunteer_side/map/data/map_user_model.dart';
import 'package:fyp_source_code/volunteer_side/map/presentation/view/widgets/build_marker.dart';
import 'package:latlong2/latlong.dart';

Widget buildMap({
  required LatLng? latlng,
  required List<MapUserModel> users,
  required MapController mapController,
}) {
  return FlutterMap(
    mapController: mapController,
    options: MapOptions(
      initialCenter: latlng ?? const LatLng(31.5204, 74.3587),
      initialZoom: 17.0,
      minZoom: 1,
      maxZoom: 19,
    ),
    children: [
      TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'com.fyp.volunteer_emergency_network',
        tileProvider: NetworkTileProvider(
          headers: {
            'User-Agent':
                'FYP-WeHelp-VolunteerApp/1.0 (+https://github.com/alybasheer/frontendForWeHelp)',
          },
        ),
      ),
      buildMarkers(latlng, users),
    ],
  );
}
