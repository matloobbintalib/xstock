class ItemModel {
  final String id;
  final String groupId;
  final String itemColor;
  final int itemCount;
  final String itemName;

  ItemModel({
    required this.id,
    required this.itemColor,
    required this.itemCount,
    required this.itemName,
    required this.groupId,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      groupId: json['group_id'],
      itemColor: json['color_code'],
      itemCount: json['item_count'],
      itemName: json['item_name'],
    );
  }
}
