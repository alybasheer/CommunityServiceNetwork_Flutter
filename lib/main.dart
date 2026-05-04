import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fyp_source_code/routing/route_paths.dart';
import 'package:fyp_source_code/routing/route_names.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_theme.dart';
import 'package:fyp_source_code/volunteer_side/profile/presentation/controller/profile_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final profileCtrl = Get.put(ProfileController());
  await Future.wait([profileCtrl.themeLoad()]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final profileCtrl = Get.find<ProfileController>();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (context, child) {
        return Obx(
          () => GetMaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode:
                profileCtrl.isSwitching.value
                    ? ThemeMode.dark
                    : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            initialRoute: RouteNames.splash,
            getPages: RoutePaths.routePath,
          ),
        );
      },
    );
  }
}
