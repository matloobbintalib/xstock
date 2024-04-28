
class UserModel {
  String name;
  String email;
  String profilePicture;
  String mobileNumber;

  UserModel({
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.mobileNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json["name"],
        email: json["email"],
        profilePicture:
            json["profile_picture"] == null ? '' : json["profile_picture"],
        mobileNumber: json["mobile_number"],
      );

  Map<String, dynamic> toJson() =>
      {
        "name": name,
        "email": email,
        "profile_picture": profilePicture,
        "mobile_number": mobileNumber,
      };

  static UserModel empty = UserModel(
    name: '',
    email: '',
    profilePicture: '',
    mobileNumber: '',
  );
}
