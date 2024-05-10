import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xstock/modules/authentication/models/user_model.dart';
import 'package:xstock/modules/common/repo/session_repository.dart';

part 'startup_state.dart';

class StartupCubit extends Cubit<StartupState> {
  StartupCubit({
    required SessionRepository sessionRepository,
  })  :
        _sessionRepository = sessionRepository,
        super(StartupState.initial());

  final SessionRepository _sessionRepository;

  void init() async {
    await Future.delayed(const Duration(seconds: 5));

    bool isLoggedIn = _sessionRepository.isLoggedIn();
    print("isLoggedIn----$isLoggedIn");
    if (isLoggedIn) {
      emit(state.copyWith(status: Status.authenticated));
    } else {
      emit(state.copyWith(status: Status.unauthenticated));
    }
  }
}
