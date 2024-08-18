import 'package:xstock/modules/home/models/item_data_model.dart';
import 'package:xstock/modules/home/models/item_model.dart';

class GroupDataModel {
  final String groupName;
  final String createdAt;
  final String id;
  final String userId;
  final List<ItemModel> items;

  GroupDataModel({required this.groupName, required this.createdAt, required this.items, required this.id, required this.userId});

  Map<String, dynamic> toJson() {
    return {
      'group_name': groupName,
      'id': id,
      'user_id': userId,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': groupName,
      'created_at': createdAt,
    };
  }
  factory GroupDataModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> itemsJson = json['items'];
    List<ItemModel> items = itemsJson.map((itemJson) => ItemModel.fromJson(itemJson)).toList();
    return GroupDataModel(
      groupName: json['groupName'],
      createdAt: json['created_at'],
      id: json['id'],
      userId: json['user_id'],
      items: items,
    );
  }

}
