import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fyp_source_code/utilities/reuse_widgets/app_bar.dart';

import 'package:fyp_source_code/volunteer_side/map/presentation/controller/map_controller.dart';
import 'package:fyp_source_code/volunteer_side/map/presentation/view/widgets/build_getlocation.dart';
import 'package:fyp_source_code/volunteer_side/map/presentation/view/widgets/build_map.dart';
import 'package:get/get.dart';

class MapScreen extends StatelessWidget {
  MapScreen({super.key});

  final MapCntrl mapCntrl = Get.put(MapCntrl());
  final flutterMapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const WeHelpAppBar(
        title: 'Emergency Map',
        subtitle: 'Nearby volunteers and live position',
      ),
      body: Obx(() {
        final latlng = mapCntrl.currentLatLng.value;

        if (latlng != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            flutterMapController.move(latlng, 17.0);
          });
        }

        return Stack(
          children: [
            buildMap(
              latlng: latlng,
              users: mapCntrl.mapUsers,
              mapController: flutterMapController,
            ),
            getLocation(
              currentLocation: latlng,
              mapController: flutterMapController,
            ),
          ],
        );
      }),
    );
  }
}
