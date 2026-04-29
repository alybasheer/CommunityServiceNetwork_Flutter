import 'package:flutter/material.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:fyp_source_code/volunteer_side/home/presentation/view/widgets/req_card.dart';

Widget requestsListSection() {
  return SliverList(
    delegate: SliverChildBuilderDelegate(
      (context, index) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.m,
          vertical: AppSize.m,
        ),
        child: requestCard(
          index,
          requestImage: const AssetImage('assets/logo.png'),
          title: 'Emergency Request #${index + 1}',
          description:
              'Stuck near the riverbank, need immediate assistance and transport.',
          location: 'Downtown, Lahore',
        ),
      ),
      childCount: 8,
    ),
  );
}
