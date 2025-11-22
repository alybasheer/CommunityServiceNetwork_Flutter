import 'package:flutter/material.dart';
import 'package:fyp_source_code/auth/data/models/signin_model.dart';
import 'package:fyp_source_code/auth/data/repo/signup_repo.dart';
import 'package:fyp_source_code/auth/presentation/view/role_selection_screen.dart';
import 'package:fyp_source_code/network/error_handler.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  RxString passwordError = ''.obs;
  RxString emailError = ''.obs;
  RxString nameError = ''.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  SignupModel signupModel = SignupModel();
  User user = User();

  RxBool isPasswordVisible = false.obs;
  RxBool isRememberMe = false.obs;

  RxBool isFieldEmpt = true.obs;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      emailError.value = 'Email is required';
      return emailError.value;
    } else if (!GetUtils.isEmail(value)) {
      emailError.value = 'Please enter a valid email';
      return emailError.value;
    }
    emailError.value = '';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      passwordError.value = 'Password is required';
      return passwordError.value;
    } else if (value.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      return passwordError.value;
    }
    passwordError.value = '';
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      nameError.value = 'Name is required';
      return nameError.value;
    } else if (value.length < 3) {
      nameError.value = 'Name must be at least 3 characters';
      return nameError.value;
    }
    nameError.value = '';
    return null;
  }

  Future<void> onClick() async {
    if (loginFormKey.currentState!.validate()) {
      // try {
      // authModel.email = emailController.text;
      // authModel.password = passController.text;

      //   var responseData = await LoginRepo().postData(authModel);
      //   print('Login successful: $responseData');
      //   ProfileRepo().getUserProfile();
      //   Get.to(MainViewScreen());
      //   if (isRememberMe.value) {
      //     StorageHelper().saveData('isLogin', responseData.token);
      //     print("saved token ${StorageHelper().readData('isLogin')}");
      //   }
      // } catch (e) {
      //   ErrorHandler.exception(e as Exception);
      // }
    }
  }

  Future<void> onRegisterClick() async {

    if (registerFormKey.currentState!.validate()) {
      
      signupModel.user = User(
        username: usernameController.text,
        email: emailController.text,
        password: passController.text,
      );
      print('=== REGISTRATION DEBUG ===');
      print('Username: ${usernameController.text}');
      print('Email: ${emailController.text}');
      print('Password: ${passController.text}');
      print('Payload being sent: ${signupModel.toJson()}');
      print('========================');
      try {
        await RegisterRepo().postData(signupModel.toJson());
        Get.to(RoleSelectionScreen());
      } catch (e) {
        // ErrorHandler.exception(e);
        print("error reason -> $e");
      }
    }
  }

  void toggleRememberMe(bool value) {
    isRememberMe.value = value;
  }
}
