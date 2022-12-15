import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:findus/constants/common_sizes.dart';
import 'package:findus/constants/style.dart';
import 'package:findus/modules/board/commonWidget/board_drawer.dart';
import 'package:findus/modules/board/board_controller.dart';
import 'package:findus/modules/board/loadingWidget/board_list_loading.dart';
import 'package:findus/modules/work/commonWidgets/work_list.dart';
import 'package:findus/modules/work/work_controller.dart';
import 'package:findus/modules/board/commonWidget/board_list_best.dart';
import 'package:findus/modules/board/commonWidget/board_list_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../helper/validator_util.dart';
import '../../app/app_controller.dart';

class BoardList extends GetView<BoardController> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final appController = Get.find<AppController>();
  WorkController workController = Get.put(WorkController());

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Obx(() => controller.selectedBoardCategory.value != 3
        ? DefaultTabController(
            length: 2,
            child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                centerTitle: true,
                title: Text(controller.boardTitle.value,
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
                      onPressed: () {
                        controller.showSearchBox();
                      },
                      color: Colors.black,
                      icon: const Icon(
                        Icons.search,
                        size: 30,
                      )),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size(24, 24),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 1,
                    indicatorColor: Colors.black12,
                    tabs: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '전체'.tr,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: 'SF-Pro-Regular'),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '인기'.tr,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: 'SF-Pro-Regular'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              drawer: BoardDrawer(),
              body: Scaffold(
                body: Column(
                  children: [
                    const SizedBox(
                      height: CommonGap.s,
                    ),
                    controller.search.value == true
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: CommonGap.m, right: CommonGap.m),
                            child: TextFormField(
                              style: const TextStyle(fontSize: 12),
                              controller: controller.searchTxtController,
                              focusNode: controller.searchInputBoxNode,
                              decoration: InputDecoration(
                                hintText: "관심있는_글_검색".tr,
                                hintStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.search,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    if (DefaultTabController.of(controller
                                                .context as BuildContext)
                                            ?.index ==
                                        0) {
                                      controller.getBoardList();
                                    } else {
                                      controller.getBestBoardList();
                                    }
                                  },
                                ),
                                prefixIcon: InkWell(
                                    onTap: () {
                                      controller.searchTxtController.clear();
                                      if (DefaultTabController.of(controller
                                                  .context as BuildContext)
                                              ?.index ==
                                          0) {
                                        controller.getBoardList();
                                      } else {
                                        controller.getBestBoardList();
                                      }
                                    },
                                    child: const Icon(
                                      EvaIcons.arrowIosBackOutline,
                                      color: Colors.black,
                                      size: 25,
                                    )),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: validateComment(),
                            ),
                          )
                        : const SizedBox(),
                    Expanded(
                      child: controller.enabled.value ||
                              appController.enabled.value
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: TabBarView(
                                children: [
                                  BoardListLoading(),
                                  BoardListLoading()
                                ],
                              ),
                            )
                          : TabBarView(
                              children: [BoardListNew(), BoardListBest()],
                            ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : WorkList());
  }
}
