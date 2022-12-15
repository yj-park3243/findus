import 'dart:async';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:findus/constants/common_sizes.dart';
import 'package:findus/model/board.dart';
import 'package:findus/model/boardCategory.dart';
import 'package:findus/model/comment.dart';
import 'package:findus/modules/app/app_controller.dart';
import 'package:findus/service/api_service.dart';
import 'package:findus/service/auth_service.dart';
import 'package:findus/service/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'commonWidget/board_update.dart';

class BoardController extends GetxController {
  BuildContext? context;
  TextEditingController searchTxtController = TextEditingController();
  TextEditingController reportController = TextEditingController();
  FocusNode searchInputBoxNode = FocusNode();
  final auth = Get.find<AuthService>();
  final api = Get.find<ApiService>();
  final FirebaseAuth fire = FirebaseAuth.instance;
  var isLoadingProfile = false.obs;
  final fs = Get.find<FirebaseService>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var boardCategory = <BoardCategory>[].obs;
  var selectedBoardCategory = 1.obs;

  Rx<BoardModel?> board = BoardModel().obs;
  var comment = <CommentModel>[].obs;
  var popupMenuItemIndex = 0;
  var search = false.obs;
  ScrollController scrollController = ScrollController();
  ScrollController boardScrollController = ScrollController();
  ScrollController bestBoardScrollController = ScrollController();

  var boardList = <BoardModel>[
    BoardModel(),
    BoardModel(),
    BoardModel(),
    BoardModel(),
    BoardModel(),
    BoardModel(),
    BoardModel(),
    BoardModel(),
    BoardModel(),
    BoardModel()
  ].obs;
  var bestBoardList = <BoardModel>[].obs;
  var boardPage = 1;
  var bestBoardPage = 1;
  var isBoardEnd = false;
  var isBestBoardEnd = false;
  var enabled = true.obs;
  var detailEnabled = true.obs;
  var boardTitle = '자유_게시판'.tr.obs;

  @override
  void onClose() {
    final appController = Get.find<AppController>();
    appController.bottomNavigationLogSetScreen();
    super.onClose();
  }

  @override
  Future<void> onInit() async {
    boardScrollController.addListener(_scrollListener);
    bestBoardScrollController.addListener(_bestScrollListener);
    super.onInit();
  }

  _scrollListener() {
    if (boardScrollController.offset >=
            boardScrollController.position.maxScrollExtent - 70 &&
        !boardScrollController.position.outOfRange &&
        !isBoardEnd) {
      ++boardPage;
      getBoardList();
    }
  }

