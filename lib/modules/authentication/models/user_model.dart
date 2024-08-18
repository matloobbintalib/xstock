class UserModel {
  String? id;
  String branchName;
  String email;
  String deviceId;
  String? fcmToken;
  String alertEmail;
  bool isSelected;

  UserModel({
    this.id,
    required this.branchName,
    required this.email,
    required this.deviceId,
    required this.alertEmail,
    this.fcmToken,
    this.isSelected = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        email: json["email"],
        branchName: json["branch_name"],
        deviceId: json["device_id"],
        fcmToken: json["fcm_token"],
        alertEmail: json["alert_email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "branch_name": branchName,
        "device_id": deviceId,
        "fcm_token": fcmToken,
        "alert_email": alertEmail,
      };

  static UserModel empty = UserModel(
    id: '',
    email: '',
    branchName: '',
    deviceId: '',
    fcmToken: '',
    alertEmail: '',
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'branch_name': branchName,
      'device_id': deviceId,
      'fcm_token': fcmToken,
      'alert_email': alertEmail,
    };
  }

  // Convert a Map object into a User object
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      branchName: map['branch_name'],
      deviceId: map['device_id'],
      fcmToken: map['fcm_token'],
      alertEmail: map['alert_email'],
    );
  }
}
