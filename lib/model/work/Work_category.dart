
class Region {
  Region({
    this.workRegionId,
    this.regionName,});

  Region.fromJson(dynamic json) {
    workRegionId = json['work_region_id'];
    regionName = json['region_name'];
  }
  int? workRegionId;
  String? regionName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['work_region_id'] = workRegionId;
    map['region_name'] = regionName;
    return map;
  }

}

class Category {
  Category({
    this.workCategoryName,
    this.workCategoryId,});

  Category.fromJson(dynamic json) {
    workCategoryName = json['work_category_name'];
    workCategoryId = json['work_category_id'];
  }
  String? workCategoryName;
  int? workCategoryId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['work_category_name'] = workCategoryName;
    map['work_category_id'] = workCategoryId;
    return map;
  }

}

class WorkCategory {
  WorkCategory({
      this.category, 
      this.region,});

  WorkCategory.fromJson(dynamic json) {
    if (json['category'] != null) {
      category = [];
      json['category'].forEach((v) {
        category?.add(Category.fromJson(v));
      });
    }
    if (json['region'] != null) {
      region = [];
      json['region'].forEach((v) {
        region?.add(Region.fromJson(v));
      });
    }
  }
  List<Category>? category;
  List<Region>? region;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    final category = this.category;
    final region = this.region;
    if (category != null) {
      map['category'] = category.map((v) => v.toJson()).toList();
    }
    if (region != null) {
      map['region'] = region.map((v) => v.toJson()).toList();
    }
    return map;
  }

}