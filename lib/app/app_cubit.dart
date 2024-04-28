import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xstock/core/storage_service/storage_service.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  final StorageService storageService;

  AppCubit(this.storageService,) : super(AppState(locale: const Locale('nl')));

  void init() {
  }

  void updateLanguage(String locale) {
    storageService.setString('locale', locale);
    emit(state.copyWith(locale: Locale(locale)));
  }
}
