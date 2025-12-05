import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fyp_source_code/auth/data/models/signin_model.dart';
import 'package:fyp_source_code/auth/data/repo/login-_repo.dart';
import 'package:fyp_source_code/auth/data/repo/signup_repo.dart';
import 'package:fyp_source_code/network/api_service.dart';
import 'package:fyp_source_code/services/api_names.dart';
import 'package:fyp_source_code/services/google_signin_service.dart';
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
      StorageHelper().saveData('userId', resp.user!.id);
      if (resp.user!.role != null) {
        StorageHelper().saveData('role', resp.user!.role);
        userRole.value = resp.user!.role!;
      }

      // Debug logs
      print('✅ Login successful');
      print('Token: ${StorageHelper().readData('token')}');
      print('Email: ${StorageHelper().readData('email')}');
      print('Role: ${StorageHelper().readData('role')}');

      // Show success message
      ToastHelper.showSuccess('Login successful!');

      // Navigate based on role and verification status
      Future.delayed(Duration(milliseconds: 500), () {
        final userRole = resp.user!.role?.toLowerCase() ?? '';
        print('🔍 Navigating user with role: $userRole');

        // Admin users go directly to admin panel
        if (userRole == 'admin') {
          print('👨‍💼 Admin user detected - Navigating to admin panel');
          Get.offAllNamed('/adminPanel');
        } else {
          // For volunteers: check cached verification status
          // If already verified, go directly to startPoint
          // Otherwise go to splash to check/fetch status
          final cachedStatus =
              StorageHelper().readData('verificationStatus')?.toString() ?? '';
          print('👤 Volunteer user - Cached status: $cachedStatus');

          if (cachedStatus == 'verified' || cachedStatus == 'approved') {
            print('✅ Already verified - Navigating directly to startPoint');
            Get.offAllNamed('/startPoint');
          } else {
            print(
              '📡 Status unknown/pending - Navigating to splash for fresh check',
            );
            Get.offAllNamed('/splash');
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
      if (resp.user?.id != null) {
        StorageHelper().saveData('userId', resp.user!.id);
      }

      print('✅ Registration successful');

      // Show success message
      ToastHelper.showSuccess('Account created successfully!');

      // Navigate to role selection
      Future.delayed(Duration(milliseconds: 500), () {
        Get.offAllNamed('/roleSelection');
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
      userRole.value = '';
      clearLoginForm();
      clearRegisterForm();
      Get.offAllNamed('/loginScreen');
    } catch (e) {
      print('Logout error: $e');
    }
  }

  // ============ GOOGLE LOGIN ============
  // Future<void> loginWithGoogle() async {
  //   isLoading.value = true;

  //   try {
  //     print('🔐 Starting Google Sign-In...');

  //     // Get ID Token from Google (static method)
  //     // final idToken = await GoogleSignInService.getGoogleIdToken();

  //     // if (idToken == null) {
  //     //   print('❌ Failed to get Google ID Token');
  //     //   ToastHelper.showInfo('Google Sign-In cancelled');
  //     //   isLoading.value = false;
  //     //   return;
  //     // }

  //     print('✅ Google Sign-In successful with idToken');

  //     // Prepare request body
  //     // final requestBody = {'idToken': idToken, 'username': 'google_user'};

  //     // print('📤 Sending request to backend...');

  //     // Send to backend for verification and JWT token generation
  //     // final response = await DioHelper().post(
  //     //   url: ApiNames.googleLogin,
  //     //   reqBody: requestBody,
  //     // );

  //     print('📬 Backend response received');

  //     // Parse response
  //     if (response == null) {
  //       throw Exception('Server returned empty response');
  //     }

  //     // Extract token and user data from response
  //     final accessToken = response['accessToken'] ?? response['token'];
  //     final userData = response['user'];

  //     if (accessToken == null || accessToken.isEmpty) {
  //       throw Exception('Server did not return access token');
  //     }

  //     if (userData == null) {
  //       throw Exception('Server did not return user data');
  //     }

  //     // Store credentials
  //     StorageHelper().saveData('token', accessToken);
  //     StorageHelper().saveData(
  //       'email',
  //       userData['email'] ?? userData['username'],
  //     );
  //     StorageHelper().saveData('userId', userData['_id'] ?? userData['id']);

  //     if (userData['role'] != null) {
  //       StorageHelper().saveData('role', userData['role']);
  //       userRole.value = userData['role']!;
  //     }

  //     print('✅ Credentials stored successfully');
  //     print('Token: ${StorageHelper().readData('token')}');
  //     print('Email: ${StorageHelper().readData('email')}');
  //     print('Role: ${StorageHelper().readData('role')}');

  //     // Show success message
  //     ToastHelper.showSuccess('Logged in with Google!');

  //     // Navigate based on role and verification status
  //     Future.delayed(Duration(milliseconds: 500), () {
  //       final role = userData['role']?.toString().toLowerCase() ?? '';
  //       print('🔍 Navigating user with role: $role');

  //       // Admin users go directly to admin panel
  //       if (role == 'admin') {
  //         print('👨‍💼 Admin user detected - Navigating to admin panel');
  //         Get.offAllNamed('/adminPanel');
  //       } else {
  //         // For volunteers: check cached verification status
  //         final cachedStatus =
  //             StorageHelper().readData('verificationStatus')?.toString() ?? '';
  //         print('👤 Volunteer user - Cached status: $cachedStatus');

  //         if (cachedStatus == 'verified' || cachedStatus == 'approved') {
  //           print('✅ Already verified - Navigating directly to startPoint');
  //           Get.offAllNamed('/startPoint');
  //         } else {
  //           print(
  //             '📡 Status unknown/pending - Navigating to splash for fresh check',
  //           );
  //           Get.offAllNamed('/splash');
  //         }
  //       }
  //     });
  //   } on DioException catch (e) {
  //     print('❌ DioException during Google login: ${e.message}');
  //     final errorMsg =
  //         e.response?.data?['message'] ?? e.message ?? 'Unknown error';
  //     ToastHelper.showError('Google login failed: $errorMsg');
  //   } catch (e) {
  //     print('❌ Error during Google Sign-In: $e');
  //     ToastHelper.showError(e.toString().replaceAll('Exception: ', ''));
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  @override
  void onClose() {
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    usernameController.dispose();
    super.onClose();
  }
}
