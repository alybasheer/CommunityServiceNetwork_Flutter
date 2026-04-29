import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fyp_source_code/routing/route_paths.dart';
import 'package:fyp_source_code/volunteer_side/profile/presentation/controller/profile_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
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

    return ScreenUtilInit(
      designSize: Size(375, 812),
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          themeMode: ThemeMode.system,
          darkTheme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          getPages: RoutePaths.routePath,
        );
      },
    );
  }
}
