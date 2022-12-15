import 'package:findus/model/jiffyUtil.dart';
import 'package:jiffy/jiffy.dart';
import 'package:get/get.dart';

class CommentResult {
  final List<CommentModel> result;
  CommentResult({required this.result});
  factory CommentResult.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['Comment'] as List;
    List<CommentModel> commentList = list.map((i) => CommentModel.fromJson(i)).toList();
    return CommentResult(
      result: commentList,
    );
  }
}

class CommentModel {
  final int? comment_id;
  final int? board_id;
  final int? parent_comment;
  final String? comment;
  final String? create_date;
  final String? update_date;
  final String? auth_token;
  final String? nick_name;
  final int? comment_like_cnt;
  final int? is_like;
  final bool? use_yn;
  final String? profile_url;

  CommentModel({
    this.comment_id,
    this.board_id,
    this.parent_comment,
    this.comment,
    this.create_date,
    this.update_date,
    this.auth_token,
    this.nick_name,
    this.comment_like_cnt,
    this.is_like,
    this.use_yn,
    this.profile_url,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    Jiffy.locale(Get.locale?.languageCode =='mn' ? 'en' : Get.locale?.languageCode);
    var create_date = Jiffy( json['create_date'] ).from( DateTime.now().add(Duration(hours: 9)));
    var update_date = Jiffy( json['update_date'] ).from( DateTime.now().add(Duration(hours: 9)));
    return CommentModel(
      comment_id: json['comment_id'] ?? 0,
      board_id: json['board_id']?? 0,
      parent_comment: json['parent_comment']?? 0,
      comment: json['comment']?? '',
      create_date: Get.locale?.languageCode =='mn' ? changeMnTime( create_date ) : create_date ,
      update_date: Get.locale?.languageCode =='mn' ? changeMnTime( update_date ) : update_date ,
      auth_token: json['auth_token']?? '',
      nick_name: json['user_nickname']?? '',
      profile_url: json['profile_url'],
      comment_like_cnt: json['comment_like_cnt']?? 0,
      is_like: json['is_like']?? 0,
      use_yn: json['use_yn']?? false,
    );
  }
}
