import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
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
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Obx(() {
        final latlng = controller.currentLatLng.value;

        if (latlng != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            flutterMapController.move(latlng, 17.0);
          });
        }

        return Stack(children: [_buildMap(latlng), _buildFAB()]);
      }),
    );
  }

  // ========== WIDGET SECTIONS ==========
  static PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.safetyBlue,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Emergency Map',
        style: AppTextStyling.title_18M.copyWith(
          color: AppColors.pureWhite,
          fontWeight: FontWeight.w700,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _buildMap(LatLng? latlng) {
    return FlutterMap(
      mapController: flutterMapController,
      options: MapOptions(
        initialCenter: latlng ?? LatLng(31.5204, 74.3587),
        initialZoom: 17.0,
        minZoom: 1,
        maxZoom: 19,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=ycfPj924kwGqFEb0ah2Z",
          userAgentPackageName: 'com.fyp.volunteer_emergency_network',
          subdomains: const ['a', 'b', 'c'],
          tileProvider: NetworkTileProvider(
            headers: {
              'User-Agent':
                  'FYP-WeHelp-VolunteerApp/1.0 (+https://github.com/alybasheer/frontendForWeHelp)',
            },
          ),
        ),
        if (latlng != null) _buildMarker(latlng),
      ],
    );
  }

  static Widget _buildMarker(LatLng location) {
    return MarkerLayer(
      markers: [
        Marker(
          point: location,
          width: 50,
          height: 56,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.steelBlue,
                      AppColors.steelBlue.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.steelBlue.withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ],
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  Icons.volunteer_activism,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              Container(width: 3, height: 6, color: AppColors.steelBlue),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFAB() {
    return Positioned(
      bottom: AppSize.lH,
      right: AppSize.m,
      child: FloatingActionButton(
        onPressed: () {
          if (controller.currentLatLng.value != null) {
            flutterMapController.move(controller.currentLatLng.value!, 17.0);
          }
        },
        backgroundColor: AppColors.steelBlue,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}
