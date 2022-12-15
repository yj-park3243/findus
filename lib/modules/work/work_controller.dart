import 'package:findus/constants/common_sizes.dart';
import 'package:findus/constants/my_flutter_app_icons.dart';
import 'package:findus/model/work/Work_category.dart';
import 'package:findus/model/work/Work_model.dart';
import 'package:findus/modules/work/commonWidgets//work_update.dart';
import 'package:findus/service/api_service.dart';
import 'package:findus/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_selector/selector_item.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class WorkController extends GetxController {
  TextEditingController searchTxtController = TextEditingController();
  FocusNode searchInputBoxNode = FocusNode();
  BuildContext? context;
  var region = <Region>[].obs;
  var category = <Category>[].obs;
  var regionSelectorItem = <SelectorItem>[].obs;
  var categorySelectorItem = <SelectorItem>[].obs;
  final auth = Get.find<AuthService>();
  final api = Get.find<ApiService>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var expansionTileText = ''.obs;
  var expansionTileText_2 = ''.obs;
  var search = false.obs;
  var selectedWorkRegionId = 0.obs;
  var selectedWorkCategoryId = 0.obs;
  var popupMenuItemIndex = 0;
  var workList = <WorkData>[
    WorkData(),
    WorkData(),
    WorkData(),
    WorkData(),
    WorkData(),
    WorkData(),
    WorkData(),
    WorkData(),
    WorkData(),
    WorkData(),
    WorkData(),
    WorkData(),
    WorkData(),
    WorkData()
  ].obs;
  Rx<WorkData?> work = WorkData().obs;
  var page = 1;
  var isEnd = false;
  var before_work = true.obs;
  var workEnabled = true.obs;
  var workDetailEnabled = true.obs;
  var my_work = 0;

  ScrollController workScrollController = ScrollController();

  _scrollListener() {
    if (workScrollController.offset >=
            workScrollController.position.maxScrollExtent-70 &&
        !workScrollController.position.outOfRange &&
        !isEnd) {
      ++page;
      getWorkList();
    }
  }

  @override
  Future<void> onInit() async {
    workScrollController.addListener(_scrollListener);
    super.onInit();
  }

//게시판 카테고리 조회
  Future<void> getWorkCategory() async {
    try {
      if (_auth.currentUser == null || auth.getJwt() == null) return;
      final data = {
        "language":
            Get.locale?.languageCode == 'ko' ? 'en' : Get.locale?.languageCode
      };
      final res =
          await api.getWithHearder('/work/category', queryParameters: data);
      final Map<String, dynamic>? resData = res.data['payload'];
      if (resData != null) {
        WorkCategory newModel = WorkCategory.fromJson(resData);
        region.value = newModel.region!;
        category.value = newModel.category!;
        expansionTileText.value = region.value[0].regionName!;
        expansionTileText_2.value = category.value[0].workCategoryName!;
        regionSelectorItem.removeWhere((element) => true);
        categorySelectorItem.removeWhere((element) => true);
        for (int i = 0; i < region.length; i++) {
          regionSelectorItem.add(SelectorItem(
              id: region[i].workRegionId.toString(),
              name: region[i].regionName as String));
        }

        for (int i = 1; i < category.length; i++) {
          categorySelectorItem.add(SelectorItem(
              id: category[i].workCategoryId.toString(),
              name: category[i].workCategoryName as String));
        }
      }
      getWorkList();
    } catch (e) {
      print(e);
    }
  }

  void showSearchBox() {
    search.value = !search.value;
  }

//게시판 목록 조회
  Future<void> getWorkList() async {
    try {
      if (_auth.currentUser == null || auth.getJwt() == null) return;
      final data = {
        "work_region_id": selectedWorkRegionId.value,
        "work_category_id": selectedWorkCategoryId.value,
        "search_txt": searchTxtController.text,
        "before_work": before_work.value ? 0 : 1,
        "language":
            Get.locale?.languageCode == 'ko' ? 'en' : Get.locale?.languageCode,
        "curPage": page,
        "my_work": my_work,
        "auth_token": _auth.currentUser?.uid
      };
      final res = await api.getWithHearder('/work/list', queryParameters: data);
      final Map<String, dynamic>? resData = res.data['payload'];
      if (resData != null) {
        isEnd = res.data["payload"]["isEnd"];
        WorkModel newModel = WorkModel.fromJson(resData);
        if (page == 1) {
          workList.value = newModel.workData!;
        } else {
          workList.value = [...workList.value.toList(), ...?newModel.workData];
        }
      }

      Future.delayed(Duration(milliseconds: 500), () {
        workEnabled.value = false;
      });
    } catch (e) {
      print(e);
    }
  }

//게시판 상세 조회
  Future<void> getWorkDetail(int id) async {
    try {
      //workEnabled.value = true;
      final data = {
        "work_id": id,
        "language":
            Get.locale?.languageCode == 'ko' ? 'en' : Get.locale?.languageCode
      };
      final res =
          await api.getWithHearder('/work/detail', queryParameters: data);
      work.value = WorkData.fromJson(res.data["payload"]);
      Future.delayed(Duration(milliseconds: 300), () {
        workDetailEnabled.value = false;
      });
    } catch (e) {
      print(e);
    }
  }

//게시판 수정
  Future<void> writeWork(WorkData work) async {
    var data = work.toJson();
    data['auth_token'] = _auth.currentUser!.uid;
    data.remove("create_date");
    data.remove("user_nickname");
    data.remove("region_name");
    data.remove("update_date");
    data.remove("work_category_name");
    data.remove("use_yn");
    final rst = await api.postWithHearder("/work/write", data: data);
    getWorkDetail(rst.data["payload"]["work_id"]);
    page = 1;
    getWorkList();
  }

