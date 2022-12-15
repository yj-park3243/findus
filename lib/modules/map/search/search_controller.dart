import 'dart:async';
import 'package:findus/constants/common_sizes.dart';
import 'package:findus/model/Location.dart';
import 'package:findus/modules/app/app_controller.dart';
import 'package:findus/modules/map/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  var searchTxt = TextEditingController();

  final mapController = Get.find<MapController>();

  var searchNode = FocusNode();
  var searchData = <Location?>[].obs;
  var searchTxt1 = "".obs;
  var tempTxt = "".obs;

  @override
  void onInit() {
    if (mapController.searchTxt.value != "") {
      searchTxt.text = mapController.searchTxt.value;
      searchEvent(mapController.searchTxt.value);
    }
    searchData.value = mapController.mapData;
    searchNode.requestFocus();
    super.onInit();
  }

  @override
  void onClose() {
    final appController = Get.find<AppController>();
    appController.bottomNavigationLogSetScreen();
    super.onClose();
  }

  searchEvent(String txt) {
    Timer(const Duration(milliseconds: 500), () {
      tempTxt.value = txt;
      if (tempTxt == searchTxt.text) {
        searchTxt1.value = txt;
        mapController.searchTxt.value = txt;
      }
    });
  }

  resetSearchTxt() {
    searchTxt1.value = "";
    searchTxt.text = "";
    mapController.searchTxt.value = "";
  }

  getSearchData(BuildContext context) {
    var returnData = searchData.where((e) {
      return (e?.locationName.toString().replaceAll(" ", "") ?? '')
              .contains(searchTxt1.value.replaceAll(" ", "")) ||
          (e?.categoryName.toString().replaceAll(" ", "") ?? '')
              .contains(searchTxt1.value.replaceAll(" ", "")) ||
          (e?.address1_en.toString().replaceAll(" ", "") ?? '')
              .contains(searchTxt1.value.replaceAll(" ", ""))||
          (e?.address1_ko.toString().replaceAll(" ", "") ?? '')
              .contains(searchTxt1.value.replaceAll(" ", ""))||
          (e?.address2_en.toString().replaceAll(" ", "") ?? '')
              .contains(searchTxt1.value.replaceAll(" ", ""))||
          (e?.address2_ko.toString().replaceAll(" ", "") ?? '')
              .contains(searchTxt1.value.replaceAll(" ", "")) ;
    });
    return returnData.map((e) {
      return InkWell(
        onTap: () {
          searchNode.unfocus();
          Timer(const Duration(milliseconds: 100), () {
            Get.back(); //
            mapController.selectLocation(
                    e?.latitude, e?.longitude as double, e!);
          });
        },
        child: Card(
          elevation: 0.3,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/find_us_images/common/mappicker.svg',
                    height: 16,
                  ),
                  const SizedBox(
                    width: CommonGap.xxs,
                  ),
                  Flexible(
                    child: RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      strutStyle: const StrutStyle(fontSize: 14.0),
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        text: e?.locationName.toString() ?? 'null',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: CommonGap.xxs,
                  ),
                  Text(
                    e?.categoryName.toString() ?? 'null',
                    style: const TextStyle(
                        color: Colors.grey,
                        fontFamily: 'SF-Pro-Regular',
                        fontSize: 10),
                  ),
                ],
              ),
              subtitle: Column(
                children: [
                  const SizedBox(
                    height: CommonGap.xs,
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: e?.isOpen == 1
                                      ? Border.all(color: Colors.lightGreen)
                                      : Border.all(color: Colors.redAccent)),
                              child: Padding(
                                padding: const EdgeInsets.all(CommonGap.xxxxs),
                                child: Text(e?.isOpen == 1 ? '영업중'.tr : '마감'.tr,
                                    style: e?.isOpen == 1
                                        ? const TextStyle(
                                            color: Colors.lightGreen,
                                            fontFamily: 'SF-Pro-Regular',
                                            fontSize: 12)
                                        : const TextStyle(
                                            color: Colors.redAccent,
                                            fontFamily: 'SF-Pro-Regular',
                                            fontSize: 12)),
                              ),
                            ),
                            const SizedBox(
                              width: CommonGap.xxs,
                            ),
                            Text(
                              e?.distance.toString() ?? 'null',
                              style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontFamily: 'SF-Pro-Regular',
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: CommonGap.xs,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          strutStyle: const StrutStyle(fontSize: 14.0),
                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            text: e?.address1_en.toString() ?? 'null',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: CommonGap.xs,
                  ),
                  Row(
                    children: [
                      Text(
                        e?.locationPhone.toString() ?? 'null',
                        style: const TextStyle(
                            // fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                            fontFamily: 'SF-Pro-Semibold',
                            fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              isThreeLine: true,
            ),
          ),
        ),
      );
    }).toList();
  }
}
