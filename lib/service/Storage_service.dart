import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';


class StorageService extends GetxService {
  GetStorage storage = GetStorage();

  Future<StorageService> init() async {
    return this;
  }
  getData(key) async {
    return await storage.read(key);
  }
  setData(key, value) async {
    return await storage.write(key, value);
  }
}
