
class BanUserResult {
  List<BanUser> result;
  BanUserResult({required this.result,});
  factory BanUserResult.fromJson(dynamic parsedJson) {
    print(parsedJson);
    var list = parsedJson['result'] as List;
    List<BanUser> banUserList = list.map((i) => BanUser.fromJson(i)).toList();
    return BanUserResult(
      result: banUserList,
    );
  }
}

class BanUser {
  BanUser({
    this.userNickname,
    this.banUserToken,
    this.banId,});

  BanUser.fromJson(dynamic json) {
    userNickname = json['user_nickname'];
    banUserToken = json['ban_user_token'];
    banId = json['ban_id'];
  }
  String? userNickname;
  String? banUserToken;
  int? banId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_nickname'] = userNickname;
    map['ban_user_token'] = banUserToken;
    map['ban_id'] = banId;
    return map;
  }

}