  _bestScrollListener() {
    if (bestBoardScrollController.offset >=
            bestBoardScrollController.position.maxScrollExtent - 70 &&
        !bestBoardScrollController.position.outOfRange &&
        !isBestBoardEnd) {
      ++bestBoardPage;
      getBestBoardList();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

//게시판 카테고리 조회
  Future<void> getBoardCategory() async {
    Timer(const Duration(milliseconds: 5), () async {
      try {
        if (_auth.currentUser == null || auth.getJwt() == null) return;

        final data = {"language": Get.locale?.languageCode};
        final res =
            await api.getWithHearder('/board/category', queryParameters: data);
        BoardCategoryResult boardCategoryResult =
            BoardCategoryResult.fromJson(res.data["payload"]);
        boardCategory.value = boardCategoryResult.result.map((e) => e).toList();
        selectedBoardCategory.value = boardCategory[0].board_category_id;
        getBoardList();
        getBestBoardList();
      } catch (e) {
        print(e);
      }
    });
  }

  void showSearchBox() {
    search.value = !search.value;
  }

//게시판 목록 조회
  Future<void> getBoardList() async {
    try {
      if (_auth.currentUser == null ||
          auth.getJwt() == null ||
          selectedBoardCategory.value == 3) return;
      final data = {
        "board_category_id": selectedBoardCategory.value,
        "search_txt": searchTxtController.text,
        "auth_token": _auth.currentUser!.uid,
        "curPage": boardPage
      };
      Future.delayed(const Duration(milliseconds: 500), () {
        enabled.value = false;
      });
      final res =
          await api.getWithHearder('/board/list', queryParameters: data);
      BoardResult boardResult = BoardResult.fromJson(res.data["payload"]);
      isBoardEnd = res.data["payload"]["isBoardEnd"];
      if (boardPage == 1) {
        boardList.value = [...boardResult.result.map((e) => e).toList()];
      } else {
        boardList.value = [
          ...boardList.value,
          ...boardResult.result.map((e) => e).toList()
        ];
      }
    } catch (e) {
      print(e);
    }
  }

//게시판 목록 조회
  Future<void> getBestBoardList() async {
    try {
      if (_auth.currentUser == null ||
          auth.getJwt() == null ||
          selectedBoardCategory.value == 3) return;
      final data = {
        "board_category_id": selectedBoardCategory.value,
        "search_txt": searchTxtController.text,
        "curPage": bestBoardPage,
        "auth_token": _auth.currentUser!.uid,
        "is_best": 1
      };
      final res =
          await api.getWithHearder('/board/list', queryParameters: data);
      BoardResult boardResult = BoardResult.fromJson(res.data["payload"]);
      isBestBoardEnd = res.data["payload"]["isBoardEnd"];
      if (bestBoardPage == 1) {
        bestBoardList.value = [...boardResult.result.map((e) => e).toList()];
      } else {
        bestBoardList.value = [...bestBoardList.value, ...boardResult.result];
      }
      Future.delayed(const Duration(milliseconds: 500), () {
        enabled.value = false;
      });
    } catch (e) {
      print(e);
    }
  }

//게시판 상세 조회
  Future<void> getBoardDetail(int id, int categoryId) async {
    try {
      detailEnabled.value = true;
      final data = {
        "board_id": id,
        "board_category_id": categoryId,
        "auth_token": _auth.currentUser!.uid
      };
      final res =
          await api.getWithHearder('/board/detail', queryParameters: data);
      board.value = BoardModel.fromJson(res.data["payload"]["Board"]);
      comment.value = CommentResult.fromJson(res.data["payload"])
          .result
          .map((e) => e)
          .toList();
      Future.delayed(const Duration(milliseconds: 300), () {
        detailEnabled.value = false;
      });
    } catch (e) {
      print(e);
    }
  }

//게시판 수정
  Future<void> writeBoard(int id, String title, String content) async {
    var data = {
      "board_category_id": selectedBoardCategory.value,
      "subject": title,
      "content": content,
      "auth_token": _auth.currentUser!.uid,
      "nickname": _auth.currentUser!.displayName,
      "board_id": id,
      "use_yn": 1,
    };
    final rst = await api.postWithHearder("/board/write", data: data);
    getBoardDetail(
        rst.data["payload"]["board_id"], selectedBoardCategory.value);

    getBoardList();
  }

//게시판 삭제
  Future<void> deleteBoardById(int id) async {
    var data = {
      "board_category_id": selectedBoardCategory.value,
      "auth_token": _auth.currentUser!.uid,
      "board_id": id
    };
    final rst = await api.postWithHearder("/board/delete", data: data);
    getBoardList();
  }

  //댓글 삭제
  Future<void> deleteBoardByComment(
    int boardId,
    int commentId,
  ) async {
    var data = {
      "auth_token": _auth.currentUser!.uid,
      "comment_id": commentId,
      "board_id": boardId
    };
    await api.postWithHearder("/board/comment/delete", data: data);
    getBoardDetail(board.value!.board_id!, selectedBoardCategory.value);
  }

//좋아요 저장
  Future<bool> saveBoardLike(int board_id, bool? islike) async {
    var data = {
      "board_category_id": selectedBoardCategory.value,
      "auth_token": _auth.currentUser!.uid,
      "board_id": board_id
    };
    await api.postWithHearder("/board/like", data: data);
    //getBoardDetail(board.value!.board_id!, selectedBoardCategory.value);
    return !islike!;
  }

  //좋아요 저장
  Future<bool> saveCommentLike(
      int board_id, int board_category_id, int comment_id, bool? islike) async {
    var data = {
      "auth_token": _auth.currentUser!.uid,
      "board_id": board_id,
      "comment_id": comment_id,
      "board_category_id": board_category_id
    };
    await api.postWithHearder("/board/comment/like", data: data);
    //getBoardDetail(board.value!.board_id!, selectedBoardCategory.value);
    return !islike!;
  }

//댓글 작성
  Future<void> writeComment(int id, String comment) async {
    var data = {
      "board_category_id": board.value?.board_category_id,
      "board_id": board.value?.board_id,
      "comment_id": id,
      "auth_token": _auth.currentUser!.uid,
      "comment": comment,
      "nickname": _auth.currentUser!.displayName,
    };

    if (comment.isEmpty) {
      Get.snackbar('알림', '댓글엔_공백이_들어갈_수_없습니다'.tr);
    } else if (comment.length > 25) {
      Get.snackbar('알림', '25자_이내로_작성해주세요'.tr);
    } else {
      final rst = await api.postWithHearder("/board/comment", data: data);

      Get.snackbar('알림'.tr, '댓글이_작성되었습니다'.tr);
      FocusScope.of(Get.context!).unfocus();
      getBoardDetail(board.value!.board_id!, selectedBoardCategory.value);
      scrollToBottom();
    }
  }

//게시판 수정
  Future<void> banUser(String auth_token) async {
    var data = {"vanUserToken": auth_token};
    final rst = await api.postWithHearder("/user/ban", data: data);
    bestBoardPage = 1;
    boardPage = 1;
    getBoardList();
    getBestBoardList();
    Get.back();

    Get.snackbar('알림'.tr, '차단_되었습니다'.tr);
  }

  scrollToBottom() {
    if (scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 500)).then((value) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
        );
      });
    }
  }

