import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/volunteer_side/map/data/map_user_model.dart';
import 'package:latlong2/latlong.dart';

MarkerLayer buildMarkers(
  LatLng? currentLocation,
  List<MapUserModel> users, {
  LatLng? activeRequestLocation,
}) {
  return MarkerLayer(
    markers: [
      if (currentLocation != null)
        _marker(
          point: currentLocation,
          icon: Icons.my_location,
          color: AppColors.steelBlue,
        ),
      ...users.map(
        (user) => _marker(
          point: user.location,
          icon:
              user.isVolunteer
                  ? Icons.volunteer_activism
                  : Icons.person_pin_circle,
          color:
              user.isVolunteer ? AppColors.reliefGreen : AppColors.amberOrange,
        ),
      ),
      if (activeRequestLocation != null)
        _marker(
          point: activeRequestLocation,
          icon: Icons.place_rounded,
          color: AppColors.emergencyRed,
          size: 58,
        ),
    ],
  );
}

Marker _marker({
  required LatLng point,
  required IconData icon,
  required Color color,
  double size = 50,
}) {
  return Marker(
    point: point,
    width: size,
    height: size + 6,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size - 6,
          height: size - 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.35),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Icon(icon, color: Colors.white, size: size * 0.44),
        ),
        Container(width: 3, height: 6, color: color),
      ],
    ),
  );
}
