import 'package:findus/service/Storage_service.dart';
import 'package:findus/service/api_service.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'auth_service.dart';


class MapService extends GetxService {
  final auth = Get.find<AuthService>();
  final api = Get.find<ApiService>();
  final storage = Get.find<StorageService>();

  //var mapList = <MapModel>[];

  Future<MapService> init() async {
    //mapList = storage.getData('map');
    return this;
  }
  Future<void> getMapData() async {

  }

}