//드로워 아이콘
  final iconArr = {
    "1": const Icon(EvaIcons.radioOutline),
    "2": const Icon(Icons.backup_table_outlined),
    "3": const Icon(Icons.account_balance_outlined),
    "4": const Icon(Icons.laptop_chromebook_rounded),
  };

  PopupMenuItem buildPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: Colors.black,
            size: 20,
          ),
          const SizedBox(
            width: CommonGap.xxs,
          ),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: 'SF-Pro-Heavy',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> commentErase(int board_id, int comment_id) async {
    // Update the UI - wait for the user to enter the SMS code
    await showDialog<String>(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          title: Text(
            '댓글을_삭제하시겠습니까'.tr,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await deleteBoardByComment(board_id, comment_id);
                Navigator.pop(context);
                Get.snackbar('알림'.tr, '댓글이_삭제되었습니다'.tr);
              },
              child: Text('네'.tr),
            ),
            OutlinedButton(
              onPressed: () {
                Get.back();
              },
              child: Text('아니오'.tr),
            ),
          ],
        );
      },
    );
  }

  Future<void> boardReport(int type, int id) async {
    // Update the UI - wait for the user to enter the SMS code
    await showDialog<String>(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          title: Column(
            children: [
              Text(
                '이_글을_신고하시겠습니까'.tr,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: CommonGap.m,
              ),
              TextFormField(
                  controller: reportController,
                  maxLines: 12,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    labelText: "신고하실_내용을_적어주세요".tr,
                    alignLabelWithHint: true,
                    floatingLabelStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    labelStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  )),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                reportController.text = "";
                Get.back();
              },
              child: Text('취소_버튼'.tr),
            ),
            ElevatedButton(
              onPressed: () async {
                saveReport(type, id, '', reportController.text);
                Navigator.pop(context);
              },
              child: Text('신고_버튼'.tr),
            ),
          ],
        );
      },
    );
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

  onMenuItemSelected(int value, BuildContext context) async {
    popupMenuItemIndex = value;

    if (value == Options.edit.index) {
      if (fire.currentUser!.uid == board.value?.auth_token) {
        Get.to(() => BoardUpdatePage());
      }
    } else if (value == Options.delete.index) {
      if (fire.currentUser!.uid == board.value?.auth_token) {
        //
        Get.back();
        Get.snackbar('알림'.tr, '삭제_완료'.tr);
        deleteBoardById(board.value?.board_id as int); // 상태관리로 갱신 시킬 수 있음.
      }
    } else if (value == Options.block.index) {
      if (fire.currentUser!.uid != board.value?.auth_token) {
        await banUserDialog("${board.value?.auth_token}");
      }
    }
  }

  //좋아요 저장
  Future<bool> saveReport(
      int type, int type_id, String title, String content) async {
    var data = {
      "report_type": type,
      "report_type_id": type_id,
      "report_title": title,
      "report_content": content,
      "auth_token": _auth.currentUser!.uid,
    };
    await api.postWithHearder("/report", data: data);
    Get.snackbar('알림'.tr, '신고가_정상적으로_접수되었습니다'.tr);
    reportController.text = "";
    //getBoardDetail(board.value!.board_id!, selectedBoardCategory.value);
    return true;
  }
}

enum Options { edit, delete, block }
