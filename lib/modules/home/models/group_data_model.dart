import 'package:xstock/modules/home/models/item_data_model.dart';

class GroupDataModel {
  final String groupName;
  final List<ItemDataModel> items;

  GroupDataModel({required this.groupName, required this.items});

  Map<String, dynamic> toJson() {
    return {
      'groupName': groupName,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory GroupDataModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> itemsJson = json['items'];
    List<ItemDataModel> items = itemsJson.map((itemJson) => ItemDataModel.fromJson(itemJson)).toList();
    return GroupDataModel(
      groupName: json['groupName'],
      items: items,
    );
  }

}
