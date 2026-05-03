import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_source_code/main.dart';
import 'package:fyp_source_code/routing/auth_middleware.dart';
import 'package:fyp_source_code/routing/route_names.dart';
import 'package:fyp_source_code/routing/route_paths.dart';
import 'package:fyp_source_code/volunteer_side/profile/presentation/controller/profile_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final storageDirectory = Directory.systemTemp.createTempSync(
    'cerd_storage_test_',
  );

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => storageDirectory.path,
        );
  });

  setUp(() async {
    Get.testMode = true;
    await GetStorage.init();
    await GetStorage().erase();
    await GetStorage().write('hasSeenOnboarding', true);

    if (Get.isRegistered<ProfileController>()) {
      Get.delete<ProfileController>(force: true);
    }

    final profileController = Get.put(ProfileController());
    await profileController.themeLoad();
  });

  tearDown(Get.reset);

  testWidgets('CERD app routes unauthenticated users to login', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('CERD Community'), findsOneWidget);
    expect(find.text('Community support when it matters'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2700));
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back'), findsOneWidget);
  });

  test('protected routes redirect to login without a token', () {
    final redirect = AuthMiddleware().redirect(RouteNames.requestHome);

    expect(redirect?.name, RouteNames.login);
  });

  test('role guards redirect users away from unauthorized sections', () async {
    await GetStorage().write('token', 'test-token');
    await GetStorage().write('role', 'user');

    final adminRedirect = AuthMiddleware(
      allowedRoles: {'admin'},
    ).redirect(RouteNames.adminPanel);

    expect(adminRedirect?.name, RouteNames.requestHome);

    await GetStorage().write('role', 'volunteer');

    final requestOnlyRedirect = AuthMiddleware(
      allowedRoles: {'user'},
    ).redirect(RouteNames.requestHome);

    expect(requestOnlyRedirect?.name, RouteNames.startPoint);
  });

  test('every non-public route has middleware', () {
    final routeNames = <String>{};

    for (final page in RoutePaths.routePath) {
      expect(routeNames.add(page.name), isTrue, reason: '${page.name} repeats');

      if ({RouteNames.splash, RouteNames.onboarding}.contains(page.name)) {
        continue;
      }

      expect(
        page.middlewares,
        isNotEmpty,
        reason: '${page.name} must not be reachable without route middleware',
      );
    }
  });
}
