class ItemModel {
  final String? id;
  final String userId;
  final String groupId;
  final String color;
  final int count;
  final String name;
  final String expiryDate;
  final int minimumStockAlert;
  final String stockImage;
  final bool isEnableExpiry;
  final String createdAt;

  ItemModel({
    this.id,
    required this.userId,
    required this.color,
    required this.count,
    required this.name,
    required this.groupId,
    required this.expiryDate,
    required this.minimumStockAlert,
    required this.stockImage,
    required this.isEnableExpiry,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'group_id': groupId,
    'color': color,
    'count': count,
    'name': name,
    'minimum_stock_alert': minimumStockAlert,
    'expiry_date': expiryDate,
    'stock_image': stockImage,
    'is_enable_expiry': isEnableExpiry,
    'created_at': createdAt,
  };

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      userId: json['user_id'],
      groupId: json['group_id'],
      color: json['color'],
      count: json['count'],
      name: json['name'],
      minimumStockAlert: json['minimum_stock_alert'],
      stockImage: json['stock_image'],
      expiryDate: json['expiry_date'],
      isEnableExpiry: json['is_enable_expiry'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'group_id': groupId,
      'color': color,
      'count': count,
      'name': name,
      'minimum_stock_alert': minimumStockAlert,
      'expiry_date': expiryDate,
      'stock_image': stockImage,
      'is_enable_expiry': isEnableExpiry,
      'created_at': createdAt,
    };
  }

  // Convert a Map object into a User object
  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'],
      userId: map['user_id'],
      groupId: map['group_id'],
      color: map['color'],
      count: map['count'],
      name: map['name'],
      minimumStockAlert: map['minimum_stock_alert'],
      stockImage: map['stock_image'],
      expiryDate: map['expiry_date'],
      isEnableExpiry: map['is_enable_expiry'],
      createdAt: map['created_at'],
    );
  }
}
