import 'package:get/get.dart';

class EntryViewCntrl extends GetxController {
  RxInt currentIndex = 0.obs;

  void setIndex(int value) {
    currentIndex.value = value;
  }
}