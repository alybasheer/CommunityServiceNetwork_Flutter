import 'package:flutter/material.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:fyp_source_code/utilities/reuse_widgets/app_bar.dart';
import 'package:fyp_source_code/utilities/reuse_widgets/shimmer_loading.dart';
import 'package:fyp_source_code/volunteer_side/coordination/data/model/coordination_contact.dart';
import 'package:get/get.dart';

import '../controller/coordination_controller.dart';

class CoordinationScreen extends StatelessWidget {
  const CoordinationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CoordinationController());
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const WeHelpAppBar(
        title: 'Coordination',
        subtitle: 'Contacts and active support chats',
        showBack: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(AppSize.m),
              child: TextField(
                controller: controller.searchController,
                onChanged: controller.updateSearch,
                decoration: InputDecoration(
                  hintText: 'Search contacts...',
                  prefixIcon: const Icon(Icons.search_rounded),
                ),
              ),
            ),
            Obx(() {
              if (!controller.isVolunteer) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSize.m),
                child: SegmentedButton<int>(
                  style: ButtonStyle(visualDensity: VisualDensity.compact),
                  selectedIcon: const Icon(Icons.check_rounded, size: 16),
                  segments: const [
                    ButtonSegment(
                      value: 0,
                      label: Text('Requestees'),
                      icon: Icon(Icons.support_agent_rounded),
                    ),
                    ButtonSegment(
                      value: 1,
                      label: Text('Volunteers'),
                      icon: Icon(Icons.groups_rounded),
                    ),
                  ],
                  selected: {controller.selectedTab.value},
                  onSelectionChanged:
                      (value) => controller.changeTab(value.first),
                ),
              );
            }),
            SizedBox(height: AppSize.sH),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return AppShimmer(
                    child: ListView.separated(
                      padding: EdgeInsets.all(AppSize.m),
                      itemCount: 5,
                      separatorBuilder: (_, __) => SizedBox(height: AppSize.sH),
                      itemBuilder:
                          (_, __) =>
                              const ShimmerListTileSkeleton(subtitleLines: 1),
                    ),
                  );
                }

                final contacts = controller.visibleContacts;
                if (contacts.isEmpty) {
                  return Center(
                    child: Text(
                      'No coordination contacts yet',
                      style: AppTextStyling.body_14M.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchContacts,
                  child: ListView.separated(
                    padding: EdgeInsets.all(AppSize.m),
                    itemCount: contacts.length,
                    separatorBuilder: (_, __) => SizedBox(height: AppSize.sH),
                    itemBuilder: (context, index) {
                      return _ContactTile(
                        contact: contacts[index],
                        onTap: () => controller.openContact(contacts[index]),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final CoordinationContact contact;
  final VoidCallback onTap;

  const _ContactTile({required this.contact, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final firstLetter =
        contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(AppSize.m),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  contact.isVolunteer
                      ? AppColors.steelBlue
                      : AppColors.reliefGreen,
              child: Text(
                firstLetter,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: AppSize.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: AppTextStyling.title_16M.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (contact.email.isNotEmpty)
                    Text(
                      contact.email,
                      style: AppTextStyling.body_12S.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.chat_bubble_outline, color: AppColors.steelBlue),
          ],
        ),
      ),
    );
  }
}
