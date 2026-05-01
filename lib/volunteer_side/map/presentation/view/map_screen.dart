import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fyp_source_code/request_side/create_help_request/data/model/help_request.dart';
import 'package:fyp_source_code/routing/route_names.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:fyp_source_code/utilities/reuse_widgets/app_bar.dart';

import 'package:fyp_source_code/volunteer_side/map/presentation/controller/map_controller.dart';
import 'package:fyp_source_code/volunteer_side/map/presentation/view/widgets/build_getlocation.dart';
import 'package:fyp_source_code/volunteer_side/map/presentation/view/widgets/build_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapCntrl mapCntrl;
  final flutterMapController = MapController();
  String? _lastCameraTarget;

  @override
  void initState() {
    super.initState();
    mapCntrl =
        Get.isRegistered<MapCntrl>()
            ? Get.find<MapCntrl>()
            : Get.put(MapCntrl(), permanent: true);
    mapCntrl.setActiveRequestFromArguments(Get.arguments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: WeHelpAppBar(
        title: 'Emergency Map',
        subtitle: 'Nearby volunteers and live position',
        showBack: Get.currentRoute == RouteNames.map,
      ),
      body: Obx(() {
        final latlng = mapCntrl.currentLatLng.value;
        final activeRequest = mapCntrl.activeRequest.value;
        final activeRequestLocation = mapCntrl.activeRequestLatLng;
        final routePoints = mapCntrl.activeRoutePoints;

        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _focusMap(latlng, activeRequestLocation),
        );

        return Stack(
          children: [
            buildMap(
              latlng: latlng,
              activeRequestLocation: activeRequestLocation,
              routePoints: routePoints,
              users: mapCntrl.mapUsers,
              mapController: flutterMapController,
            ),
            getLocation(
              currentLocation: latlng,
              mapController: flutterMapController,
            ),
            if (activeRequest != null)
              _ActiveRequestPanel(
                request: activeRequest,
                distanceKm: mapCntrl.activeDistanceKm,
                isCompleting: mapCntrl.isCompleting.value,
                isCancelling: mapCntrl.isCancelling.value,
                onChat: mapCntrl.openActiveRequestChat,
                onDone: mapCntrl.completeActiveRequest,
                onCancel: mapCntrl.cancelActiveRequest,
              ),
          ],
        );
      }),
    );
  }

  void _focusMap(LatLng? currentLocation, LatLng? requestLocation) {
    if (currentLocation == null && requestLocation == null) {
      return;
    }

    final cameraKey =
        '${_cameraKey(currentLocation)}:${_cameraKey(requestLocation)}';
    if (_lastCameraTarget == cameraKey) {
      return;
    }
    _lastCameraTarget = cameraKey;

    try {
      if (currentLocation != null && requestLocation != null) {
        flutterMapController.fitCamera(
          CameraFit.coordinates(
            coordinates: [currentLocation, requestLocation],
            padding: const EdgeInsets.fromLTRB(48, 96, 48, 220),
            maxZoom: 17,
          ),
        );
        return;
      }

      flutterMapController.move(currentLocation ?? requestLocation!, 17.0);
    } catch (_) {
      _lastCameraTarget = null;
    }
  }

  String _cameraKey(LatLng? point) {
    if (point == null) {
      return 'none';
    }
    return '${point.latitude.toStringAsFixed(4)},${point.longitude.toStringAsFixed(4)}';
  }
}

class _ActiveRequestPanel extends StatelessWidget {
  final HelpRequest request;
  final double? distanceKm;
  final bool isCompleting;
  final bool isCancelling;
  final VoidCallback onChat;
  final VoidCallback onDone;
  final VoidCallback onCancel;

  const _ActiveRequestPanel({
    required this.request,
    required this.distanceKm,
    required this.isCompleting,
    required this.isCancelling,
    required this.onChat,
    required this.onDone,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isBusy = isCompleting || isCancelling;
    final distanceText =
        distanceKm == null ? null : '${distanceKm!.toStringAsFixed(2)} km away';

    return Positioned(
      left: AppSize.m,
      right: AppSize.m,
      bottom: AppSize.mH,
      child: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.all(AppSize.m),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.emergencyRed.withValues(
                      alpha: 0.12,
                    ),
                    child: const Icon(
                      Icons.route_rounded,
                      color: AppColors.emergencyRed,
                    ),
                  ),
                  SizedBox(width: AppSize.s),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.displayTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyling.title_16M.copyWith(
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: AppSize.xsH / 2),
                        Text(
                          distanceText ?? request.displayLocation,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyling.body_12S.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: isBusy ? null : onChat,
                    tooltip: 'Chat',
                    icon: const Icon(Icons.chat_bubble_outline_rounded),
                    color: AppColors.steelBlue,
                  ),
                ],
              ),
              SizedBox(height: AppSize.sH),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isBusy ? null : onCancel,
                      icon:
                          isCancelling
                              ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Icon(Icons.close_rounded),
                      label: Text(isCancelling ? 'Cancelling' : 'Cancel'),
                    ),
                  ),
                  SizedBox(width: AppSize.s),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isBusy ? null : onDone,
                      icon:
                          isCompleting
                              ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Icon(Icons.done_rounded),
                      label: Text(isCompleting ? 'Completing' : 'Done'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.reliefGreen,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
