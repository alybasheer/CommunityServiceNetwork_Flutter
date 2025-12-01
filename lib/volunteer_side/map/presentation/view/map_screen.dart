import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fyp_source_code/volunteer_side/map/presentation/controller/map_controller.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  MapScreen({super.key});

  final MapCntrl controller = Get.put(MapCntrl());
  final flutterMapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final latlng = controller.currentLatLng.value;

        if (latlng != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            flutterMapController.move(latlng, 20.0);
          });
        }

        return FlutterMap(
          mapController: flutterMapController,
          options: MapOptions(
            initialCenter: latlng ?? LatLng(0, 0),
            initialZoom: 17.0,
            minZoom: 1,
            maxZoom: 30,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            ),
            if (latlng != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: latlng,
                    width: 60,
                    height: 60,
                    child: const Icon(
                      Icons.location_history,
                      color: Colors.blue,
                      size: 40,
                    ),
                  ),
                ],
              ),
          ],
        );
      }),
    );
  }
}
