import 'package:flutter/material.dart';
import 'package:fyp_source_code/start_point/veiw_cntrl.dart';
import 'package:fyp_source_code/volunteer_side/home/presentation/view/home_screen.dart';
import 'package:fyp_source_code/volunteer_side/map/presentation/view/map_screen.dart';
import 'package:get/get.dart';

class StartPoint extends StatelessWidget {
  StartPoint({super.key});
  final entryVeiwCntrl = Get.put(EntryViewCntrl());

  final List<Widget> pages = [HomeScreen(), MapScreen()];
  

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: pages[entryVeiwCntrl.currentIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          onTap: entryVeiwCntrl.setIndex,
          currentIndex: entryVeiwCntrl.currentIndex.value,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          ],
        ),
      ),
    );
  }
}
