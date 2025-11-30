import 'package:fyp_source_code/admin/presentation/controller/admin_panel_controller.dart';
import 'package:fyp_source_code/admin/presentation/view/admin_panel_screen.dart';
import 'package:fyp_source_code/auth/presentation/bindings/auth_bindings.dart';
import 'package:fyp_source_code/auth/presentation/view/admin_verification_screen.dart';
import 'package:fyp_source_code/auth/presentation/view/login.dart';
import 'package:fyp_source_code/auth/presentation/view/register_screen.dart';
import 'package:fyp_source_code/auth/presentation/view/role_selection_screen.dart';
import 'package:fyp_source_code/routing/route_names.dart';
import 'package:fyp_source_code/start_point/view.dart';
import 'package:fyp_source_code/volunteer_side/coordination/presentation/view/coordination_screen.dart';
import 'package:fyp_source_code/volunteer_side/home/presentation/view/home_screen.dart';
import 'package:fyp_source_code/volunteer_side/map/presentation/view/map_screen.dart';
import 'package:get/get.dart';

class RoutePaths {
  static List<GetPage> routePath = [
    GetPage(
      name: RouteNames.signup,
      page: () => RegisterScreen(),
      binding: AuthBindings(),
    ),
    GetPage(name: RouteNames.home, page: () => HomeScreen()),
    GetPage(
      name: RouteNames.login,
      page: () => LoginScreen(),
      binding: AuthBindings(),
    ),
    GetPage(name: RouteNames.coordination, page: () => CoordinationScreen()),
    GetPage(
      name: RouteNames.roleSelection,
      page: () => RoleSelectionScreen(),
      binding: AuthBindings(),
    ),
    GetPage(name: RouteNames.map, page: () => MapScreen()),
    GetPage(name: RouteNames.startPoint, page: () => StartPoint()),
    GetPage(name: RouteNames.adminVerification, page: () => AdminVerificationScreen()),
    GetPage(name: RouteNames.adminPanel, page: () => AdminPanelScreen(),),
  ];
}
