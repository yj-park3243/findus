import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:findus/helper/resize_image.dart';
import 'package:findus/model/BanUser.dart';
import 'package:findus/model/user.dart';
import 'package:findus/modules/app/app_controller.dart';
import 'package:findus/modules/map/map_controller.dart';
import 'package:findus/modules/wrong_app/pizza.dart';
import 'package:findus/routes.dart';
import 'package:findus/service/api_service.dart';
import 'package:findus/service/auth_service.dart';
import 'package:findus/service/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:image/image.dart';
import '../../constants/common_sizes.dart';
import '../../constants/storage_keys.dart';

class SettingController extends GetxController {
  BuildContext? context;
  final auth = Get.find<AuthService>();
  final api = Get.find<ApiService>();
  final ImagePicker picker = ImagePicker();
  final FirebaseAuth fire = FirebaseAuth.instance;
  var isLoadingProfile = false.obs;
  late TextEditingController nickName = TextEditingController();
  late TextEditingController email = TextEditingController();
  var enabledNickName = false.obs;
  var enabledEmail = false.obs;
  final fs = Get.find<FirebaseService>();
  final String? rc = Get.arguments?['rc'];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  MapController mapController = Get.put(MapController());

  @override
  void onClose() {
    final appController = Get.find<AppController>();

    appController.bottomNavigationLogSetScreen();

    super.onClose();
  }

  @override
  void onInit() async {
    final packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = "v ${packageInfo.version}";

    nickName.addListener(nickNameListener);

    language.value = Get.locale!.languageCode;
    languageSelected.value = Get.locale!.languageCode;
    ever(language, (String? value) {
      if (value != null) {
        Get.updateLocale(Locale(value));
        appData.write(StorageKeys.language, value);
      }
    });
    super.onInit();
  }

  final appData = GetStorage();

  var language = 'ko'.obs;
  var languageSelected = 'ko'.obs;
  var appVersion = ''.obs;

  @override
  void onReady() {
    super.onReady();
  }

  void nickNameListener() {
    if (nickName.text.isEmpty) {}
  }
  
  var banUserList = <BanUser>[].obs;

  Future<void> banUser() async {

    final rst = await api.getWithHearder("/user/ban");
    BanUserResult banUser = BanUserResult.fromJson(rst.data['payload']);
    banUserList.value = [...banUser.result.map((e) => e).toList()];
  }

//게시판 수정
  Future<void> deleteBan(int ban_id) async {
    var data = {"ban_id": ban_id};
    final rst = await api.postWithHearder("/user/ban/delete", data: data);
    Get.snackbar('알림'.tr, '차단_해제되었습니다'.tr);
    await banUser();
  }

  void profileUpload(BuildContext context, XFile image) async {
    isLoadingProfile.value = true;
    final resizedImage = await compute(imageResize, image);
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = '${tempDir.path}/temp_profile.jpg';
    File(tempPath).writeAsBytesSync(encodeJpg(resizedImage));
    try {
      var formData = dio.FormData.fromMap({
        'file':
            await dio.MultipartFile.fromFile(tempPath, filename: 'profile.jpg'),
        'auth_token': _auth.currentUser?.uid
      });
      var res = await api.postWithHearder('/user/profile', data: formData);
      _auth.currentUser?.updatePhotoURL(res.data['payload']['profileUrl']);
      Map<String, dynamic>? map = auth.user?.toJson();
      map!['profile_url'] = res.data['payload']['profileUrl'];
      auth.user.value = Client.fromJson(map);
    } catch (e) {}
    isLoadingProfile.value = false;
  }

  Future<void> submitNickName(BuildContext context) async {
    if (nickName.text.isEmpty) {
      Get.snackbar('알림', 'my_info_name_error_message'.tr);
    } else if (nickName.text.length > 10) {
      Get.snackbar('알림', '10글자 이상은 입력할 수 없습니다.');
    } else if (nickName.text.length < 1) {
      Get.snackbar('알림', '2글자 이상 입력할 수 있습니다.');
    } else {
      try {
        final data = {
          "auth_token": _auth.currentUser?.uid,
          "user_nickname": nickName.text
        };
        final res = await api.postWithHearder('/user', data: data);
        if (res.statusCode == 200) {
          _auth.currentUser!.updateDisplayName(nickName!.text);
          auth.user.value?.user_nickname = nickName!.text;
          enabledNickName.value = false;
          Get.snackbar('알림'.tr, '닉네임이_저장되었습니다'.tr);
          FocusScope.of(context).unfocus();
        } else {
          throw ('fail');
        }
      } catch (e) {
        context.showToast('error_message'.tr);
      }
    }
  }

