import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xstock/modules/authentication/models/user_model.dart';
import 'package:xstock/modules/authentication/repository/user_account_repository.dart';
import 'package:xstock/modules/common/repo/session_repository.dart';
import 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit(this.sessionRepository)
      : super(SignupState.initial());
  SessionRepository sessionRepository;
  CollectionReference students = FirebaseFirestore.instance.collection('users');

  void toggleShowPassword() => emit(state.copyWith(
        isPasswordHidden: !state.isPasswordHidden,
        signupStatus: SignupStatus.initial,
      ));

  void enableAutoValidateMode() => emit(state.copyWith(
        isAutoValidate: true,
        signupStatus: SignupStatus.initial,
      ));

  Future<void> signup(
      String branchName, String email, String password, String userId) async {
    emit(state.copyWith(signupStatus: SignupStatus.loading));
    try {
      await students.add({
        'branch_name': branchName,
        'email': email,
        "user_id": userId
      }).then((value) async {
        UserCredential credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (credential.user != null) {
          await credential.user!
              .updateProfile(displayName: branchName)
              .then((value) async {
            await sessionRepository.setLoggedIn(true);
            emit(state.copyWith(
                signupStatus: SignupStatus.success,
                message: "Register successfully!",
                userModel: UserModel(
                    branch_name: branchName, email: email, user_id: userId)));
          }).onError((error, stackTrace) {
            emit(state.copyWith(
                signupStatus: SignupStatus.error, message: error.toString()));
          });
        } else {
          emit(state.copyWith(
              signupStatus: SignupStatus.error,
              message: "Something went wrong"));
        }
      }).catchError((error) {
        emit(state.copyWith(
            signupStatus: SignupStatus.error, message: email.toString()));
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'week-password') {
        emit(state.copyWith(
            signupStatus: SignupStatus.error,
            message: "The password provided is to week"));
      } else if (e.code == 'email-already-in-use') {
        emit(state.copyWith(
            signupStatus: SignupStatus.error,
            message: "Account already exists for that email"));
      } else {
        emit(state.copyWith(
            signupStatus: SignupStatus.error, message: e.message));
      }
    } catch (e) {
      emit(state.copyWith(
          signupStatus: SignupStatus.error, message: e.toString()));
    }
  }
}
