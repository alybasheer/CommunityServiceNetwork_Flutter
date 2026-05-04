import 'package:flutter/material.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:fyp_source_code/view/volunteer_side/home/presentation/view/widgets/req_card.dart';
import 'package:fyp_source_code/view/request_side/create_help_request/data/model/help_request.dart';

Widget requestsListSection(
  List<HelpRequest> requests, {
  required void Function(HelpRequest) onAccept,
  Set<String> acceptingIds = const {},
}) {
  if (requests.isEmpty) {
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }

  return SliverList(
    delegate: SliverChildBuilderDelegate((context, index) {
      final request = requests[index];
      final image = _resolveImage(request.image);

      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.m,
          vertical: AppSize.m,
        ),
        child: requestCard(
          index,
          requestImage: image,
          title: request.displayTitle,
          description: request.description ?? 'No description provided.',
          location: request.displayLocation,
          isAccepting: acceptingIds.contains(request.sId),
          onAccept: () => onAccept(request),
        ),
      );
    }, childCount: requests.length),
  );
}

ImageProvider _resolveImage(String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return const AssetImage('assets/logo.png');
  }
  if (imageUrl.startsWith('http')) {
    return NetworkImage(imageUrl);
  }
  return AssetImage(imageUrl);
}
