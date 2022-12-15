import 'dart:async';

import 'package:findus/modules/map/loation/location_detail_page.dart';
import 'package:findus/modules/map/map_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../constants/common_sizes.dart';

class MongolTown extends GetView<MapController> {
  const MongolTown({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('MONGOL TOWN'),
      ),
      body: Obx(() => ListView(
            children: [
              SizedBox(
                height: CommonGap.xs,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: CommonGap.m, right: CommonGap.m),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(CommonGap.xs),
                    child: Obx(() => Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                  onTap: () {
                                    showSelectFloor(context);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        controller.townFloorTxt.value,
                                        style: const TextStyle(
                                          fontFamily: 'SF-Pro-Bold',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Icon(
                                          Icons.keyboard_arrow_down_rounded)
                                    ],
                                  )),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                  onTap: () {
                                    showSelectCategory(context);
                                  },
                                  child: Row(
                                    children: [
                                      Text(controller.townCategoryTxt.value,
                                          style: const TextStyle(
                                            fontFamily: 'SF-Pro-Bold',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      const Icon(
                                          Icons.keyboard_arrow_down_rounded)
                                    ],
                                  )),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: CommonGap.xs,
              ),
              Divider(
                thickness: 1,
              ),
              ...controller.mapData
                  .where((element) =>
                      element.parent_id ==
                          controller.selectedLocation.value?.locationId &&
                      (controller.townFloor.value == 0 ||
                          element.location_floor ==
                              controller.townFloor.value) &&
                      (controller.townCategoryId.value == 0 ||
                          element.locationCategoryId ==
                              controller.townCategoryId.value))
                  .toList()
                  .map((e) => InkWell(
                        onTap: () async {
                          //controller.selectedLocation.value = e;
                          await controller.getLocationDetail(e);
                          Get.to(() =>  LocationDetail(e),
                              transition: Transition.rightToLeft);
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
                                      strutStyle:
                                          const StrutStyle(fontSize: 14.0),
                                      text: TextSpan(
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                        text: e?.locationName.toString() ??
                                            '-',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: CommonGap.xxs,
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                children: [
                                  const SizedBox(
                                    height: CommonGap.xs,
                                  ),
                                  Row(children: [
                                    Text(
                                      '${e.room_number ?? '-'}${'호'.tr} | ' ,
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'SF-Pro-Regular',
                                          fontSize: 10),
                                    ),
                                    const SizedBox(
                                      height: CommonGap.xs,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: CommonGap.xxs),
                                      child: Text(
                                        e?.categoryName.toString() ?? '-',
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'SF-Pro-Regular',
                                            fontSize: 10),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(5),
                                          border: e.isOpen == 1
                                              ? Border.all(
                                              color:
                                              Colors.lightGreen)
                                              : Border.all(
                                              color: Colors
                                                  .redAccent)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            CommonGap.xxxxs),
                                        child: Text(
                                            e?.isOpen == 1
                                                ? '영업중'.tr
                                                : '마감'.tr,
                                            style: e?.isOpen == 1
                                                ? const TextStyle(
                                                color: Colors
                                                    .lightGreen,
                                                fontFamily:
                                                'SF-Pro-Regular',
                                                fontSize: 12)
                                                : const TextStyle(
                                                color: Colors
                                                    .redAccent,
                                                fontFamily:
                                                'SF-Pro-Regular',
                                                fontSize: 12)),
                                      ),
                                    ),
                                  ],),
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
                      ))
            ],
          )),
    );
  }

  Future<void> showSelectFloor(BuildContext context) async {
    var floorList = [];
    floorList.addAllIf(
        true,
        controller.mapData
            .where((element) =>
                element.parent_id ==
                controller.selectedLocation.value?.locationId)
            .map((e) => e.location_floor));
    floorList = floorList.toSet().toList();
    floorList.sort();
    return await showBarModalBottomSheet(
        barrierColor: Colors.black26,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(CommonRadius.m),
                topRight: Radius.circular(CommonRadius.m))),
        context: context,
        builder: (context) {
          return SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Column(
                        children: [
                          ListTile(
                            onTap: () {
                              controller.townFloorTxt.value = '전체'.tr;
                              controller.townFloor.value = 0;
                              controller.townCategoryId.value = 0;
                              controller.townCategoryTxt.value = '전체'.tr;
                              Get.back();
                            },
                            title: Text(
                              '전체'.tr,
                              style: TextStyle(
                                fontFamily: 'SF-Pro-Bold',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ...floorList.map((e) => Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      controller.townFloorTxt.value = e < 4 &&
                                              e > 0
                                          ? '${e.toString().replaceAll('-', 'B')} ${'123층'.tr}'
                                          : '${e.toString().replaceAll('-', 'B')} ${'층'.tr}';
                                      controller.townFloor.value = e;
                                      controller.townCategoryId.value = 0;
                                      controller.townCategoryTxt.value =
                                          '전체'.tr;
                                      Get.back();
                                    },
                                    title: Text(
                                      e + 1 < 4
                                          ? '${e.toString().replaceAll('-', 'B')} ${'123층'.tr}'
                                          : '${e.toString().replaceAll('-', 'B')} ${'층'.tr}',
                                      style: TextStyle(
                                        fontFamily: 'SF-Pro-Bold',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    height: 0.5,
                                    thickness: 0.5,
                                  )
                                ],
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> showSelectCategory(BuildContext context) async {
    return await showBarModalBottomSheet(
        barrierColor: Colors.black26,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(CommonRadius.m),
                topRight: Radius.circular(CommonRadius.m))),
        context: context,
        builder: (context) {
          return SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Column(
                        children: [
                          ListTile(
                            onTap: () {
                              controller.townCategoryTxt.value = '전체'.tr;
                              controller.townCategoryId.value = 0;
                              Get.back();
                            },
                            title: Text(
                              '전체'.tr,
                              style: TextStyle(
                                fontFamily: 'SF-Pro-Bold',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Divider(
                            height: 0.5,
                            thickness: 0.5,
                          ),
                          ...controller.mapCategory
                              .where((element) => controller.mapData
                                  .where((element2) =>
                                      element2.parent_id ==
                                          controller.selectedLocation.value
                                              ?.locationId &&
                                      (controller.townFloor.value == 0 ||
                                          element2.location_floor ==
                                              controller.townFloor.value))
                                  .map((e1) => e1.locationCategoryId)
                                  .contains(element.locationCategoryId))
                              .map((e) => Column(
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          controller.townCategoryTxt.value =
                                              e.categoryName!;
                                          controller.townCategoryId.value =
                                              e.locationCategoryId as int;
                                          Get.back();
                                        },
                                        title: Text(
                                          e.categoryName ?? '',
                                          style: TextStyle(
                                            fontFamily: 'SF-Pro-Bold',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        height: 0.5,
                                        thickness: 0.5,
                                      )
                                    ],
                                  )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
