
class MapCategoryResult {
  final List<MapCategory> result;

  MapCategoryResult({required this.result});

  factory MapCategoryResult.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['list'] as List;
    List<MapCategory> MapCategoryList =
    list.map((i) => MapCategory.fromJson(i)).toList();

    return MapCategoryResult(
      result: MapCategoryList,
    );
  }
}


class MapCategory {
  MapCategory({
    num? locationCategoryId,
    String? categoryName,
    String? categoryNameEn,
  }) {
    _locationCategoryId = locationCategoryId;
    _categoryName = categoryName;
    _categoryNameEn = categoryNameEn;
  }

  MapCategory.fromJson(dynamic json) {
    _locationCategoryId = json['location_category_id'];
    _categoryName = json['category_name'];
    _categoryNameEn = json['category_name_en'];
  }

  num? _locationCategoryId;
  String? _categoryName;
  String? _categoryNameEn;

  MapCategory copyWith({
    num? locationCategoryId,
    String? categoryName,
    String? categoryNameEn,
  }) =>
      MapCategory(
        locationCategoryId: locationCategoryId ?? _locationCategoryId,
        categoryName: categoryName ?? _categoryName,
        categoryNameEn: categoryNameEn ?? _categoryNameEn,
      );

  num? get locationCategoryId => _locationCategoryId;

  String? get categoryName => _categoryName;

  String? get categoryNameEn => _categoryNameEn;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['location_category_id'] = _locationCategoryId;
    map['category_name'] = _categoryName;
    map['category_name_en'] = _categoryNameEn;
    return map;
  }
}
