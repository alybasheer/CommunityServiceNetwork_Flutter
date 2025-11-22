import 'package:flutter/material.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:fyp_source_code/volunteer_side/home/presentation/view/widgets/elevated_button.dart';
import 'package:fyp_source_code/volunteer_side/home/presentation/view/widgets/home_card.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // print("${AppSize.sectionMedium} actual height");

    return Scaffold(
      body: Column(
        children: [
          HomeCard(),
          // AppSize.lHeight,
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.m,
              vertical: AppSize.lH,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                elevatedButton(Icons.notification_important_rounded, 'Alerts'),
                elevatedButton(
                  Icons.people_alt_rounded,
                  'Coordination',
                  onPressed: () {
                    Get.toNamed('/coordination');
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: AppSize.hp(16),
                  child: Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(
                      horizontal: AppSize.m,
                      vertical: AppSize.xsH,
                    ),
                    child: requestTile(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget requestTile() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: AppSize.m),
    child: Row(
      children: [
        const CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.person_2_rounded, color: Colors.white),
        ),
        SizedBox(width: AppSize.s),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stuck at landsling in hunza need help',
                  maxLines: 2,
                  style: AppTextStyling.title_16M.copyWith(
                    color: AppColors.black,
                  ),
                ),
                AppSize.sHeight,

                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey,
                      ),
                      SizedBox(width: AppSize.s),
                      Expanded(
                        child: Text(
                          'Downtown, City',
                          style: AppTextStyling.body_12S.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Text(
                        '15 min ago',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: AppSize.s),
        Text(
          'Normal',
          style: TextStyle(
            color: Colors.green[700],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
