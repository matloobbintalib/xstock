
class UserModel {
  String branch_name;
  String email;
  String user_id;

  UserModel({
    required this.branch_name,
    required this.email,
    required this.user_id,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        branch_name: json["branch_name"],
        email: json["email"],
        user_id: json["user_id"]
      );

  Map<String, dynamic> toJson() =>
      {
        "branch_name": branch_name,
        "email": email,
        "user_id": user_id,
      };

  static UserModel empty = UserModel(
    branch_name: '',
    email: '',
    user_id: '',
  );
}
