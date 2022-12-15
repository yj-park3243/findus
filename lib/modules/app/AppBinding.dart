import 'package:findus/modules/app/app_controller.dart';
import 'package:findus/modules/board/board_controller.dart';
import 'package:findus/modules/work/work_controller.dart';
import 'package:findus/modules/map/map_controller.dart';
import 'package:findus/modules/setting/setting_controller.dart';
import 'package:get/get.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AppController());
    Get.put(BoardController());
    Get.put(WorkController());
    Get.put(MapController());
    Get.put(SettingController());
  }
}
