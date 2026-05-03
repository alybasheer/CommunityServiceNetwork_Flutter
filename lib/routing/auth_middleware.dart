import 'package:flutter/material.dart';
import 'package:fyp_source_code/routing/route_names.dart';
import 'package:fyp_source_code/utilities/reuse_components/storage_helper.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  final Set<String> allowedRoles;

  AuthMiddleware({this.allowedRoles = const {}});

  @override
  RouteSettings? redirect(String? route) {
    final token = StorageHelper().readData('token')?.toString().trim() ?? '';

    if (token.isEmpty) {
      return const RouteSettings(name: RouteNames.login);
    }

    if (allowedRoles.isEmpty) {
      return null;
    }

    final role = _normalizeRole(
      StorageHelper().readData('role')?.toString().trim() ?? '',
    );

    if (allowedRoles.contains(role)) {
      return null;
    }

    return RouteSettings(name: _fallbackRouteForRole(role));
  }

  String _normalizeRole(String role) {
    final normalized = role.toLowerCase().trim();
    if (normalized == 'requestee' ||
        normalized == 'request_help' ||
        normalized == 'requesthelp') {
      return 'user';
    }

    return normalized;
  }

  String _fallbackRouteForRole(String role) {
    switch (role) {
      case 'admin':
        return RouteNames.adminPanel;
      case 'volunteer':
        return RouteNames.startPoint;
      case 'user':
        return RouteNames.requestHome;
      default:
        return RouteNames.roleSelection;
    }
  }
}

class GuestOnlyMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final token = StorageHelper().readData('token')?.toString().trim() ?? '';
    if (token.isEmpty) {
      return null;
    }

    final role =
        StorageHelper().readData('role')?.toString().toLowerCase().trim() ?? '';

    switch (role) {
      case 'admin':
        return const RouteSettings(name: RouteNames.adminPanel);
      case 'volunteer':
        return const RouteSettings(name: RouteNames.startPoint);
      case 'user':
      case 'requestee':
      case 'request_help':
      case 'requesthelp':
        return const RouteSettings(name: RouteNames.requestHome);
      default:
        return const RouteSettings(name: RouteNames.roleSelection);
    }
  }
}
