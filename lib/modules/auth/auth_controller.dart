import 'dart:io';

import 'package:findus/model/version.dart';
import 'package:findus/modules/auth/widgets/join_membership_1.dart';
import 'package:findus/modules/auth/widgets/join_membership_2.dart';
import 'package:findus/routes.dart';
import 'package:findus/service/api_service.dart';
import 'package:findus/service/auth_service.dart';
import 'package:findus/service/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final appData = GetStorage();
  BuildContext? context;
  final api = Get.find<ApiService>();
  final auth = Get.find<AuthService>();
  FocusNode searchInputBoxNode = FocusNode();

  final fs = Get.find<FirebaseService>();
  var isOnCloseApp = false;
  var isChecked = false.obs;
  var isChecked_2 = false.obs;
  var isLoading = false.obs;

  var validateEmail = "".obs;
  var validatePassword1 = "".obs;
  var validatePassword2 = "".obs;
  var validateNickname = "".obs;

  FirebaseService firebaseService = FirebaseService();

  @override
  void onInit() async {
    super.onInit();
  }

  void showCheckBox() {
    isChecked.value = !isChecked.value;
    if (isChecked.value = true) {
      Get.to(()=>JoinMemberShip_1(true));
    }
  }

  void showCheckBox_2() {
    isChecked_2.value = !isChecked_2.value;
    if (isChecked_2.value = true) {
      Get.to(()=>JoinMemberShip_2(true));
    }
  }

  Future<void> delay() async {}

  @override
  void onReady() {}

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  void saveLoginInfo(UserCredential value) async {
    Position position = await getCurrentLocation();
    var data = {
      "auth_token": value.user!.uid,
      //TODO: 접속 위도 경도
      'user_name': value.additionalUserInfo!.username,
      "user_nickname": value.user!.displayName,
      "profile_url": value.user!.photoURL,
      'user_email': value.user!.email,
      'email_verification': value.user?.emailVerified == true ? 1 : 0,
      'user_lat': position.latitude,
      'user_lng': position.longitude,
      'platform': Platform.isAndroid ? 'G' : 'A'
    };
    auth.setUser(value.user);

    final rst = await api.postWithHearder("/login", data: data);

    if (rst.statusCode == 200) {
      auth.setJwt(rst.data['payload']['result']);
      var versionList = <VersionModel>[].obs;
      VersionResult versionResult = VersionResult.fromJson(rst.data["payload"]);
      versionList.value = versionResult.result.map((e) => e).toList();
      Get.offAllNamed(Routes.APP);
    }
  }

  void saveLoginUser(User? value) async {
    var data = {
      "auth_token": value?.uid,
      //TODO: 접속 위도 경도
      "user_nickname": value?.displayName,
      "profile_url": value?.photoURL,
      'user_email': value?.email,
      'email_verification': value?.emailVerified == true ? 1 : 0
    };

    auth.setUser(value);
    final rst = await api.postWithHearder("/login", data: data);
    if (rst.statusCode == 200) {
      auth.setJwt(rst.data['payload']['result']);
      var versionList = <VersionModel>[].obs;
      VersionResult versionResult = VersionResult.fromJson(rst.data["payload"]);
      versionList.value = versionResult.result.map((e) => e).toList();
      Get.offAllNamed(Routes.APP);
    }
  }

  /// 회원가입
  Future<bool> checkNickName(String nickName, BuildContext context) async {
    final rst = await api.postWithHearder("/user/nickName/$nickName");
    return rst.data['payload']['value'];
  }

  /// 회원가입
  Future<bool> createUser(
      String email, String pw, String nickname, BuildContext context) async {
    try {
      isLoading.value = true;
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pw,
      );
      var data = {
        "auth_token": credential.user!.uid,
        //TODO: 접속 위도 경도
        'user_name': credential.additionalUserInfo!.username,
        "user_nickname": nickname,
        "profile_url": credential.user!.photoURL,
        'user_email': email,
        'email_verification': 0,
      };
      credential.user?.updateDisplayName(nickname);
      auth.setUser(credential.user);
      final rst = await api.postWithHearder("/login", data: data);
      await credential.user?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar('알림'.tr, '비밀번호가_양식에_맞지_않습니다'.tr);
        return false;
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar(
          '알림'.tr,
          '이미_등록된_이메일입니다'.tr,
        );
        return false;
      }
    } catch (e) {
      //logger.e(e);
      return false;
    }
    isLoading.value = false;
    // authPersistence(); // 인증 영속
    return true;
  }

  /// 로그인
  Future<bool> signIn(String email, String pw) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pw);
      await credential.user?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //logger.w('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        //logger.w('Wrong password provided for that user.');
      }
    } catch (e) {
      //logger.e(e);
      return false;
    }
    // authPersistence(); // 인증 영속
    return true;
  }

  /// 로그아웃
  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  /// 회원가입, 로그인시 사용자 영속
  void authPersistence() async {
    await FirebaseAuth.instance.setPersistence(Persistence.NONE);
  }

  /// 유저 삭제
  Future<void> deleteUser(String email) async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.delete();
  }

  /// 현재 유저 정보 조회
  User? getUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Name, email address, and profile photo URL
      final name = user.displayName;
      final email = user.email;
      final photoUrl = user.photoURL;

      // Check if user's email is verified
      final emailVerified = user.emailVerified;

      // The user's ID, unique to the Firebase project. Do NOT use this value to
      // authenticate with your backend server, if you have one. Use
      // User.getIdToken() instead.
      final uid = user.uid;
    }
    return user;
  }

  /// 공급자로부터 유저 정보 조회
  User? getUserFromSocial() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      for (final providerProfile in user.providerData) {
        // ID of the provider (google.com, apple.cpm, etc.)
        final provider = providerProfile.providerId;

        // UID specific to the provider
        final uid = providerProfile.uid;

        // Name, email address, and profile photo URL
        final name = providerProfile.displayName;
        final emailAddress = providerProfile.email;
        final profilePhoto = providerProfile.photoURL;
      }
    }
    return user;
  }

  /// 유저 이름 업데이트
  Future<void> updateProfileName(String name) async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.updateDisplayName(name);
  }

  /// 유저 url 업데이트
  Future<void> updateProfileUrl(String url) async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.updatePhotoURL(url);
  }

  /// 비밀번호 초기화 메일보내기
  Future<void> sendPasswordResetEmail(String email) async {
    await FirebaseAuth.instance.setLanguageCode("kr");
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
