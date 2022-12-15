import 'dart:async';

import 'package:findus/modules/map/search/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/app.dart';
import '../map_controller.dart';

class MapSearchPage extends GetView<SearchController> {
  bool isFocus = false;
  final mapController = Get.find<MapController>();

  MapSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() => SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 0,
                              child: IconButton(
                                  onPressed: () {
                                    controller.searchNode.unfocus();
                                    controller.resetSearchTxt();

                                    Timer(const Duration(milliseconds: 100), () {
                                      Get.back(); //
                                    });
                                  },
                                  color: Colors.black,
                                  icon: const Icon(
                                    Icons.chevron_left,
                                    size: 30,
                                  ))),
                          Expanded(
                              flex: 2,
                              child: TextField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '검색어를_입력해주세요'.tr,
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: HexColor('#444444'),
                                        fontSize: 14,
                                        fontFamily: 'SF-Pro-Bold')),
                                controller: controller.searchTxt,
                                focusNode: controller.searchNode,
                                onChanged: (text) {
                                  controller.searchEvent(text);
                                },
                              )),
                          Expanded(
                            flex: 0,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: IconButton(
                                onPressed: () {
                                  if (mapController.searchTxt.value != "") {
                                    controller.resetSearchTxt();
                                  }
                                },
                                icon: mapController.searchTxt.value != ""
                                    ? const Icon(
                                        Icons.close,
                                        color: Colors.black,
                                        size: 30,
                                      )
                                    : const Icon(
                                        Icons.search,
                                        color: Colors.black,
                                        size: 30,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      children: [...controller.getSearchData(context)],
                    ),
                  ),
                ],
              ),
            )));
  }
}
// TextField(
// decoration: const InputDecoration(
// labelText: 'Input',
// border: OutlineInputBorder(
// borderRadius: BorderRadius.all(
// Radius.circular(20)),
// borderSide: BorderSide(),
// ),
// ),
