import 'package:findus/model/jiffyUtil.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class BoardResult {
  final List<BoardModel> result;
  BoardResult({required this.result});
  factory BoardResult.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['list'] as List;
    List<BoardModel> BoardList = list.map((i) => BoardModel.fromJson(i)).toList();
    return BoardResult(
      result: BoardList,
    );
  }
}

class BoardModel {
  final int? board_id;
  final int? board_category_id;
  final String? subject;
  final String? content;
  final int? notice_yn;
  final String? create_date;
  final String? ori_create_date;
  final String? update_date;
  final String? ori_update_date;
  final String? author;
  final String? auth_token;
  final String? profile_url;
  int? recommend_cnt = 0;
  final int? views;
  final int? comment_cnt;
  int? is_like = 0;

  BoardModel({
    this.board_id,
    this.board_category_id,
    this.subject,
    this.content,
    this.author,
    this.auth_token,
    this.notice_yn,
    this.create_date,
    this.ori_create_date,
    this.update_date,
    this.ori_update_date,
    this.recommend_cnt,
    this.views,
    this.comment_cnt,
    this.is_like,
    this.profile_url,
  });
  void recommned_cnt (int cnt){
    this.recommend_cnt = cnt;
  }

  factory BoardModel.fromJson(Map<String, dynamic> json) {
    Jiffy.locale(Get.locale?.languageCode =='mn' ? 'en' : Get.locale?.languageCode);
    var create_date = Jiffy( json['create_date'] ).from( DateTime.now().add(Duration(hours: 9)));
    var update_date = Jiffy( json['update_date'] ).from( DateTime.now().add(Duration(hours: 9)));
    return BoardModel(
      board_id: json['board_id'] ?? 0,
      board_category_id: json['board_category_id']?? 0,
      subject: json['subject'] ?? '',
      content: json['content']?? '',
      notice_yn: json['notice_yn']?? 0,
      create_date: Get.locale?.languageCode =='mn' ? changeMnTime( create_date ) : create_date ,
      update_date: Get.locale?.languageCode =='mn' ? changeMnTime( update_date ) : update_date ,
      ori_create_date: json['create_date'] ,
      ori_update_date: json['update_date'] ,
      author: json['user_nickname'],
      auth_token: json['auth_token'],
      recommend_cnt: json['recommend_cnt'],
      views: json['views'],
      comment_cnt: json['comment_cnt'],
      is_like: json['is_like'],
      profile_url: json['profile_url'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['board_id'] = board_id;
    map['board_category_id'] = board_category_id;
    map['subject'] = subject;
    map['content'] = content;
    map['notice_yn'] = notice_yn;
    map['create_date'] = ori_create_date;
    map['update_date'] = ori_update_date;
    map['user_nickname'] = author;
    map['auth_token'] = auth_token;
    map['recommend_cnt'] = recommend_cnt;
    map['views'] = views;
    map['comment_cnt'] = comment_cnt;
    map['is_like'] = is_like;
    map['profile_url'] = profile_url;
    return map;
  }
}
