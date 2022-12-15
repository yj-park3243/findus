import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:findus/constants/my_flutter_app_icons.dart';
import 'package:findus/modules/app/app_controller.dart';
import 'package:findus/modules/board/board_controller.dart';
import 'package:findus/modules/board/commonWidget/board_list.dart';
import 'package:findus/modules/map/loation/map_page.dart';
import 'package:findus/modules/setting/setting.dart';
import 'package:findus/service/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends GetView<AppController> {
  App({Key? key}) : super(key: key);
  final fs = Get.find<FirebaseService>();
  BoardController baordController = Get.put(BoardController());

  final iconList = <IconData>[
    MyFlutterApp.map,
    MyFlutterApp.aaa,
/*    MyFlutterApp.bbb,*/
    MyFlutterApp.ccc,
  ];

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    final List<Widget> screens = <Widget>[
      MapPage(),
      BoardList(),
      // InformationComingSoon(),
      Setting(),
    ];
    return WillPopScope(
      onWillPop: () async {
        if (controller.selectedTabIndex.value == Tabs.MAP) {
          if (controller.isOnCloseApp == false) {
            controller.onCloseApp(context);
            return false;
          } else {
            controller.bottomNavigationLogSetScreen();
            return true;
          }
        } else {
          controller.selectedTabIndex.value = Tabs.MAP;
          controller.bottomNavigationLogSetScreen();
          return false;
        }
      },
      child: Obx(() => Scaffold(
            appBar: null,
            body: IndexedStack(
              //key: ValueKey(controller.selectedTabIndex.value),
              index: controller.selectedTabIndex.value.index,
              children: screens,
            ),
            //navigationBar decorator
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 0), // changes position of shadow
                  )
                ],
              ),
              child: AnimatedBottomNavigationBar(
                onTap: (index) {
                  controller.selectedTabIndex.value = Tabs.getTabByIndex(index);
                  if(index == 1 && baordController.boardCategory.value.isEmpty){
                    baordController.getBoardCategory();
                  }
                },
                gapLocation: GapLocation.none,
                notchSmoothness: NotchSmoothness.defaultEdge,
                activeIndex: controller.selectedTabIndex.value.index,
                icons: iconList,
                activeColor: Colors.blueAccent,
                splashColor: Colors.blueAccent,
                borderWidth: 5,
                inactiveColor: Colors.grey,
                height: 60,
              ),
            ),
          )),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
