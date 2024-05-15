import 'package:xstock/modules/home/models/item_model.dart';

class ItemDetailsModel {
  final ItemModel itemModel;
  final String currentDate;
  final String expiryDate;
  final int minimumStockAlert;
  final String stockImage;

  ItemDetailsModel({
    required this.itemModel,
    required this.currentDate,
    required this.expiryDate,
    required this.minimumStockAlert,
    required this.stockImage,
  });

  factory ItemDetailsModel.fromJson(Map<String, dynamic> json) {
    return ItemDetailsModel(
      itemModel: ItemModel(
          id: json['item_id'],
          itemColor: json['color_code'],
          itemCount: json['item_count'],
          groupId: json['group_id'],
          itemName: json['item_name']),
      currentDate: json['current_date'],
      minimumStockAlert: json['minimum_stock_alert'],
      stockImage: json['stock_image'],
      expiryDate: json['expiry_date'],
    );
  }
}
