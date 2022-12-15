import 'dart:async';

import 'package:findus/constants/common_sizes.dart';
import 'package:findus/model/Location.dart';
import 'package:findus/model/location_detail.dart';
import 'package:findus/model/mapCategory.dart';
import 'package:findus/modules/app/app_controller.dart';
import 'package:findus/modules/map/loation/main_map.dart';
import 'package:findus/modules/map/loation/location_detail_page.dart';
import 'package:findus/modules/map/search/mongol_town.dart';
import 'package:findus/service/api_service.dart';
import 'package:findus/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../app/app.dart';

class MapController extends GetxController {
  BuildContext? context;
  var isLoadingProfile = false.obs;
  var detail_page_menu = 1.obs;
  var isLoading = false.obs; // 로딩용
  final api = Get.find<ApiService>();
  late LatLng currentPostion =
      const LatLng(37.56595018951271, 126.97728338254345);
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController googleMapcontroller;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final auth = Get.find<AuthService>();

  Rx<Location?> selectedLocation = Location().obs;
  Rx<LocationDetailModel?> locationDetail = LocationDetailModel().obs;

  var mapCategory = <MapCategory>[].obs;
  var mapData = <Location>[];
  var makerList = <List<Marker>>[];
  var markers = {}.obs; //markers for google map
  var searchTxt = "".obs; //markers for google map

  var townFloor = 0.obs;
  var townCategoryId = 0.obs;

  var townFloorTxt =  ('전체'.tr).obs;
  var townCategoryTxt = ('전체'.tr).obs;


  LatLng showLocation =
      const LatLng(27.7089427, 85.3086209); //location to show in map

