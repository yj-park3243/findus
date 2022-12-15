
class LocationResult {
  final List<Location> result;

  LocationResult({required this.result});

  factory LocationResult.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['list'] as List;
    List<Location> LocationList =
    list.map((i) => Location.fromJson(i)).toList();

    return LocationResult(
      result: LocationList,
    );
  }
}


class Location {

  Location({
    this.locationCategoryId,
    this.categoryName,
    this.distance,
    this.isOpen,
    this.locationName,
    this.openCloseTime,
    this.latitude,
    this.locationId,
    this.address1_en,
    this.address2_en,
    this.address1_ko,
    this.address2_ko,
    this.createDate,
    this.longitude,
    this.locationPhone,
    this.openDay,
    this.imageUrl,
    this.description,
    this.arr_yn,
    this.parent_id,
    this.location_floor,
    this.room_number,
  });

  Location.fromJson(dynamic json) {
    locationCategoryId = json['location_category_id'];
    categoryName = json['category_name'];
    distance = json['distance'];
    isOpen = json['is_open'];
    locationName = json['location_name'];
    openCloseTime = json['open_close_time'];
    latitude = json['latitude'];
    locationId = json['location_id'];
    address1_en = json['address1_en'];
    address2_en = json['address2_en'];
    address1_ko = json['address1_ko'];
    address2_ko = json['address2_ko'];
    createDate = json['create_date'];
    longitude = json['longitude'];
    locationPhone = json['location_phone'];
    openDay = json['open_day'];
    imageUrl = json['image_url'];
    description = json['description'];

    arr_yn = json['arr_yn'];
    parent_id = json['parent_id'];
    location_floor = json['location_floor'];
    room_number = json['room_number'];
  }
  int? locationCategoryId;
  String? categoryName;
  String? distance;
  int? isOpen;
  String? locationName;
  String? openCloseTime;
  double? latitude;
  int? locationId;
  String? address1_en;
  String? address2_en;
  String? address1_ko;
  String? address2_ko;
  String? createDate;
  double? longitude;
  String? locationPhone;
  String? openDay;
  String? imageUrl;
  String? description;

  bool? arr_yn;
  int? parent_id;
  int? location_floor;
  int? room_number;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['location_category_id'] = locationCategoryId;
    map['category_name'] = categoryName;
    map['distance'] = distance;
    map['is_open'] = isOpen;
    map['location_name'] = locationName;
    map['open_close_time'] = openCloseTime;
    map['latitude'] = latitude;
    map['location_id'] = locationId;

    map['address1_en'] = address1_en;
    map['address2_en'] = address2_en;
    map['address1_ko'] = address1_ko;
    map['address2_ko'] = address2_ko;

    map['create_date'] = createDate;
    map['longitude'] = longitude;
    map['location_phone'] = locationPhone;
    map['open_day'] = openDay;
    map['image_url'] = imageUrl;
    map['description'] = description;
    map['arr_yn'] = arr_yn;
    map['parent_id'] = parent_id;
    map['location_floor'] = location_floor;
    map['room_number'] = room_number;
    return map;
  }

}
