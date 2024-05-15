class ItemDataModel {
  final String itemName;
  final String itemColor;
  final int itemCount;

  ItemDataModel({
    required this.itemName,
    required this.itemColor,
    required this.itemCount,
  });

  factory ItemDataModel.fromJson(Map<String, dynamic> json) {
    return ItemDataModel(
      itemName: json['item_name'],
      itemColor: json['color_code'],
      itemCount: json['item_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_name': itemName,
      'color_code': itemColor,
      'item_count': itemCount,
    };
  }
}
