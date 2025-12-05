import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Professional generic toast messages for common scenarios
class ToastMessages {
  // ============ AUTH MESSAGES ============
  static const String emailNotFound =
      'Email address not found. Create an account or try another email.';
  static const String emailExists =
      'Email already registered. Please log in or use a different email.';
  static const String passwordIncorrect =
      'Password is incorrect. Please try again.';
  static const String loginSuccess = 'Login successful. Welcome back!';
  static const String registerSuccess =
      'Account created successfully. Welcome to our community!';
  static const String logoutSuccess = 'Logged out successfully.';

  // ============ VALIDATION MESSAGES ============
  static const String formError =
      'Please fill in all required fields correctly.';
  static const String validationError =
      'Please check your input and try again.';

  // ============ SERVER MESSAGES ============
  static const String serverError =
      'Something went wrong. Please try again later.';
  static const String networkError =
      'Network error. Please check your connection.';
  static const String timeoutError = 'Request timeout. Please try again.';
  static const String noInternet =
      'No internet connection. Please check your network.';

  // ============ GENERAL MESSAGES ============
  static const String success = 'Operation completed successfully.';
  static const String loading = 'Loading...';
  static const String saved = 'Saved successfully.';
  static const String deleted = 'Deleted successfully.';
  static const String updated = 'Updated successfully.';
}

/// Toast utility for showing snackbars and toast notifications
class ToastHelper {
  /// Show success toast message
  static void showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  /// Show error toast message
  static void showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  /// Show warning toast message
  static void showWarning(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  /// Show info toast message
  static void showInfo(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  /// Show custom toast with custom colors
  static void showCustom(
    String message, {
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    Toast toastLength = Toast.LENGTH_SHORT,
    int timeInSecForIosWeb = 2,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: timeInSecForIosWeb,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 14.0,
    );
  }

  /// Cancel all toasts
  static void cancelAll() {
    Fluttertoast.cancel();
  }

  // ============ GENERIC PROFESSIONAL MESSAGES ============

  /// Show generic error - extracts and formats API errors professionally
  static void showErrorMessage(dynamic error) {
    String message = ToastMessages.serverError;

    if (error is String) {
      // Direct string error
      if (error.toLowerCase().contains('email')) {
        message = ToastMessages.emailNotFound;
      } else if (error.toLowerCase().contains('password')) {
        message = ToastMessages.passwordIncorrect;
      } else if (error.toLowerCase().contains('network') ||
          error.toLowerCase().contains('socket')) {
        message = ToastMessages.networkError;
      } else if (error.toLowerCase().contains('timeout')) {
        message = ToastMessages.timeoutError;
      } else {
        message = error;
      }
    } else if (error.toString().contains('SocketException')) {
      message = ToastMessages.noInternet;
    } else if (error.toString().contains('TimeoutException')) {
      message = ToastMessages.timeoutError;
    }

    showError(message);
  }
}
