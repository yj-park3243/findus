class LocationDetailModel {
  List<Images>? image;
  int? total;
  List<Comment>? comment;
  List<OpenTime>? openTime;

  LocationDetailModel({this.image, this.total, this.comment});

  LocationDetailModel.fromJson(Map<String, dynamic> json) {
    if (json['images'] != null) {
      image = <Images>[];
      json['images'].forEach((v) {
        image!.add(Images.fromJson(v));
      });
    }
    total = json['total'];
    if (json['comment'] != null) {
      comment = <Comment>[];
      json['comment'].forEach((v) {
        comment!.add(Comment.fromJson(v));
      });
    }

    if (json['open_time'] != null) {
      openTime = <OpenTime>[];
      json['open_time'].forEach((v) {
        openTime!.add(OpenTime.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (image != null) {
      data['image'] = image!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    if (comment != null) {
      data['comment'] = comment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  String? imageUrl;
  int? imageId;

  Images({this.imageUrl, this.imageId});

  Images.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
    imageId = json['image_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_url'] = imageUrl;
    data['image_id'] = imageId;
    return data;
  }
}

class Comment {
  int? storeId;
  String? userNickname;
  String? uid;
  String? comment;
  int? recommendLevel;
  int? commentId;
  String? createDate;
  String? updateDate;

  Comment(
      {this.storeId,
      this.userNickname,
        this.uid,
      this.comment,
      this.recommendLevel,
      this.commentId,
      this.createDate,
      this.updateDate});

  Comment.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    userNickname = json['user_nickname'];
    uid = json['uid'];
    comment = json['comment'];
    recommendLevel = json['recommend_level'];
    commentId = json['comment_id'];
    createDate = json['create_date'];
    updateDate = json['update_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_id'] = storeId;
    data['user_nickname'] = userNickname;
    data['uid'] = uid;
    data['comment'] = comment;
    data['recommend_level'] = recommendLevel;
    data['comment_id'] = commentId;
    data['create_date'] = createDate;
    data['update_date'] = updateDate;
    return data;
  }
}

class OpenTime {
  OpenTime({
    this.dayType,
    this.opentimeId,
    this.openTime,
    this.closeTime,
    this.openDay,
  });

  OpenTime.fromJson(dynamic json) {
    dayType = json['day_type'];
    opentimeId = json['opentime_id'];
    openTime = json['open_time'];
    closeTime = json['close_time'];
    openDay = json['open_day'];
  }
  int? dayType;
  int? opentimeId;
  String? openTime;
  String? closeTime;
  String? openDay;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['day_type'] = dayType;
    map['opentime_id'] = opentimeId;
    map['open_time'] = openTime;
    map['close_time'] = closeTime;
    map['open_day'] = openDay;
    return map;
  }

}