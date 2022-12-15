import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:findus/model/user.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {


  Future<AuthService> init() async {
    return this;
  }

  String? jwt;

  Rx<Client?> user = Client().obs;
  var savedMnemonicYn = false.obs;

  bool get isLogin {
    return (jwt != null && user != null);
  }

  String? get getXwt {
    if (jwt != null) {
      final jwt = JWT({"xtoken": "abcde"});
      return jwt.sign(SecretKey('9638ddbc7e36429c415c49eeb2d43ed7'));
    } else {
      return null;
    }
  }


  Future<void> setUser(User? currentUser) async {
    user.value = Client();
    user.value?.auth_token = currentUser?.uid;
    user.value?.email = currentUser?.email;
    user.value?.profile_url = currentUser?.photoURL;
    user.value?.user_nickname = currentUser?.displayName;
  }

  void setJwt(String newJwt) {
    jwt = newJwt;
  }

  String? getJwt() {
    return jwt;
  }

  void logOut() {
    jwt = null;
    user.value = Client();
  }


}