  @override
  Future<void> onInit() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.bestForNavigation));

    currentPostion = LatLng(position.latitude, position.longitude);
    //맵에 핀 꽂는곳
    super.onInit();
  }

  @override
  void onClose() {
    final appController = Get.find<AppController>();
    appController.bottomNavigationLogSetScreen();
    //super.onClose();
  }

  getGoogleMap() {
    return MainMap();
  }

  getMapCategory() async {
    try {
      if (_auth.currentUser == null || auth.getJwt() == null) return;

      final data = {"language": Get.locale?.languageCode};
      final res =
          await api.getWithHearder('/location/category', queryParameters: data);
      MapCategoryResult mapCategoryResult =
          MapCategoryResult.fromJson(res.data["payload"]);
      mapCategory.value = mapCategoryResult.result.map((e) => e).toList();
    } catch (e) {
      print(e);
    }
  }

  getLocation() async {
    try {
      getMapCategory();
      var position = await GeolocatorPlatform.instance.getCurrentPosition(
          locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.bestForNavigation));
      currentPostion = LatLng(position.latitude, position.longitude);

      var data = {
        "user_lat": currentPostion.latitude,
        "user_lng": currentPostion.longitude,
        "language": Get.locale?.languageCode
      };

      if (_auth.currentUser == null || auth.getJwt() == null) return;
      final res =
          await api.getWithHearder('/location/list', queryParameters: data);
      LocationResult locationResult =
          LocationResult.fromJson(res.data["payload"]);
      mapData = locationResult.result.map((e) => e).toList();
    } catch (e) {
      print(e);
    }
    return mapData;
  }

  getLocationDetail(Location location) async {
    try {
      var data = {
        "location_id": location.locationId,
        "language": Get.locale?.languageCode
      };

      if (_auth.currentUser == null || auth.getJwt() == null) return;
      final res =
          await api.getWithHearder('/location/detail', queryParameters: data);
      final Map<String, dynamic>? rstData = res.data['payload'];

      if (rstData != null) {
        isLoading.value = true;
        locationDetail.value = LocationDetailModel.fromJson(rstData);
        return;
      }
    } catch (e) {
      print(e);
    }
    return mapData;
  }

  selectLocation(double? latitude, double? longitude, Location? location) {
    googleMapcontroller
        .moveCamera(CameraUpdate.newLatLng(LatLng(latitude!, longitude!)));
    selectedLocation.value = location;
    if(location?.arr_yn == false){
      onMarkerTap(location!);
    }else{
      Get.to(() => const MongolTown(),
          transition: Transition.rightToLeft);
    }
  }


  onMarkerTap(Location location) async {
    return await Get.bottomSheet(
        enableDrag: true,
        useRootNavigator: true,
        barrierColor: const Color.fromRGBO(100, 100, 100, 0.5),
        //elevation: 0,
        isScrollControlled: true,
        elevation: 90,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        )),
        Container(
          height: 180,
          child: TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.black87),
            onPressed: () async {
              selectedLocation.value = location;
              if(location.arr_yn != true){
                await getLocationDetail(location);
                Get.to(() => LocationDetail(location),
                    transition: Transition.rightToLeft);
              }else{
                Get.to(() => const MongolTown(),
                    transition: Transition.rightToLeft);
              }
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 10),
                  child: SizedBox(
                    height: Get.height * 1 / 100,
                    width: Get.width * 10 / 100,
                    child: Center(
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Flexible(
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      strutStyle:
                                          const StrutStyle(fontSize: 14.0),
                                      text: TextSpan(
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'SF-Pro-Heavy',
                                          fontSize: 16,
                                        ),
                                        text: location.locationName ?? '',
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: Get.height * 1.5 / 100),
                                ],
                              ), // 가게 이름
                              const SizedBox(
                                height: CommonGap.xs,
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset("assets/find_us_images/category/${mapCategory.value.firstWhere((element) => element.locationCategoryId ==location
                                          .locationCategoryId).categoryNameEn}.svg")
                                          ,
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          location.categoryName ?? '',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: HexColor('#444444'),
                                              fontSize: 12,
                                              fontFamily: 'SF-Pro-Light'),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          location.distance.toString() ??
                                              'null',
                                          style: const TextStyle(
                                              color: Colors.redAccent,
                                              fontFamily: 'SF-Pro-Regular',
                                              fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ), //카테고리
                                  const SizedBox(
                                    height: CommonGap.xs,
                                  ),
                                  location.openCloseTime == null? SizedBox():
                                  (location.isOpen == 1)
                                      ? Align(
                                          alignment: Alignment.centerLeft,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color:
                                                          Colors.lightGreen)),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                    CommonGap.xxxxs),
                                                child: Text(
                                                  '영업중'.tr,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        'SF-Pro-Regular',
                                                    color: Colors.lightGreen,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Align(
                                          alignment: Alignment.centerLeft,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color: Colors.redAccent)),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                    CommonGap.xxxxs),
                                                child: Text(
                                                  '마감'.tr,
                                                  style: const TextStyle(
                                                    fontSize: 15.0,
                                                    fontFamily:
                                                        'SF-Pro-Regular',
                                                    color: Colors.redAccent,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  const SizedBox(
                                    height: CommonGap.xxs,
                                  ),
                                  location.openCloseTime == null? Align(
                                    alignment: Alignment.centerLeft,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        '${location.address1_en}',
                                        style: TextStyle(
                                            color: HexColor('#444444'),
                                            fontSize: 14,
                                            fontFamily: 'SF-Pro-Regular'),
                                      ),
                                    ),
                                  ):
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        '${(location.isOpen == 1) ? '마감시간'.tr : '영업_시작'.tr} ${(location.isOpen == 1) ? '' : location.openDay} ${location.openCloseTime} ',
                                        style: TextStyle(
                                            color: HexColor('#444444'),
                                            fontSize: 14,
                                            fontFamily: 'SF-Pro-Regular'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: CommonGap.xxs,
                        ),
                        location.imageUrl != null
                            ? Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15.0)),
                                    child: Image(
                                      height: 120,
                                      fit: BoxFit.cover,
                                      image: NetworkImage(location.imageUrl!),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

}
