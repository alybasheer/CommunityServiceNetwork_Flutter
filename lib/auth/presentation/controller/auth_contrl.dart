import 'package:flutter/material.dart';
import 'package:fyp_source_code/auth/data/models/signin_model.dart';
import 'package:fyp_source_code/auth/data/repo/login-_repo.dart';
import 'package:fyp_source_code/auth/data/repo/signup_repo.dart';
import 'package:fyp_source_code/routing/route_names.dart';
import 'package:fyp_source_code/utilities/helpers/toast_helper.dart';
import 'package:fyp_source_code/utilities/reuse_components/storage_helper.dart';
import 'package:fyp_source_code/utilities/validators/validators.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  // Form state observables
  RxString passwordError = ''.obs;
  RxString emailError = ''.obs;
  RxString nameError = ''.obs;
  RxString confirmPasswordError = ''.obs;
  RxString userRole = ''.obs;

  // UI state observables
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;
  RxBool isRememberMe = false.obs;
  RxBool isFieldEmpt = true.obs;
  RxBool isLoading = false.obs;

  // Text controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  SignupModel signupModel = SignupModel();
  SignupModel loginModel = SignupModel();
  User user = User();

  @override
  void onInit() {
    super.onInit();
    GetStorage.init();
    // Monitor form fields for changes
    emailController.addListener(_validateFormState);
    passController.addListener(_validateFormState);
    usernameController.addListener(_validateFormState);
    confirmPassController.addListener(_validateFormState);
  }

  // ============ FORM STATE MANAGEMENT ============
  void _validateFormState() {
    isFieldEmpt.value =
        emailController.text.isEmpty ||
        passController.text.isEmpty ||
        usernameController.text.isEmpty;
  }

  // ============ EMAIL VALIDATION ============
  String? validateEmail(String? value) {
    return AppValidators.validateEmail(value);
  }

  // ============ PASSWORD VALIDATION ============
  String? validatePassword(String? value) {
    return AppValidators.validatePassword(value);
  }

  // ============ NAME VALIDATION ============
  String? validateName(String? value) {
    return AppValidators.validateName(value);
  }

  // ============ CONFIRM PASSWORD VALIDATION ============
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
      return confirmPasswordError.value;
    }

    final result = AppValidators.validateConfirmPassword(
      value,
      passController.text,
    );
    if (result != null) {
      confirmPasswordError.value = result;
      return result;
    }

    confirmPasswordError.value = '';
    return null;
  }

  // ============ TOGGLE PASSWORD VISIBILITY ============
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // ============ REMEMBER ME TOGGLE ============
  void toggleRememberMe(bool value) {
    isRememberMe.value = value;
    if (value) {
      StorageHelper().saveData('rememberEmail', emailController.text);
    } else {
      StorageHelper().removeData('rememberEmail');
    }
  }

  // ============ LOGIN ============
  Future<void> onLogin() async {
    if (!loginFormKey.currentState!.validate()) {
      ToastHelper.showError('Please fix the errors above');
      return;
    }

    isLoading.value = true;

    try {
      // Create login request
      loginModel.user = User(
        email: emailController.text.trim(),
        password: passController.text,
      );

      // Call API
      final resp = await LoginRepo().loginRepo(loginModel.toJson());

      // Validate response
      if (resp.accessToken == null || resp.accessToken!.isEmpty) {
        throw Exception('Server did not return access token');
      }

      if (resp.user == null) {
        throw Exception('Server did not return user data');
      }

      // Store credentials
      StorageHelper().saveData('token', resp.accessToken);
      StorageHelper().saveData('email', resp.user!.email);
      StorageHelper().saveData('profile_email', resp.user!.email);
      StorageHelper().saveData('userId', resp.user!.id);
      if (resp.user!.role != null && resp.user!.role!.trim().isNotEmpty) {
        StorageHelper().saveData('role', resp.user!.role!.trim());
        userRole.value = resp.user!.role!.trim();
      }
      if (resp.user!.verificationStatus != null &&
          resp.user!.verificationStatus!.trim().isNotEmpty) {
        StorageHelper().saveData(
          'verificationStatus',
          resp.user!.verificationStatus!.trim(),
        );
      }
      if ((resp.user!.fullName ?? resp.user!.username) != null) {
        StorageHelper().saveData(
          'profile_name',
          (resp.user!.fullName ?? resp.user!.username)!.trim(),
        );
      }
      if (resp.user!.location != null) {
        StorageHelper().saveData(
          'profile_location',
          resp.user!.location!.trim(),
        );
      }

      // Debug logs
      print('✅ Login successful');
      print('Token: ${StorageHelper().readData('token')}');
      print('Email: ${StorageHelper().readData('email')}');
      print('Role: ${StorageHelper().readData('role')}');

      // Show success message
      ToastHelper.showSuccess('Login successful!');

      // Navigate based on role and verification status
      Future.delayed(Duration(milliseconds: 500), () async {
        final userRole = resp.user!.role?.toLowerCase() ?? '';
        print('🔍 Navigating user with role: $userRole');

        // Admin users go directly to admin panel
        if (userRole == 'admin') {
          print('👨‍💼 Admin user detected - Navigating to admin panel');
          Get.offAllNamed(RouteNames.adminPanel);
        } else if (userRole == 'requestee' ||
            userRole == 'request_help' ||
            userRole == 'requesthelp') {
          Get.offAllNamed(RouteNames.requestHome);
        } else {
          if (userRole == 'volunteer') {
            print('✅ Already verified - Navigating directly to startPoint');
            await Get.offAllNamed(RouteNames.startPoint);
          } else {
            print(
              '📡 Status unknown/pending - Navigating to splash for fresh check',
            );
            Get.offAllNamed(RouteNames.splash);
          }
        }
      });
    } catch (e) {
      print('❌ Login error: $e');
      ToastHelper.showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  // ============ REGISTER ============
  Future<void> onRegisterClick() async {
    if (!registerFormKey.currentState!.validate()) {
      ToastHelper.showError('Please fix the errors above');
      return;
    }

    // Validate confirm password matches
    if (passController.text != confirmPassController.text) {
      ToastHelper.showError('Passwords do not match');
      return;
    }

    isLoading.value = true;

    try {
      // Create signup request
      signupModel.user = User(
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        password: passController.text,
      );

      print('📤 Register payload: ${signupModel.toJson()}');

      // Call API
      final resp = await RegisterRepo().postData(signupModel);

      // Validate response
      if (resp.accessToken == null || resp.accessToken!.isEmpty) {
        throw Exception('Server did not return access token');
      }

      // Store credentials
      StorageHelper().saveData('token', resp.accessToken);
      StorageHelper().saveData('email', resp.user?.email);
      StorageHelper().saveData('profile_email', resp.user?.email);
      StorageHelper().saveData('userId', resp.user?.id);
      if (resp.user?.role != null && resp.user!.role!.trim().isNotEmpty) {
        StorageHelper().saveData('role', resp.user!.role!.trim());
        userRole.value = resp.user!.role!.trim();
      }
      if (resp.user?.verificationStatus != null &&
          resp.user!.verificationStatus!.trim().isNotEmpty) {
        StorageHelper().saveData(
          'verificationStatus',
          resp.user!.verificationStatus!.trim(),
        );
      }
      if ((resp.user?.fullName ?? resp.user?.username) != null) {
        StorageHelper().saveData(
          'profile_name',
          (resp.user?.fullName ?? resp.user?.username)!.trim(),
        );
      }
      if (resp.user?.location != null) {
        StorageHelper().saveData(
          'profile_location',
          resp.user!.location!.trim(),
        );
      }

      print('✅ Registration successful');

      // Show success message
      ToastHelper.showSuccess('Account created successfully!');

      // Navigate to role selection
      Future.delayed(Duration(milliseconds: 500), () {
        Get.offAllNamed(RouteNames.roleSelection);
      });
    } catch (e) {
      print('❌ Register error: $e');
      ToastHelper.showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  // ============ CLEAR FORM ============
  void clearLoginForm() {
    emailController.clear();
    passController.clear();
    isRememberMe.value = false;
    emailError.value = '';
    passwordError.value = '';
  }

  void clearRegisterForm() {
    usernameController.clear();
    emailController.clear();
    passController.clear();
    confirmPassController.clear();
    nameError.value = '';
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
  }

  // ============ LOGOUT ============
  Future<void> logout() async {
    try {
      StorageHelper().removeData('token');
      StorageHelper().removeData('email');
      StorageHelper().removeData('userId');
      StorageHelper().removeData('role');
      StorageHelper().removeData('verificationStatus');
      StorageHelper().removeData('profile_name');
      StorageHelper().removeData('profile_email');
      StorageHelper().removeData('profile_location');
      StorageHelper().removeData('name');
      StorageHelper().removeData('username');
      StorageHelper().removeData('city');
      StorageHelper().removeData('location');
      StorageHelper().removeData('locationName');
      StorageHelper().saveData('hasSeenOnboarding', true);
      userRole.value = '';
      clearLoginForm();
      clearRegisterForm();
      Get.offAllNamed(RouteNames.login);
    } catch (e) {
      print('Logout error: $e');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    usernameController.dispose();
    super.onClose();
  }
}
