class ItemDataModel {
  final String itemColor;
  final int itemCount;
  final String itemName;
  final String currentDate;
  final String expiryDate;
  final int minimumStockAlert;
  final String stockImage;
  final bool isEnableExpiry;

  ItemDataModel({
    required this.itemColor,
    required this.itemCount,
    required this.itemName,
    required this.currentDate,
    required this.expiryDate,
    required this.minimumStockAlert,
    required this.stockImage,
    required this.isEnableExpiry,
  });

  factory ItemDataModel.fromJson(Map<String, dynamic> json) {
    return ItemDataModel(
      itemColor: json['item_color'],
      itemCount: json['item_count'],
      itemName: json['item_name'],
      currentDate: json['current_date'],
      minimumStockAlert: json['minimum_stock_alert'],
      stockImage: json['stock_image'],
      expiryDate: json['expiry_date'],
      isEnableExpiry: json['is_enable_expiry'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_color': itemColor,
      'item_count': itemCount,
      'item_name': itemName,
      'current_date': currentDate,
      'minimum_stock_alert': minimumStockAlert,
      'is_enable_expiry': isEnableExpiry,
      'stock_image': stockImage,
      'expiry_date': expiryDate,
    };
  }
}
