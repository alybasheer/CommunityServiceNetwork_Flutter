import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';

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
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Obx(() {
        final latlng = mapCntrl.currentLatLng.value;

        if (latlng != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            flutterMapController.move(latlng, 17.0);
          });
        }

        return Stack(children: [buildMap(latlng), getLocation()]);
      }),
    );
  }

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
    );
  }
}
