import 'package:fyp_source_code/admin/presentation/view/admin_panel_screen.dart';
import 'package:fyp_source_code/auth/presentation/bindings/auth_bindings.dart';
import 'package:fyp_source_code/auth/presentation/view/admin_verification_screen_professional.dart';
import 'package:fyp_source_code/auth/presentation/view/login_screen_professional.dart';
import 'package:fyp_source_code/auth/presentation/view/register_screen_professional.dart';
import 'package:fyp_source_code/auth/presentation/view/role_selection_screen.dart';
import 'package:fyp_source_code/auth/presentation/view/waiting_screen.dart';
import 'package:fyp_source_code/chat/presentation/view/chat_screen.dart';
import 'package:fyp_source_code/routing/route_names.dart';
import 'package:fyp_source_code/splash_onboardings/presentation/view/onboarding_screen_professional.dart';
import 'package:fyp_source_code/splash_onboardings/presentation/view/splash_screen_professional.dart';
import 'package:fyp_source_code/start_point/view.dart';
import 'package:fyp_source_code/volunteer_side/coordination/presentation/view/coordination_screen.dart';
import 'package:fyp_source_code/volunteer_side/home/presentation/view/home_screen.dart';
import 'package:fyp_source_code/volunteer_side/map/presentation/view/map_screen.dart';
import 'package:get/get.dart';

class RoutePaths {
  static List<GetPage> routePath = [
    // SPLASH SCREEN - Initial route
    GetPage(name: RouteNames.splash, page: () => SplashScreenProfessional()),

    // ONBOARDING SCREEN
    GetPage(
      name: RouteNames.onboarding,
      page: () => OnboardingScreenProfessional(),
    ),

    // AUTH SCREENS
    GetPage(
      name: RouteNames.signup,
      page: () => RegisterScreenProfessional(),
      binding: AuthBindings(),
    ),
    GetPage(
      name: RouteNames.login,
      page: () => LoginScreen(),
      binding: AuthBindings(),
    ),
    GetPage(
      name: RouteNames.roleSelection,
      page: () => RoleSelectionScreen(),
      binding: AuthBindings(),
    ),
    GetPage(
      name: RouteNames.adminVerification,
      page: () => AdminVerificationScreenProfessional(),
    ),
    GetPage(name: RouteNames.waitingScreen, page: () => WaitingScreen()),

    // VOLUNTEER SCREENS
    GetPage(name: RouteNames.home, page: () => HomeScreen()),
    GetPage(name: RouteNames.coordination, page: () => CoordinationScreen()),
    GetPage(
      name: RouteNames.chatDetail,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        return ChatScreen(
          receiverId: args?['userId'] ?? '',
          receiverName: args?['userName'] ?? 'Chat',
        );
      },
    ),
    GetPage(name: RouteNames.map, page: () => MapScreen()),

    // ADMIN SCREENS
    GetPage(name: RouteNames.adminPanel, page: () => AdminPanelScreen()),

    // MISC SCREENS
    GetPage(name: RouteNames.startPoint, page: () => StartPoint()),
  ];
}
