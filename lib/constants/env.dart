import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static final bool devMode = dotenv.get('DEV_MODE') == 'true';
  static final String apiUrl = dotenv.get('API_URL');
  static final String jwtSecretKey = dotenv.get('JWT_SECRET_KEY');
  static final String iosAppId = dotenv.get('IOS_APP_ID');
  static final String topic = dotenv.get('TOPIC');
  static final String aosBannerId = dotenv.get('AOS_BANNER_ID');
  static final String iosBannerId = dotenv.get('IOS_BANNER_ID');
}
