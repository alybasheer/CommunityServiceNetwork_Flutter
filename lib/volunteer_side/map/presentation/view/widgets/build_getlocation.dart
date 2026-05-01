import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:latlong2/latlong.dart';

Widget getLocation({
  required LatLng? currentLocation,
  required MapController mapController,
}) {
  return Positioned(
    bottom: AppSize.lH,
    right: AppSize.m,
    child: FloatingActionButton(
      onPressed: () {
        if (currentLocation != null) {
          mapController.move(currentLocation, 18.0);
        }
      },
      backgroundColor: AppColors.steelBlue,
      child: const Icon(Icons.my_location, color: Colors.white),
    ),
  );
}
