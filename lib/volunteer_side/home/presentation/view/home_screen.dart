import 'package:flutter/material.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/container_decoration.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _sliverAppBar(),
            _quickActionsSection(),
            _requestsHeaderSection(),
            _requestsListSection(),
            _bottomSpacing(),
          ],
        ),
      ),
    );
  }

  // ========== WIDGET SECTIONS ==========
  static Widget _sliverAppBar() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.safetyBlue,
              AppColors.safetyBlue.withOpacity(0.8),
            ],
          ),
        ),
        padding: EdgeInsets.all(AppSize.m),
        child: Column(
          children: [
            // User Profile Card
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.pureWhite.withOpacity(0.98),
                    AppColors.steelBlue.withOpacity(0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.all(AppSize.m),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppColors.steelBlue, AppColors.safetyBlue],
                      ),
                    ),
                    padding: EdgeInsets.all(2),
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.steelBlue.withOpacity(0.1),
                      child: Icon(
                        Icons.person_2_rounded,
                        color: AppColors.pureWhite,
                        size: 36,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSize.m),
                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AbdulGhaffar',
                          style: AppTextStyling.title_18M.copyWith(
                            color: AppColors.pureWhite,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: AppSize.xsH),
                        Text(
                          'Abbottabad',
                          style: AppTextStyling.body_12S.copyWith(
                            color: AppColors.pureWhite.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Stats Icons
                  Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.pureWhite,
                    size: 24,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSize.mH),
            // Stats Row
            Row(
              children: [
                Expanded(child: _statCard('42', 'Completed')),
                SizedBox(width: AppSize.m),
                Expanded(child: _statCard('4.8 ↗', 'Rating')),
                SizedBox(width: AppSize.m),
                Expanded(child: _statCard('4', 'Available')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _statCard(String value, String label) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.pureWhite.withOpacity(0.98),
            AppColors.steelBlue.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(
        vertical: AppSize.mH,
        horizontal: AppSize.s,
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyling.title_18M.copyWith(
              color: AppColors.pureWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSize.xsH),
          Text(
            label,
            style: AppTextStyling.body_12S.copyWith(
              color: AppColors.pureWhite.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _quickActionsSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(AppSize.m),
        child: Row(
          children: [
            _actionButton(
              icon: Icons.notifications_active,
              label: 'Alerts',
              color: AppColors.pureWhite,
              backgroundColor: AppColors.emergencyRed,
              onTap: () {},
            ),
            SizedBox(width: AppSize.m),
            _actionButton(
              icon: Icons.people_alt,
              label: 'Coordination',
              color: AppColors.pureWhite,
              backgroundColor: AppColors.steelBlue,
              onTap: () => Get.toNamed('/coordination'),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(
            vertical: AppSize.mH,
            horizontal: AppSize.s,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              SizedBox(width: AppSize.s),
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTextStyling.body_14M.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _requestsHeaderSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.m,
          vertical: AppSize.mH,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Nearby Requests',
              style: AppTextStyling.title_18M.copyWith(
                color: AppColors.darkGray,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'View All',
              style: AppTextStyling.body_14M.copyWith(
                color: AppColors.steelBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _requestsListSection() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.m,
            vertical: AppSize.m,
          ),
          child: _requestCard(index),
        ),
        childCount: 8,
      ),
    );
  }

  static Widget _bottomSpacing() {
    return SliverToBoxAdapter(child: SizedBox(height: AppSize.lH));
  }

  // ========== REUSABLE WIDGETS ==========
  static Widget _requestCard(int index) {
    return Container(
      decoration: ContainerDecorations.customShadowDecoration(
        backgroundColor: AppColors.pureWhite,
        borderRadius: 12,
        shadowColor: AppColors.darkGray.withOpacity(0.1),
        blurRadius: 8,
        spreadRadius: 0,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(AppSize.mH),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with avatar and status
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [AppColors.steelBlue, AppColors.safetyBlue],
                        ),
                      ),
                      padding: EdgeInsets.all(2),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.steelBlue.withOpacity(0.1),
                        child: Icon(
                          Icons.person_2_rounded,
                          color: AppColors.steelBlue,
                          size: 32,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSize.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency Request #${index + 1}',
                            style: AppTextStyling.title_16M.copyWith(
                              color: AppColors.darkGray,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: AppSize.xsH),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.amberOrange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSize.s,
                              vertical: 2,
                            ),
                            child: Text(
                              'Urgent',
                              style: AppTextStyling.body_12S.copyWith(
                                color: AppColors.amberOrange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.mediumGray,
                    ),
                  ],
                ),

                SizedBox(height: AppSize.mH),

                // Request description
                Text(
                  'Stuck at landsliding in Hunza, need immediate medical assistance',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyling.body_14M.copyWith(
                    color: AppColors.darkGray,
                    height: 1.4,
                  ),
                ),

                SizedBox(height: AppSize.mH),

                // Location and distance
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppColors.darkGray,
                    ),
                    SizedBox(width: AppSize.s),
                    Expanded(
                      child: Text(
                        'Downtown, Lahore • ${1.5 + index} km away',
                        style: AppTextStyling.body_12S.copyWith(
                          color: AppColors.darkGray,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSize.mH),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.phone),
                        label: const Text('Call'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.steelBlue,
                          side: BorderSide(
                            color: AppColors.steelBlue.withOpacity(0.5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSize.s),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Accept'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.reliefGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
