
import 'package:findus/constants/common_sizes.dart';
import 'package:findus/model/work/Work_model.dart';
import 'package:findus/modules/app/app.dart';
import 'package:findus/modules/board/board_controller.dart';
import 'package:findus/modules/work/loadingWidget/work_detail_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../commonWidgets/work_update.dart';
import '../work_controller.dart';

class WorkListLoading extends GetView<WorkController> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BoardController boardController = Get.put(BoardController());

  @override
  Widget build(BuildContext context) {
    var format = NumberFormat('###,###,###,###');
    controller.context = context;
    return  Scaffold(
      key: _scaffoldKey,
      body: GestureDetector(
        onTap: () {
          controller.searchInputBoxNode.unfocus();
        },
        onTapDown: (e) {
          controller.searchInputBoxNode.unfocus();
        },
        child: Scaffold(
          body: Obx(
                () => Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    key: refreshKey,
                    onRefresh: () async {
                      await controller.getWorkList();
                    },
                    child:
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Stack(
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior
                                .onDrag,
                            itemCount: controller.workList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  controller.getWorkDetail(
                                      controller.workList[index]
                                          .workId!);
                                  Get.to(() => WorkDetailLoding(
                                      controller.workList[index]
                                          .workId));
                                },
                                child: ListTile(
                                  title: Column(
                                    children: [
                                      const SizedBox(
                                        height: CommonGap.m,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Container(
                                            height: CommonGap.m,
                                            decoration: BoxDecoration(
                                                color:
                                                Colors.white,
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    10),
                                                border: Border.all(
                                                    color: Colors
                                                        .white,
                                                    width: 3)),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "${controller.workList[index].userNickname}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .w500,
                                                      fontSize:
                                                      10,
                                                      color: Colors
                                                          .black,
                                                      fontFamily:
                                                      'SF-Pro-Regular'),
                                                ),
                                                SizedBox(
                                                  width: CommonGap
                                                      .xxs,
                                                ),
                                                Text(
                                                  "${controller.workList[index].createDate}",
                                                  style: const TextStyle(
                                                      fontSize:
                                                      10,
                                                      color: Colors
                                                          .grey,
                                                      fontFamily:
                                                      'SF-Pro-Regular'
                                                    // fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: CommonGap
                                                      .xxs,
                                                ),
                                                SvgPicture.asset(
                                                  'assets/find_us_images/common/eye-solid.svg',
                                                  height: 10,
                                                  width: 10,
                                                  color: HexColor(
                                                      '#AAAAAA'),
                                                ),
                                                const SizedBox(
                                                  width: CommonGap
                                                      .xxxxs,
                                                ),
                                                Text(
                                                  "${controller.workList[index].views}",
                                                  style: const TextStyle(
                                                      fontSize:
                                                      10,
                                                      color: Colors
                                                          .grey,
                                                      fontFamily:
                                                      'SF-Pro-Regular'
                                                    // fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: CommonGap.m,
                                            decoration: BoxDecoration(
                                                color:
                                                Colors.white,
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    10),
                                                border: Border.all(
                                                    color: Colors
                                                        .white,
                                                    width: 3)),
                                            child: Text(
                                              "${controller.workList[index].endDate}",
                                              style: const TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .bold,
                                                  fontSize: 10,
                                                  color: Colors
                                                      .blueAccent,
                                                  fontFamily:
                                                  'SF-Pro-Regular'),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    children: [
                                      const SizedBox(
                                        height: CommonGap.xxs,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width:
                                            Get.width / 1.1,
                                            height: CommonGap.m,
                                            decoration: BoxDecoration(
                                                color:
                                                Colors.white,
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    10),
                                                border: Border.all(
                                                    color: Colors
                                                        .white,
                                                    width: 3)),
                                            child: Text(
                                              overflow:
                                              TextOverflow
                                                  .ellipsis,
                                              "${controller.workList[index].subject}",
                                              style: const TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .w500,
                                                  fontSize: 18,
                                                  color: Colors
                                                      .black,
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
                                          Container(
                                            height: CommonGap.m,
                                            decoration: BoxDecoration(
                                                color:
                                                Colors.white,
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    10),
                                                border: Border.all(
                                                    color: Colors
                                                        .white,
                                                    width: 3)),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "${controller.workList[index].regionName}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .w500,
                                                      fontSize:
                                                      12,
                                                      color: Colors
                                                          .black,
                                                      fontFamily:
                                                      'SF-Pro-Regular'),
                                                ),
                                                const SizedBox(
                                                  width: CommonGap
                                                      .xs,
                                                ),
                                                Text(
                                                  '일당'.tr,
                                                  style:
                                                  const TextStyle(
                                                    color: Colors
                                                        .green,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                Text(
                                                  '${controller.workList[index].workPay!= null ?format.format(controller.workList[index].workPay) : '' } ${'원'.tr}',
                                                  style:
                                                  const TextStyle(
                                                    color: Colors
                                                        .grey,
                                                    fontSize: 12,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: CommonGap.xxs,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Container(
                                            height: CommonGap.m,
                                            decoration: BoxDecoration(
                                                color:
                                                Colors.white,
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    10),
                                                border: Border.all(
                                                    color: Colors
                                                        .white,
                                                    width: 3)),
                                            child: Row(
                                              children: [
                                                controller
                                                    .categoryIcon[
                                                '${controller.workList[index].workCategoryId ?? 1 }' ] !,
                                                const SizedBox(
                                                  width: CommonGap
                                                      .xxxs,
                                                ),
                                                Text(
                                                  "${controller.workList[index].workCategoryName} ",
                                                  style: const TextStyle(
                                                      fontSize:
                                                      10,
                                                      color: Colors
                                                          .grey,
                                                      fontFamily:
                                                      'SF-Pro-Regular'
                                                    // fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: CommonGap
                                                      .xxxs,
                                                ),
                                                Container(
                                                  decoration:
                                                  BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors
                                                            .black12),
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        0),
                                                  ),
                                                  child: const Text(
                                                    '모집중',
                                                    style: TextStyle(
                                                        fontSize:
                                                        10,
                                                        color: Colors
                                                            .pinkAccent),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            decoration:
                                            BoxDecoration(
                                              border: Border.all(
                                                  color: Colors
                                                      .black12),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  0),
                                            ),
                                            child: Container(
                                              height: CommonGap.m,
                                              decoration: BoxDecoration(
                                                  color: Colors
                                                      .white,
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      10),
                                                  border: Border.all(
                                                      color: Colors
                                                          .white,
                                                      width: 3)),
                                              child: Row(
                                                children: const [
                                                  Padding(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        8.0),
                                                    child: Text(
                                                      '지원하기',
                                                      style: TextStyle(
                                                          fontSize:
                                                          12),
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .navigate_next,
                                                    color: Colors
                                                        .deepOrangeAccent,
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: CommonGap.m,
                                      )
                                    ],
                                  ),
                                  isThreeLine: true,
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context,
                                int index) =>
                                Container(
                                    height: 0.5,
                                    color: Colors.white,
                                    child: const Divider()),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  CommonGap.m),
                              child: FloatingActionButton(
                                heroTag: "workLoading",
                                onPressed: () {
                                  Get.to(() => WorkUpdatePage());
                                  controller.work.value =
                                      WorkData();
                                },
                                child: Icon(Icons.add),
                                backgroundColor:
                                Colors.blueAccent,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                    ,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
