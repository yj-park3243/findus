import 'package:findus/constants/common_sizes.dart';
import 'package:findus/modules/map/loation/main_map.dart';
import 'package:findus/modules/map/map_controller.dart';
import 'package:findus/routes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../constants/my_flutter_app_icons.dart';
import '../../app/app.dart';
import '../search/mongol_town.dart';

class MapPage extends GetView<MapController> {
  bool isFocus = false;
  FocusNode searchInputBoxNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      body: Column(
        children: [
          // ElevatedButton(onPressed: () {
          //   Get.to(()=> MongolTown());
          // }, child: Text('dd')),
          map(),
        ],
      ),
    );
  }

  //naverMap
  map() {
    return Expanded(
      child: Stack(
        children: [
          FutureBuilder(
              future: controller.getLocation(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
                if (snapshot.hasData == false) {
                  return const SafeArea(
                    child: Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 10,
                      backgroundColor: Colors.cyanAccent,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                    )),
                  );
                }
                //error가 발생하게 될 경우 반환하게 되는 부분
                else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  );
                }
                // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                else {
                  return MainMap();
                }
              }),
          //검색 inputBox
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: Get.height * 5 / 100,
                  ),
                  Align(
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed(Routes.MAP_SEARCH);
                        },
                        autofocus: false,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          shadowColor: Colors.grey,
                          side: const BorderSide(
                            color: Colors.white,
                          ),
                          elevation: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset('assets/FindUs_color.png',width: 20),
                                const SizedBox(
                                  width: CommonGap.xs,
                                ),
                                Obx(() => Text(
                                      controller.searchTxt.value == ""
                                          ? '관심있는_장소_검색'.tr
                                          : controller.searchTxt.value,
                                      style: TextStyle(
                                        color: HexColor('#444444'),
                                        fontFamily: 'SF-Pro-Bold',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    )),
                              ],
                            ),
                            const Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: CommonGap.xxxs,
                  ),
                  //카테고리 버튼 List
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Obx(() => Row(
                          children: [
                            ...controller.mapCategory.map((e) {
                              return Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: ElevatedButton.icon(
                                    icon: SvgPicture.asset("assets/find_us_images/category/${e.categoryNameEn}.svg"),
                                    onPressed: () {
                                      controller.searchTxt.value =
                                          e.categoryName!;
                                      Get.toNamed(Routes.MAP_SEARCH);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 5,
                                      primary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      side: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    label: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        e.categoryName.toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ));
                            }).toList(),
                          ],
                        )),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
