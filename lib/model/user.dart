import 'package:get/get.dart';

class Client {
  String? auth_token;
  String? user_name;
  String? user_birthday;
  String? facebook_id;
  String?  user_nickname;
  String? profile_url;
  String? email;
  String? create_date;

  Client({
    this.auth_token,
    this.user_name,
    this.user_birthday,
    this.facebook_id,
    this.user_nickname,
    this.profile_url,
    this.create_date,
    this.email,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      auth_token: json['auth_token'],
      user_name: json['user_name'],
      user_birthday: json['user_birthday'],
      facebook_id: json['facebook_id'],
      user_nickname: json['user_nickname'],
      profile_url: json['profile_url'],
      create_date: json['create_date'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['auth_token'] = auth_token;
    map['user_name'] = user_name;
    map['user_birthday'] = user_birthday;
    map['facebook_id'] = facebook_id;
    map['user_nickname'] = user_nickname;
    map['profile_url'] = profile_url;
    map['create_date'] = create_date;
    map['email'] = email;
    return map;
  }

}

