import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xstock/constants/api_endpoints.dart';
import 'package:xstock/core/exceptions/api_error.dart';
import 'package:xstock/modules/home/cubits/send_notification/send_notification_state.dart';
import 'package:xstock/modules/home/models/notification_input.dart';
import 'package:xstock/modules/home/repo/notification_repo.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _repository;

  NotificationCubit(this._repository) : super(NotificationState.initial());

  CollectionReference usersCollection =
  FirebaseFirestore.instance.collection(Endpoints.usersTable);

  Future<void> sendEmailNotification(NotificationInput input, String email) async {
    emit(state.copyWith(
        notificationStatus: NotificationStatus.loading));
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(Endpoints.usersTable)
          .where('email', isEqualTo: email)
          .get();
      input.email = querySnapshot.docs.first.get('alert_email');
      String response = await _repository.sendEmailNotification(input);
      if (response.contains('email') || response.contains('Email')) {
        emit(state.copyWith(
            notificationStatus: NotificationStatus.success,
            message: response));
      } else {
        emit(state.copyWith(
            notificationStatus: NotificationStatus.error,
            message: response));
      }
    } on ApiError catch (e) {
      emit(state.copyWith(
          notificationStatus: NotificationStatus.error,
          message: e.message));
    }
  }

  Future<void> sendNotification() async {
    emit(state.copyWith(
        notificationStatus: NotificationStatus.loading));
    try {
      String response = await _repository.sendNotification();
      emit(state.copyWith(
          notificationStatus: NotificationStatus.success,
          message: response));
    } on ApiError catch (e) {
      emit(state.copyWith(
          notificationStatus: NotificationStatus.error,
          message: e.message));
    }
  }
}