//일자리 삭제
  Future<void> deleteWorkById(int id) async {
    var data = {"auth_token": _auth.currentUser!.uid, "work_id": id};
    await api.postWithHearder("/work/delete", data: data);
    page = 1;
    getWorkList();
  }

  Future<void> recruitClose(WorkData work) async {
    var data = work.toJson();
    data['auth_token'] = _auth.currentUser!.uid;
    data.remove("create_date");
    data.remove("user_nickname");
    data.remove("region_name");
    data.remove("update_date");
    data.remove("work_category_name");
    data.remove("use_yn");
    var _toDay = DateTime.now().subtract(Duration(days: 1));
    print(_toDay.toString().split(" ")[0]);
    data['end_date'] = _toDay.toString().split(" ")[0];
    final rst = await api.postWithHearder("/work/write", data: data);
    getWorkDetail(rst.data["payload"]["work_id"]);
    page = 1;
    getWorkList();
  }

  onMenuItemSelected(int value, BuildContext context) async {
    popupMenuItemIndex = value;

    if (value == Options.edit.index) {
      if (_auth.currentUser!.uid == work.value?.authToken) {
        Get.to(() => WorkUpdatePage());
      }
    } else if (value == Options.delete.index) {
      if (_auth.currentUser!.uid == work.value?.authToken) {
        Get.back();
        Get.snackbar('알림'.tr, '삭제_완료'.tr);
        deleteWorkById(work.value?.workId as int); // 상태관리로 갱신 시킬 수 있음.
      }
    } else if (value == Options.block.index) {
      if (_auth.currentUser!.uid != work.value?.authToken) {
        await banUserDialog("${work.value?.authToken}");
      }
    }
  }

  Future<void> showSelectArea(BuildContext context) async {
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
                Padding(
                  padding: const EdgeInsets.all(CommonGap.m),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '지역을_선택해주세요'.tr,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ...region.value.map((e) => Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  expansionTileText.value = e.regionName!;
                                  selectedWorkRegionId.value = e.workRegionId!;
                                  Get.back();
                                  getWorkList();
                                },
                                leading: Container(
                                  height: double.infinity,
                                  child: const Icon(
                                    MyFlutterApp.map,
                                    size: 16,
                                  ),
                                ),
                                minLeadingWidth: 10,
                                title: Text(
                                  '${e.regionName}',
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
                ),
              ],
            ),
          );
        });
  }

  Future<void> showSelectJob(BuildContext context) async {
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
                Padding(
                  padding: const EdgeInsets.all(CommonGap.m),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '업종을_선택해주세요'.tr,
                      style: const TextStyle(
                        fontFamily: 'SF-Pro-Regular',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ...category.value.map((e) => Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  expansionTileText_2.value =
                                      e.workCategoryName!;
                                  selectedWorkCategoryId.value =
                                      e.workCategoryId!;
                                  Get.back();
                                  getWorkList();
                                },
                                leading: Container(
                                  height: double.infinity,
                                  child: categoryIcon['${e.workCategoryId!}'],
                                ),
                                minLeadingWidth: 10,
                                title: Text(
                                  '${e.workCategoryName}',
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
                ),
              ],
            ),
          );
        });
  }

  Future<void> banUserDialog(String ban_user_token) async {
    await showDialog<String>(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          title: Column(
            children: [
              Row(
                children: [
                  Text(
                    '사용자를_차단_하시겠습니까'.tr,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(
                height: CommonGap.m,
              ),
              Text(
                "유저를_차단하면_해당_유저가_올린_글을_볼수_없게_됩니다_차단_하시겠습니까".tr,
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Get.back();
              },
              child: Text('취소_버튼'.tr),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                banUser('${ban_user_token}');
              },
              child: Text('사용자_차단'.tr),
            ),
          ],
        );
      },
    );
  }

  //게시판 수정
  Future<void> banUser(String auth_token) async {
    var data = {"vanUserToken": auth_token};
    final rst = await api.postWithHearder("/user/ban", data: data);
    page = 1;
    getWorkList();
    Get.back();
    Get.snackbar('알림'.tr, '차단_되었습니다'.tr);
  }

  var categoryIcon = {
    "0": const Icon(
      Icons.work,
      size: 16,
    ),
    "1": const Icon(
      Icons.factory,
      size: 16,
    ),
    "2": const Icon(
      Icons.cleaning_services,
      size: 16,
    ),
    "3": const Icon(
      Icons.fastfood_sharp,
      size: 16,
    ),
    "4": const Icon(
      Icons.move_up,
      size: 16,
    ),
    "5": const Icon(
      Icons.fire_truck_sharp,
      size: 16,
    ),
    "6": const Icon(
      Icons.work_outline,
      size: 16,
    ),
    "7": const Icon(
      Icons.hotel,
      size: 16,
    ),
    "8": const Icon(
      Icons.coffee,
      size: 16,
    ),
    "9": const Icon(
      Icons.work,
      size: 16,
    ),
    "10": const Icon(
      Icons.work,
      size: 16,
    ),
    "11": const Icon(
      Icons.work,
      size: 16,
    ),
    "12": const Icon(
      Icons.work,
      size: 16,
    ),
    "13": const Icon(
      Icons.work,
      size: 16,
    ),
    "14": const Icon(
      Icons.work,
      size: 16,
    )
  };

  var payList = [
    {"name": '100,000${'원'.tr}', "value": 100000},
    {"name": '120,000${'원'.tr}', "value": 120000},
    {"name": '140,000${'원'.tr}', "value": 140000},
    {"name": '160,000${'원'.tr}', "value": 160000},
    {"name": "기타".tr, "value": 0}
  ];
}

enum Options { edit, delete, block }