  void editNickName() {
    enabledNickName.value = true;
  }

  void onLogoutBtn() {
    fire.signOut();
    auth.logOut();
    FacebookLogin().logOut();
    auth.user.value = Client();
    Get.toNamed(Routes.LOGIN);
  }

  Future<void> languagePopUp(context) async {
    return showMaterialModalBottomSheet(
      expand: false,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(CommonRadius.m),
              topRight: Radius.circular(CommonRadius.m))),
      // barrierColor: Colors.black12,
      context: context,
      builder: (context) {
        return Obx(
          () => Padding(
            padding:
                const EdgeInsets.only(top: 30, bottom: 40, left: 20, right: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '언어_설정'.tr,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      languageSelected.value = 'mn';
                      yongJu(1);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Монгол хэл',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SF-Pro-Regular'),
                        ),
                        languageSelected.value == 'mn'
                            ? const Icon(
                                Icons.check,
                                color: Colors.black,
                              )
                            : const SizedBox(),
                        // Icon(Icons.check_box)
                      ],
                    )),
                const Divider(),
                TextButton(
                    onPressed: () {
                      languageSelected.value = 'en';
                      yongJu(2);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'English',
                          style: TextStyle(color: Colors.black),
                        ),
                        languageSelected.value == 'en'
                            ? const Icon(
                                Icons.check,
                                color: Colors.black,
                              )
                            : const SizedBox(),
                        // Icon(Icons.check_box)
                      ],
                    )),
                const Divider(),
                TextButton(
                    onPressed: () {
                      languageSelected.value = 'ko';
                      yongJu(3);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '한국어',
                          style: TextStyle(color: Colors.black),
                        ),
                        languageSelected.value == 'ko'
                            ? const Icon(
                                Icons.check,
                                color: Colors.black,
                              )
                            : const SizedBox(),
                      ],
                    )),
                const SizedBox(
                  height: CommonGap.m,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                          height: 40,
                          child: OutlinedButton(
                              onPressed: () {
                                cancelLanguageAndCurrency();
                              },
                              child: Text(
                                '취소'.tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SF-Pro-Bold',
                                ),
                              ))),
                    ),
                    const SizedBox(
                      width: 19,
                    ),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                              onPressed: () {
                                changeLanguageAndCurrency();
                              },
                              child: Text(
                                '저장'.tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SF-Pro-Bold',
                                ),
                              ))),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> logOutPopUp(context) async {
    return showMaterialModalBottomSheet(
      expand: false,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(CommonRadius.m),
              topRight: Radius.circular(CommonRadius.m))),
      // barrierColor: Colors.black12,
      context: context,
      builder: (context) {
        return Padding(
          padding:
              const EdgeInsets.only(top: 30, bottom: 40, left: 20, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '로그아웃'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: CommonGap.m,
              ),
              const Divider(),
              const SizedBox(
                height: CommonGap.m,
              ),
              Text(
                '정말로_로그아웃_하시겠습니까'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: CommonGap.xxxl,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 40,
                      child: OutlinedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            '취소'.tr,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SF-Pro-Bold',
                            ),
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: CommonGap.m,
                  ),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: onLogoutBtn,
                        child: Text(
                          '로그아웃'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SF-Pro-Bold',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void changeLanguageAndCurrency() {
    language.value = languageSelected.value;
    mapController.getLocation();
    Get.back();
  }

  void cancelLanguageAndCurrency() {
    languageSelected.value = language.value;
    Get.back();
  }

  var idx = 0;
  var cake = [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3];
  void yongJu(int num){
    idx = cake[idx] == num? idx+1 :0;
    print(idx);
    if(idx == cake.length){
      Get.to(()=>Pizza());
      idx = 0;
    }
  }
}
