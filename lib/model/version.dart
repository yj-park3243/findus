class VersionResult {
  final List<VersionModel> result;
  VersionResult({required this.result});
  factory VersionResult.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['version'] as List;
    List<VersionModel> VersionList = list.map((i) => VersionModel.fromJson(i)).toList();
    return VersionResult(
      result: VersionList,
    );
  }
}

class VersionModel {
  final String version_name;
  final String version_value;

  VersionModel({
    required this.version_name,
    required this.version_value,
  });

  factory VersionModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return VersionModel(
      version_name: json['version_name']?? '',
      version_value: json['version_value']?? '',
    );
  }
}
