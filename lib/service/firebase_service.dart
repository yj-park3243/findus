import 'package:findus/core/env.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class FirebaseService extends GetxService {

  Future<FirebaseService> init() async {
    return this;
  }


  FirebaseMessaging? messaging;
  FirebaseMessaging get fcm => messaging!;
  String? token;
  Rx<String> recommenderCode = ''.obs;
  Rx<String> recommenderName = ''.obs;
  bool alreayRecommenderCode = false;
  String topic = Env.topic;
  // Future<void> _firebaseMessagingBackgroundHandler(
  //     RemoteMessage message) async {
  //   // If you're going to use other Firebase services in the background, such as Firestore,
  //   // make sure you call `initializeApp` before using other Firebase services.
  //   await Firebase.initializeApp();

  //   print("Handling a background message: ${message.messageId}");
  // }



  Future<void> logSetScreen({String? screenName}) async {
    try {
      FirebaseAnalytics analytics = FirebaseAnalytics.instance;
      await analytics.setCurrentScreen(screenName: screenName);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> logSelectedContent({String? contentType, String? itemId}) async {
    try {
      FirebaseAnalytics analytics = FirebaseAnalytics.instance;
      await analytics.logSelectContent(
          contentType: contentType!, itemId: itemId!);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> walletStatusAnalyticsEvent(String shortName) async {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    await analytics.logEvent(
      name: 'ratioofwallet_$shortName',
      parameters: <String, dynamic>{
        'default': 'created',
      },
    );
  }


}
