class BoardCategoryResult {
  final List<BoardCategory> result;

  BoardCategoryResult({required this.result});

  factory BoardCategoryResult.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['list'] as List;
    List<BoardCategory> BoardCategoryList =
        list.map((i) => BoardCategory.fromJson(i)).toList();

    return BoardCategoryResult(
      result: BoardCategoryList,
    );
  }
}

class BoardCategory {
  late String category_name;
  late int board_category_id;

  BoardCategory({
    required this.category_name,
    required this.board_category_id
  });

  factory BoardCategory.fromJson(Map<String, dynamic> json) {
    return BoardCategory(
      category_name: json['category_name'],
      board_category_id: json['board_category_id']
    );
  }
}
