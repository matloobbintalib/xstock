import 'dart:convert';

import 'package:http/http.dart';
import 'package:xstock/modules/common/repo/session_repository.dart';

import '../../../constants/constants.dart';
import '../../../core/storage_service/storage_service.dart';
import '../../../utils/logger/logger.dart';
import '../models/user_model.dart';

class UserAccountRepository {
  StorageService storageService;
  SessionRepository sessionRepository;

  UserAccountRepository({required this.storageService, required this.sessionRepository});

  final _log = logger(UserAccountRepository);

  Future<void> saveUserInDb(UserModel userModel) async {
    final userMap = userModel.toJson();
    await storageService.setString(StorageKeys.user, json.encode(userMap));
    _log.i('user saved in db');
  }

  UserModel getUserFromDb() {
    final userString = storageService.getString(StorageKeys.user);
    if (userString.isNotEmpty) {
      final Map<String, dynamic> userMap = jsonDecode(userString);
      UserModel userModel = UserModel.fromJson(userMap);
      _log.i('user loaded from local db $userModel');
      return userModel;
    } else {
      return UserModel.empty;
    }
  }

  Future<void> removeUserFromDb() async {
    await storageService.remove(StorageKeys.user);
    _log.i('user removed from db');
  }

  Future<void> logout() async {
    await sessionRepository.setLoggedIn(false);
    await sessionRepository.removeToken();
    await removeUserFromDb();
    _log.i('logout successfully');
  }


}
