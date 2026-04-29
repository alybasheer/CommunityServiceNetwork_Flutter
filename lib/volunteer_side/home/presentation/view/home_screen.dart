import 'package:flutter/material.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:fyp_source_code/volunteer_side/home/presentation/view/widgets/quick_actions.dart';
import 'package:fyp_source_code/volunteer_side/home/presentation/view/widgets/req_header.dart';
import 'package:fyp_source_code/volunteer_side/home/presentation/view/widgets/req_list.dart';
import 'package:fyp_source_code/volunteer_side/home/presentation/view/widgets/silver_appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            sliverAppBar(),
            quickActionsSection(),
            requestsHeaderSection(),
            requestsListSection(),
            bottomSpacing(),
          ],
        ),
      ),
    );
  }

  static Widget bottomSpacing() {
    return SliverToBoxAdapter(child: SizedBox(height: AppSize.lH));
  }
}
