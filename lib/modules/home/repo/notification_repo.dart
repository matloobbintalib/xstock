import 'package:dio/dio.dart';
import 'package:xstock/constants/api_endpoints.dart';
import 'package:xstock/core/exceptions/api_error.dart';
import 'package:xstock/core/network/dio_client.dart';
import 'package:xstock/utils/logger/logger.dart';

import '../models/notification_input.dart';

class NotificationRepository {
  final DioClient _dioClient;
  final _log = logger(NotificationRepository);

  NotificationRepository({required DioClient dioClient})
      : _dioClient = dioClient;

  Future<String> sendEmailNotification(NotificationInput input) async {
    try {
      var response = await _dioClient.post(Endpoints.sendEmailNotification, data: input.toFormData());
      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw ApiError(
            message: response.data['message'], code: response.statusCode);
      }
    } on DioException catch (e, stackTrace) {
      _log.e(e, stackTrace: stackTrace);
      throw ApiError.fromDioException(e);
    } on TypeError catch (e) {
      _log.e(e.stackTrace);
      throw ApiError(message: '$e', code: 0);
    } catch (e) {
      _log.e(e);
      throw ApiError(message: '$e', code: 0);
    }
  }

  Future<String> sendNotification() async {
    try {
      var response = await _dioClient.get(Endpoints.sendNotification);
      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw ApiError(
            message: response.data['message'], code: response.statusCode);
      }
    } on DioException catch (e, stackTrace) {
      _log.e(e, stackTrace: stackTrace);
      throw ApiError.fromDioException(e);
    } on TypeError catch (e) {
      _log.e(e.stackTrace);
      throw ApiError(message: '$e', code: 0);
    } catch (e) {
      _log.e(e);
      throw ApiError(message: '$e', code: 0);
    }
  }
}
