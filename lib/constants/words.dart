import 'package:findus/constants/langs/en.dart';
import 'package:findus/constants/langs/ko.dart';
import 'package:get/get.dart';

import 'langs/mn.dart';

class Words extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ko': ko,
        'en': en,
        'mn': mn,
      };
}
