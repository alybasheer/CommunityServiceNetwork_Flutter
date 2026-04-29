 import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:fyp_source_code/volunteer_side/map/presentation/controller/map_controller.dart';
import 'package:get/get.dart';
final MapCntrl mapCntrl = Get.put(MapCntrl());
  final flutterMapController = MapController();
Widget getLocation() {
    return Positioned(
      bottom: AppSize.lH,
      right: AppSize.m,
      child: FloatingActionButton(
        onPressed: () {
          if (mapCntrl.currentLatLng.value != null) {
            flutterMapController.move(mapCntrl.currentLatLng.value!,18.0);
          }
        },
        backgroundColor: AppColors.steelBlue,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }

