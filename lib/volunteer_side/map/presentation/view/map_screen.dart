import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fyp_source_code/help_requests/data/models/help_request_model.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:fyp_source_code/volunteer_side/map/presentation/controller/map_controller.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapCntrl controller;
  late final MapController flutterMapController;

  bool _hasCenteredInitially = false;
  bool _followUser = true;
  bool _programmaticMove = false;

  @override
  void initState() {
    super.initState();
    controller =
        Get.isRegistered<MapCntrl>() ? Get.find<MapCntrl>() : Get.put(MapCntrl());
    flutterMapController = MapController();

    ever<LatLng?>(controller.currentLatLng, (latLng) {
      if (!mounted || latLng == null) {
        return;
      }

      if (!_hasCenteredInitially || _followUser) {
        _programmaticMove = true;
        flutterMapController.move(latLng, _hasCenteredInitially ? flutterMapController.camera.zoom : 15.0);
        _hasCenteredInitially = true;
      }
    });
  }

  void _recenter() {
    final latlng = controller.currentLatLng.value;
    if (latlng == null) {
      return;
    }

    setState(() {
      _followUser = true;
      _programmaticMove = true;
    });
    flutterMapController.move(latlng, flutterMapController.camera.zoom.clamp(13.0, 17.0));
  }

  void _handlePositionChanged(MapCamera camera, bool hasGesture) {
    if (_programmaticMove) {
      _programmaticMove = false;
      return;
    }

    if (hasGesture && _followUser) {
      setState(() {
        _followUser = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        foregroundColor: AppColors.darkGray,
        elevation: 0,
        title: Obx(
          () => Text(
            controller.isVolunteer || controller.isAdmin
                ? 'Live Request Map'
                : 'My Request Map',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => controller.refreshLiveRequests(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _recenter,
        backgroundColor: AppColors.safetyBlue,
        foregroundColor: AppColors.pureWhite,
        child: Icon(_followUser ? Icons.gps_fixed : Icons.my_location),
      ),
      body: Obx(() {
        final latlng = controller.currentLatLng.value;

        if (latlng == null) {
          if (controller.errorMessage.value.isNotEmpty) {
            return _MapMessage(message: controller.errorMessage.value);
          }
          return const Center(child: CircularProgressIndicator());
        }

        final markers = <Marker>[
          Marker(
            point: latlng,
            width: 64,
            height: 64,
            child: const _CurrentLocationMarker(),
          ),
          ...controller.liveRequests
              .where(
                (request) =>
                    request.latitude != null && request.longitude != null,
              )
              .map(
                (request) => Marker(
                  point: LatLng(request.latitude!, request.longitude!),
                  width: 72,
                  height: 72,
                  child: GestureDetector(
                    onTap: () => _showRequestDetails(context, request),
                    child: _HelpRequestMarker(request: request),
                  ),
                ),
              ),
        ];

        return Stack(
          children: [
            FlutterMap(
              mapController: flutterMapController,
              options: MapOptions(
                initialCenter: latlng,
                initialZoom: 15.0,
                minZoom: 3,
                maxZoom: 18,
                onPositionChanged: _handlePositionChanged,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(markers: markers),
              ],
            ),
            Positioned(
              top: AppSize.mH,
              left: AppSize.m,
              right: AppSize.m,
              child: _MapLegend(
                controller: controller,
                followUser: _followUser,
              ),
            ),
            if (controller.errorMessage.value.isNotEmpty)
              Positioned(
                left: AppSize.m,
                right: AppSize.m,
                bottom: AppSize.mH,
                child: _ErrorBanner(message: controller.errorMessage.value),
              ),
          ],
        );
      }),
    );
  }

  void _showRequestDetails(BuildContext context, HelpRequestModel request) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.pureWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(AppSize.m),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                request.description ?? 'Help request',
                style: AppTextStyling.title_18M.copyWith(color: AppColors.black),
              ),
              AppSize.sHeight,
              Wrap(
                spacing: AppSize.s,
                runSpacing: AppSize.sH,
                children: [
                  _SheetChip(
                    label: request.isSOS ? 'SOS' : (request.urgency ?? 'normal'),
                    color: request.isSOS
                        ? AppColors.emergencyRed
                        : _urgencyColor(request.urgency),
                  ),
                  _SheetChip(
                    label: (request.status ?? 'open').replaceAll('_', ' '),
                    color: _statusColor(request.status),
                  ),
                  _SheetChip(
                    label: (request.category ?? 'other').replaceAll('_', ' '),
                    color: AppColors.safetyBlue,
                  ),
                ],
              ),
              AppSize.mHeight,
              Text(
                request.locationLabel?.trim().isNotEmpty == true
                    ? request.locationLabel!
                    : '${request.latitude?.toStringAsFixed(4)}, ${request.longitude?.toStringAsFixed(4)}',
                style: AppTextStyling.body_14M.copyWith(
                  color: AppColors.mediumGray,
                ),
              ),
              AppSize.sHeight,
              Text(
                _timeAgo(request.createdAt),
                style: AppTextStyling.body_12S.copyWith(
                  color: AppColors.mediumGray,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CurrentLocationMarker extends StatelessWidget {
  const _CurrentLocationMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.safetyBlue,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.pureWhite, width: 3),
      ),
      child: const Icon(
        Icons.my_location,
        color: AppColors.pureWhite,
        size: 28,
      ),
    );
  }
}

class _HelpRequestMarker extends StatelessWidget {
  const _HelpRequestMarker({required this.request});

  final HelpRequestModel request;

  @override
  Widget build(BuildContext context) {
    final color = request.isSOS
        ? AppColors.emergencyRed
        : _urgencyColor(request.urgency);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(AppSize.xs),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.pureWhite, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            request.isSOS ? Icons.sos : Icons.campaign_rounded,
            color: AppColors.pureWhite,
            size: 22,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: AppSize.xsH),
          padding: EdgeInsets.symmetric(horizontal: AppSize.xs, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.pureWhite,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            request.isSOS ? 'SOS' : (request.urgency ?? 'open'),
            style: AppTextStyling.body_12S.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

class _MapLegend extends StatelessWidget {
  const _MapLegend({
    required this.controller,
    required this.followUser,
  });

  final MapCntrl controller;
  final bool followUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.m),
      decoration: BoxDecoration(
        color: AppColors.pureWhite.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.isVolunteer || controller.isAdmin
                ? 'Nearby live requests'
                : 'Your submitted requests',
            style: AppTextStyling.title_16M.copyWith(color: AppColors.black),
          ),
          AppSize.xsHeight,
          Text(
            followUser
                ? 'Following your live location.'
                : 'Map unlocked. Use the locator button to recenter.',
            style: AppTextStyling.body_12S.copyWith(
              color: AppColors.mediumGray,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapMessage extends StatelessWidget {
  const _MapMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSize.l),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyling.body_14M.copyWith(color: AppColors.black),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.m),
      decoration: BoxDecoration(
        color: AppColors.emergencyRed.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: AppTextStyling.body_12S.copyWith(color: AppColors.pureWhite),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _SheetChip extends StatelessWidget {
  const _SheetChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSize.s, vertical: AppSize.xsH),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyling.body_12S.copyWith(color: color),
      ),
    );
  }
}

Color _urgencyColor(String? urgency) {
  switch (urgency) {
    case 'critical':
      return AppColors.emergencyRed;
    case 'high':
      return AppColors.amberOrange;
    case 'medium':
      return AppColors.safetyBlue;
    default:
      return AppColors.reliefGreen;
  }
}

Color _statusColor(String? status) {
  switch (status) {
    case 'in_progress':
      return AppColors.safetyBlue;
    case 'resolved':
      return AppColors.reliefGreen;
    case 'cancelled':
      return AppColors.mediumGray;
    default:
      return AppColors.amberOrange;
  }
}

String _timeAgo(String? timestamp) {
  if (timestamp == null || timestamp.isEmpty) {
    return 'Just now';
  }
  final dateTime = DateTime.tryParse(timestamp)?.toLocal();
  if (dateTime == null) {
    return 'Just now';
  }
  final difference = DateTime.now().difference(dateTime);
  if (difference.inMinutes < 1) {
    return 'Just now';
  }
  if (difference.inHours < 1) {
    return '${difference.inMinutes} min ago';
  }
  if (difference.inDays < 1) {
    return '${difference.inHours} hr ago';
  }
  return '${difference.inDays} day ago';
}
