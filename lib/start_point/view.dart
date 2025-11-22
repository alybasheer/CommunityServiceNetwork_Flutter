import 'package:flutter/material.dart';
import 'package:fyp_source_code/start_point/veiw_cntrl.dart';
import 'package:fyp_source_code/volunteer_side/home/presentation/view/home_screen.dart';
import 'package:fyp_source_code/volunteer_side/map/presentation/view/map_screen.dart';
import 'package:get/get.dart';

class StartPoint extends StatelessWidget {
  StartPoint({super.key});
  final entryVeiwCntrl = Get.put(EntryViewCntrl());

  List<Widget> pages = [HomeScreen(),
  MapScreen()];
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[entryVeiwCntrl.currentIndex.value],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          entryVeiwCntrl.setIndex(index);
        },
        currentIndex: entryVeiwCntrl.currentIndex.value,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
