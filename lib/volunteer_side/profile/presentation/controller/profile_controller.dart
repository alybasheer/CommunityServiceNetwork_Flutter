// ProfileController using GetX
// ...existing code...
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  final storage = GetStorage();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final isSwitching = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController.text = storage.read('profile_name') ?? 'Volunteer User';
    emailController.text = storage.read('profile_email') ?? 'user@example.com';
    isSwitching.value = storage.read('dark_mode') ?? false;
  }

  void saveProfile() {
    storage.write('profile_name', nameController.text.trim());
    storage.write('profile_email', emailController.text.trim());
    Get.snackbar('Saved', 'Profile updated', snackPosition: SnackPosition.BOTTOM);
  }

  void onSwitch() {
    isSwitching.value = !isSwitching.value;
    storage.write('theme', isSwitching.value);
    Get.changeThemeMode(isSwitching.value ? ThemeMode.dark : ThemeMode.light);
  }
  Future<dynamic>  themeLoad() async{
    isSwitching.value = await storage.read('theme') ?? false;
    Get.changeThemeMode( isSwitching.value ? ThemeMode.dark: ThemeMode.light);
  }


  void signOut() {
    // Replace with real auth sign-out if needed
    storage.erase();
    Get.offAllNamed('/');
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
