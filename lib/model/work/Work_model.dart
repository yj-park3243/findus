import 'package:findus/model/jiffyUtil.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
class WorkData {
  WorkData({
    this.endDate,
    this.workId,
    this.workCategoryName,
    this.workPay,
    this.workCategoryId,
    this.profileUrl,
    this.subject,
    this.useYn,
    this.workAddr1_en,
    this.workAddr2_en,
    this.workAddr1_ko,
    this.workAddr2_ko,
    this.workPhone,
    this.views,
    this.workLat,
    this.content,
    this.updateDate,
    this.workLng,
    this.workRegionId,
    this.userNickname,
    this.regionName,
    this.authToken,
    this.createDate,
    this.dDay,
    this.isEnd,
    this.profile_url,
  });

  WorkData.fromJson(dynamic json) {
    Jiffy.locale(Get.locale?.languageCode =='mn' ? 'en' : Get.locale?.languageCode);
    var create_date = Jiffy( json['create_date'] ).from( DateTime.now().add(Duration(hours: 9)));
    var update_date = Jiffy( json['update_date'] ).from( DateTime.now().add(Duration(hours: 9)));
    endDate = json['end_date'];
    workId = json['work_id'];
    workCategoryName = json['work_category_name'];
    workPay = json['work_pay'];
    workCategoryId = json['work_category_id'];
    profile_url = json['profile_url'];
    subject = json['subject'];
    useYn = json['use_yn'];
    workAddr1_en = json['work_addr1_en'];
    workAddr2_en = json['work_addr2_en'];
    workAddr1_ko = json['work_addr1_ko'];
    workAddr2_ko = json['work_addr2_ko'];
    workPhone = json['work_phone'];
    workLat = json['work_lat'];
    content = json['content'];
    updateDate = json['update_date'];
    workLng = json['work_lng'];
    workRegionId = json['work_region_id'];
    userNickname = json['user_nickname'];
    regionName = json['region_name'];
    views = json['views'];
    authToken = json['auth_token'];

    createDate= Get.locale?.languageCode =='mn' ? changeMnTime( create_date ) : create_date ;
    dDay = DateTime.now().difference(DateTime.parse(json['end_date'])).inDays;
    isEnd = DateTime.now().difference(DateTime.parse(json['end_date'])).inDays < 0 ;

  }
  String? endDate;
  int? workId;
  String? workCategoryName;
  int? workPay;
  int? workCategoryId;
  String? profileUrl;
  String? subject;
  bool? useYn;
  String? workAddr1_en;
  String? workAddr2_en;
  String? workAddr1_ko;
  String? workAddr2_ko;
  String? workPhone;
  double? workLat;
  String? content;
  String? updateDate;
  double? workLng;
  int? workRegionId;
  int? views;
  String? userNickname;
  String? regionName;
  String? authToken;
  String? createDate;
  String? profile_url;
  int? dDay;
  bool? isEnd;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['end_date'] = endDate;
    map['work_id'] = workId;
    map['work_category_name'] = workCategoryName;
    map['work_pay'] = workPay;
    map['work_category_id'] = workCategoryId;
    map['profile_url'] = profile_url;
    map['subject'] = subject;
    map['use_yn'] = useYn;
    map['work_addr1_en'] = workAddr1_en;
    map['work_addr2_en'] = workAddr2_en;
    map['work_addr1_ko'] = workAddr1_ko;
    map['work_addr2_ko'] = workAddr2_ko;
    map['work_phone'] = workPhone;
    map['work_lat'] = workLat;
    map['content'] = content;
    map['update_date'] = updateDate;
    map['work_lng'] = workLng;
    map['work_region_id'] = workRegionId;
    map['user_nickname'] = userNickname;
    map['region_name'] = regionName;
    map['auth_token'] = authToken;
    map['create_date'] = createDate;
    return map;
  }

}
class WorkModel {
  WorkModel({
      this.workData,});

  WorkModel.fromJson(dynamic json) {
    if (json['list'] != null) {
      workData = [];
      json['list'].forEach((v) {
        workData?.add(WorkData.fromJson(v));
      });
    }
  }
  List<WorkData>? workData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    final workData = this.workData;
    if (workData != null) {
      map['workData'] = workData.map((v) => v.toJson()).toList();
    }
    return map;
  }

}