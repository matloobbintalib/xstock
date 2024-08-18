import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:xstock/modules/authentication/models/user_model.dart';
import 'package:xstock/modules/authentication/repository/user_account_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit({required UserAccountRepository userAccountRepository})
      : _userAccountRepository = userAccountRepository,
        super(UserState.initial());

  final UserAccountRepository _userAccountRepository;

  void loadUser() {
    UserModel userModel = _userAccountRepository.getUserFromDb();
    emit(state.copyWith(userModel: userModel, userStatus: UserStatus.success));
  }
}
