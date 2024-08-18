import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xstock/constants/api_endpoints.dart';
import 'package:xstock/constants/constants.dart';
import 'package:xstock/core/di/service_locator.dart';
import 'package:xstock/core/notifications/cloud_messaging_api.dart';
import 'package:xstock/modules/authentication/models/user_model.dart';
import 'package:xstock/modules/authentication/repository/user_account_repository.dart';
import 'package:xstock/modules/common/repo/session_repository.dart';
import 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit(this.sessionRepository) : super(SignupState.initial());
  SessionRepository sessionRepository;
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection(Endpoints.usersTable);

  void toggleShowPassword() => emit(state.copyWith(
        isPasswordHidden: !state.isPasswordHidden,
        signupStatus: SignupStatus.initial,
      ));

  void enableAutoValidateMode() => emit(state.copyWith(
        isAutoValidate: true,
        signupStatus: SignupStatus.initial,
      ));

  Future<void> signup(UserModel userModel, String password) async {
    emit(state.copyWith(signupStatus: SignupStatus.loading));
    try {
      String fcmToken = await sl<CloudMessagingApi>().getFcmToken() ?? '';
      userModel.fcmToken = fcmToken;
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: userModel.email, password: password);
      if (credential.user != null) {
        await credential.user!
            .updateProfile(displayName: userModel.branchName)
            .then((value) async {
          userModel.id = credential.user?.uid;
          await usersCollection.doc(credential.user?.uid).set(userModel.toMap()).then((value) async {
            await sessionRepository.setLoggedIn(true);
            emit(state.copyWith(
                signupStatus: SignupStatus.success,
                message: "Register successfully!",
                userModel: userModel));
          }).catchError((error) {
            emit(state.copyWith(
                signupStatus: SignupStatus.error, message: error.toString()));
          });
        }).onError((error, stackTrace) {
          emit(state.copyWith(
              signupStatus: SignupStatus.error, message: error.toString()));
        });
      } else {
        emit(state.copyWith(
            signupStatus: SignupStatus.error, message: "Something went wrong"));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'week-password') {
        emit(state.copyWith(
            signupStatus: SignupStatus.error,
            message: "The password provided is to week"));
      } else if (e.code == 'email-already-in-use') {
        emit(state.copyWith(
            signupStatus: SignupStatus.error,
            message: "Account already exists for that email"));
      } else if (e.code == 'network-request-failed') {
        emit(state.copyWith(
            signupStatus: SignupStatus.error,
            message: "Internet connection failed"));
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
