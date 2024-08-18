class Endpoints {

  //table names
  static const String itemsTable = 'Items';
  static const String groupsTable = 'Groups';
  static const String usersTable = 'Users';


  //keys

  //auth
  static const String userId = 'user_id';
  static const String deviceId = 'device_id';
  static const String email = 'email';
  static const String branchName = 'branch_name';
  static const String password = 'password';
  static const String fcmToken = 'fcm_token';

  //item
  static const String itemId = 'id';
  static const String itemColor = 'color';
  static const String itemName = 'name';
  static const String itemCount = 'count';
  static const String currentDate = 'current_date';
  static const String minimumStockAlert = 'minimum_stock_alert';
  static const String stockImage = 'stock_image';
  static const String expiryDate = 'expiry_date';
  static const String isEnableExpiry = 'is_enable_expiry';

  //group
  static const String groupId = 'id';
  static const String groupName = 'name';
  static const String isExtendable = 'is_extendable';

  //Notification
  static const String sendEmailNotification = '/sendEmailNotification';
  static const String sendNotification = '/sendNotification';
}
