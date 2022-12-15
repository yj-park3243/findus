import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:findus/constants/common_sizes.dart';
import 'package:findus/constants/my_flutter_app_icons.dart';
import 'package:findus/model/work/Work_model.dart';
import 'package:findus/modules/app/app.dart';
import 'package:findus/modules/board/commonWidget/board_drawer.dart';
import 'package:findus/modules/board/board_controller.dart';
import 'package:findus/modules/work/loadingWidget/work_detail_loading.dart';
import 'package:findus/modules/work/loadingWidget/work_list_loading.dart';
import 'package:findus/modules/work/commonWidgets/work_no_search_list.dart';
import 'package:findus/modules/work/commonWidgets/work_update.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../constants/style.dart';
import '../work_controller.dart';

class WorkList extends GetView<WorkController> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BoardController boardController = Get.put(BoardController());

  @override
  Widget build(BuildContext context) {
    var format = NumberFormat('###,###,###,###');
    controller.context = context;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(boardController.boardTitle.value,
            style: tapMenuTitleTextStyle),
        leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
              controller.searchInputBoxNode.unfocus();
            },
            color: Colors.black,
            icon: const Icon(
              EvaIcons.menu,
              size: 30,
            )),
        actions: [
          IconButton(
              onPressed: () async {
                controller.showSearchBox();
              },
              icon: const Icon(
                Icons.search,
                size: 30,
              ))
        ],
      ),
      drawer: BoardDrawer(),
      body: Obx(
        () => Column(
          children: [
            if (controller.search.value == true)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: CommonGap.m, right: CommonGap.m),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 12),
                      controller: controller.searchTxtController,
                      focusNode: controller.searchInputBoxNode,
                      decoration: InputDecoration(
                        hintText: "관심있는_일자리_검색".tr,
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search,
                              size: 30, color: Colors.black),
                          onPressed: () {
                            controller.page = 1;
                            controller.getWorkList();
                            controller.searchInputBoxNode.unfocus();
                          },
                        ),
                        prefixIcon: InkWell(
                            onTap: () {
                              controller.searchTxtController.clear();
                              controller.page = 1;
                              controller.getWorkList();
                            },
                            child: const Icon(
                              EvaIcons.arrowIosBackOutline,
                              color: Colors.black,
                              size: 25,
                            )),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
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
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                  onTap: () {
                                    controller.showSelectArea(context);
                                    controller.searchInputBoxNode.unfocus();
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        MyFlutterApp.map,
                                        size: 16,
                                        color: Colors.blueAccent,
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        controller.expansionTileText.value,
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
                                    controller.showSelectJob(context);
                                    controller.searchInputBoxNode.unfocus();
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.work,
                                        size: 16,
                                        color: Colors.blueAccent,
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Text(controller.expansionTileText_2.value,
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
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              const SizedBox(),
            const SizedBox(
              height: CommonGap.xs,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: CommonGap.s, left: CommonGap.s),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      /*Text(
                                    '최신순'.tr,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Icon(
                                    EvaIcons.arrowIosDownwardOutline,
                                    size: 14,
                                  )*/
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: CommonGap.m,
                        width: CommonGap.xxxl,
                        child: Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.blueAccent,
                          value: controller.before_work.value,
                          onChanged: (bool? value) {
                            controller.before_work.value =
                                !controller.before_work.value;
                            controller.page = 1;
                            controller.getWorkList();
                          },
                        ),
                      ),
                      Text(
                        '모집중'.tr,
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: CommonGap.xs,
            ),
            Container(
              height: 0.5,
              color: Colors.white,
              child: const Divider(
                thickness: 0.5,
              ),
            ),
            Expanded(
                child: RefreshIndicator(
              key: refreshKey,
              onRefresh: () async {
                controller.page = 1;
                await controller.getWorkList();
              },
              child: Obx(() => !controller.workEnabled.value
                  ? (controller.workList.isNotEmpty
                      ? Stack(
                          children: [
                            ListView.separated(
                              controller: controller.workScrollController,
                              shrinkWrap: true,
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              itemCount: controller.workList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    controller.workDetailEnabled.value = true;
                                    controller.getWorkDetail(
                                        controller.workList[index].workId!);
                                    Get.to(() => WorkDetailLoding(
                                        controller.workList[index].workId));
                                  },
                                  child: ListTile(
                                    title: Column(
                                      children: [
                                        const SizedBox(
                                          height: CommonGap.xxs,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "${controller.workList[index].userNickname}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                      fontFamily:
                                                          'SF-Pro-Regular'),
                                                ),
                                                const SizedBox(
                                                  width: CommonGap.xxs,
                                                ),
                                                Text(
                                                  "${controller.workList[index].createDate}",
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey,
                                                      fontFamily:
                                                          'SF-Pro-Regular'
                                                      // fontStyle: FontStyle.italic,
                                                      ),
                                                ),
                                                const SizedBox(
                                                  width: CommonGap.xxs,
                                                ),
                                                SvgPicture.asset(
                                                  'assets/find_us_images/common/eye-solid.svg',
                                                  height: 10,
                                                  width: 10,
                                                  color: HexColor('#AAAAAA'),
                                                ),
                                                const SizedBox(
                                                  width: CommonGap.xxxs,
                                                ),
                                                Text(
                                                  "${controller.workList[index].views}",
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey,
                                                      fontFamily:
                                                          'SF-Pro-Regular'
                                                      // fontStyle: FontStyle.italic,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "${controller.workList[index].endDate} [${(controller.workList[index].dDay ?? 0) < 0 ? 'D${controller.workList[index].dDay ?? ''}' : '마감'}]",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                  color: (controller
                                                              .workList[index]
                                                              .isEnd ??
                                                          false)
                                                      ? Colors.blueAccent
                                                      : Colors.blueGrey,
                                                  fontFamily: 'SF-Pro-Regular'),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: CommonGap.xxs,
                                        ),
                                      ],
                                    ),
                                    subtitle: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: Get.width * 90 / 100,
                                              child: Text(
                                                overflow: TextOverflow.ellipsis,
                                                "${controller.workList[index].subject}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18,
                                                    color: (controller
                                                                .workList[index]
                                                                .isEnd ??
                                                            false)
                                                        ? Colors.black
                                                        : Colors.grey,
                                                    fontFamily:
                                                        'SF-Pro-Regular'),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: CommonGap.xxs,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${controller.workList[index].regionName}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontFamily: 'SF-Pro-Regular'),
                                            ),
                                            const SizedBox(
                                              width: CommonGap.xxs,
                                            ),
                                            Text(
                                              '일당'.tr,
                                              style: const TextStyle(
                                                color: Colors.green,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: CommonGap.xxxxs,
                                            ),
                                            Text(
                                              '${format.format(controller.workList[index].workPay)}''${'원'.tr}',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                controller.categoryIcon[
                                                    '${controller.workList[index].workCategoryId}']!,
                                                const SizedBox(
                                                  width: CommonGap.xxxs,
                                                ),
                                                Text(
                                                  "${controller.workList[index].workCategoryName} ",
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey,
                                                      fontFamily:
                                                          'SF-Pro-Regular'
                                                      // fontStyle: FontStyle.italic,
                                                      ),
                                                ),
                                                const SizedBox(
                                                  width: CommonGap.xxs,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      border: Border.all(
                                                          color:
                                                              Colors.black12)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            CommonGap.xxxxs),
                                                    child: Text(
                                                      (controller
                                                                  .workList[
                                                                      index]
                                                                  .isEnd ??
                                                              false)
                                                          ? '모집중_2'.tr
                                                          : '마감_게시판'.tr,
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: (controller
                                                                      .workList[
                                                                          index]
                                                                      .isEnd ??
                                                                  false)
                                                              ? Colors
                                                                  .pinkAccent
                                                              : Colors
                                                                  .blueGrey),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black12),
                                                borderRadius:
                                                    BorderRadius.circular(0),
                                              ),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      '지원하기'.tr,
                                                      style: const TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.navigate_next,
                                                    color: Colors.blueAccent,
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    isThreeLine: true,
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.all(CommonGap.m),
                                child: FloatingActionButton(
                                  heroTag: "work",
                                  onPressed: () {
                                    Get.to(() => WorkUpdatePage());
                                    controller.work.value = WorkData();
                                  },
                                  child: const Icon(Icons.add),
                                  backgroundColor: Colors.blueAccent,
                                ),
                              ),
                            )
                          ],
                        )
                      : WorkListNoSearhList())
                  : WorkListLoading()),
            )),
          ],
        ),
      ),
    );
  }
}
