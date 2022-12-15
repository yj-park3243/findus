import 'dart:io';
import 'package:findus/constants/words.dart';
import 'package:findus/core/storage_keys.dart';
import 'package:findus/firebase_options.dart';
import 'package:findus/modules/app/AppBinding.dart';
import 'package:findus/modules/app/app.dart';
import 'package:findus/modules/auth/auth_controller.dart';
import 'package:findus/modules/auth/login.dart';
import 'package:findus/modules/board/board_controller.dart';
import 'package:findus/modules/board/commonWidget/board_list.dart';
import 'package:findus/modules/work/work_controller.dart';
import 'package:findus/modules/intro/intro.dart';
import 'package:findus/modules/map/map_controller.dart';
import 'package:findus/modules/map/loation/map_page.dart';
import 'package:findus/modules/map/search/search_controller.dart';
import 'package:findus/modules/map/search/search_page.dart';
import 'package:findus/modules/setting/setting.dart';
import 'package:findus/modules/setting/setting_controller.dart';
import 'package:findus/routes.dart';
import 'package:findus/service/Storage_service.dart';
import 'package:findus/service/api_service.dart';
import 'package:findus/service/auth_service.dart';
import 'package:findus/service/firebase_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'constants/themes.dart';
import 'modules/wrong_app/check_version.dart';

final getIt = GetIt.instance;

void main({String? env}) async {
  env = env ?? 'dev';
  await GetStorage.init();
  await dotenv.load(fileName: '.env.$env');
  MobileAds.instance.initialize();
  MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
      testDeviceIds: ['83BD9AEF0FBDE3FB5597595FAD43B7FF' , '8ECD793DEBD7B68BE34A158476D0F586']));

  await Get.putAsync(() => FirebaseService().init());
  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => ApiService().init());
  await Get.putAsync(() => StorageService().init());
  Get.put(AuthController());
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized(); //비동기
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]); //세로모드로 고정
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,

    // Status bar brightness (optional)
    statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
    statusBarBrightness: Brightness.light, // For iOS (dark icons)
  ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());

  runApp(const MyApp(
    state: Routes.INTRO,

  ));
}

class MyApp extends StatelessWidget {
  final String state;

  const MyApp({required this.state, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appData = GetStorage();
    //디바이스 언어에 따라 언어설정
    Locale locale = Get.deviceLocale.toString().contains('ko')
        ? const Locale('ko')
        : Get.deviceLocale.toString().contains('en') ? const Locale('en') : const Locale('mn');
    //앱 설정값에 따라 언어설정
    final language = appData.read(StorageKeys.LANGUAGE);
    if (language != null) {
      locale = Locale(language);
    } else {
      appData.write(StorageKeys.LANGUAGE, 'mn');
    }

    //setLocaleMessages('mn', KoMessages());

    FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    return GetMaterialApp(
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
      translations: Words(),
      // 번역들
      locale: locale,
      fallbackLocale: const Locale('mn'),

      // 잘못된 지역이 선택된 경우 복구될 지역을 지정
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [
        Locale('ko', 'KO'),
        Locale('en', 'US'),
        Locale('mn', 'MN'),
      ],

      theme: lightTheme,

      builder: (context, _) {
        var child = _!;
        final navigatorKey = child.key as GlobalKey<NavigatorState>;

        child = Toast(
          navigatorKey: navigatorKey,
          alignment: const Alignment(0, 0.8),
          child: child,
        );
        return child;
      },

      initialRoute: state,

      getPages: [
        GetPage(
          name: Routes.VERSION_CHECK,
          page: () => CheckVersion(),
        ),
        GetPage(
            name: Routes.INTRO,
            page: () => Intro(),
            transition: Transition.rightToLeft,
            transitionDuration: Duration(milliseconds: 200)),
        GetPage(
            name: Routes.LOGIN,
            page: () => const Login(),
            transition: Transition.topLevel,
            transitionDuration: Duration(milliseconds: 200)),
        GetPage(
            name: Routes.MAP,
            page: () => MapPage(),
            binding: BindingsBuilder(
              () => {Get.put(MapController())},
            ),
            transition: Transition.circularReveal,
            transitionDuration: Duration(milliseconds: 200)),
        GetPage(
            name: Routes.MAP_SEARCH,
            page: () => MapSearchPage(),
            binding: BindingsBuilder(() => {Get.put(SearchController())}),
            transition: Transition.rightToLeft,
            transitionDuration: Duration(milliseconds: 200)),
        GetPage(
            name: Routes.APP,
            page: () => App(),
            binding: AppBinding(),
            transition: Transition.circularReveal,
            transitionDuration: Duration(milliseconds: 200)),
        GetPage(
            name: Routes.WORK,
            page: () => const Login(),
            transition: Transition.circularReveal,
            transitionDuration: Duration(milliseconds: 200)),
        GetPage(
            name: Routes.Board,
            page: () => BoardList(),
            binding: BindingsBuilder(() {
              Get.put(BoardController());
              Get.put(WorkController());
            }),
            transition: Transition.circularReveal,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: Routes.SETTING,
            page: () => Setting(),
            binding: BindingsBuilder(() => {Get.put(SettingController())}),
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: Routes.VERSION_CHECK,
            page: () => CheckVersion(),
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 200)),
      ],
    );
  }
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}