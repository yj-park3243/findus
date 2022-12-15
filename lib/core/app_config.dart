import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppConfig extends GetxService {
  final String ENV_MODE;
  final String API_URL;
  final String JWT_SECRET_KEY;
  final String IOS_APP_ID;
  final String TOPIC;
  final String AOS_BANNER_ID;
  final String IOS_BANNER_ID;

  AppConfig(
      {
      required this.ENV_MODE,
      required this.API_URL,
      required this.JWT_SECRET_KEY,
      required this.IOS_APP_ID,
      required this.TOPIC,
      required this.AOS_BANNER_ID,
      required this.IOS_BANNER_ID,
      });

  getConfig() => {
        'ENV_MODE': ENV_MODE,
        'API_URL': API_URL,
        'JWT_SECRET_KEY': JWT_SECRET_KEY,
        'IOS_APP_ID': IOS_APP_ID,
        'TOPIC': TOPIC,
        'AOS_BANNER_ID': AOS_BANNER_ID,
        'IOS_BANNER_ID': IOS_BANNER_ID,
      };

  static Future<AppConfig> forEnvironment(String? env) async {
    env = env ?? 'dev';

    final contents = await rootBundle.loadString(
      'assets/config/$env.json',
    );

    final json = jsonDecode(contents);

    return AppConfig(
        ENV_MODE: json['ENV_MODE'],
        API_URL: json['API_URL'],
        JWT_SECRET_KEY: json['JWT_SECRET_KEY'],
        IOS_APP_ID: json['IOS_APP_ID'],
        TOPIC: json['TOPIC'],
        AOS_BANNER_ID: json['AOS_BANNER_ID'],
        IOS_BANNER_ID: json['IOS_BANNER_ID']
    );
  }
}
