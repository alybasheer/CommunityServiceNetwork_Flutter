import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/volunteer_side/map/data/map_user_model.dart';
import 'package:latlong2/latlong.dart';

MarkerLayer buildMarkers(LatLng? currentLocation, List<MapUserModel> users) {
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
    ],
  );
}

Marker _marker({
  required LatLng point,
  required IconData icon,
  required Color color,
}) {
  return Marker(
    point: point,
    width: 50,
    height: 56,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
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
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        Container(width: 3, height: 6, color: color),
      ],
    ),
  );
}
