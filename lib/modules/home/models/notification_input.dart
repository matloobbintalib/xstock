import 'package:dio/dio.dart';

class NotificationInput {
  final String name;
  final String message;
  String? email;

  NotificationInput({required this.name, required this.message,this.email});

  Map<String, dynamic> toJson() => {
    "name": name,
    "message": message,
    "email": email,
  };

  FormData toFormData() => FormData.fromMap({
    "name": name,
    "message": message,
    "email": email,
  });
}
