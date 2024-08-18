import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:xstock/constants/api_endpoints.dart';
import 'package:xstock/core/di/service_locator.dart';
import 'package:xstock/modules/authentication/models/user_model.dart';
import 'package:xstock/modules/authentication/repository/user_account_repository.dart';
import 'package:xstock/modules/common/repo/session_repository.dart';
import '../../../../core/notifications/cloud_messaging_api.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.sessionRepository, this.userAccountRepository)
      : super(LoginState.initial());

  SessionRepository sessionRepository;
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection(Endpoints.usersTable);
  UserAccountRepository userAccountRepository;

  void toggleShowPassword() => emit(state.copyWith(
        isPasswordHidden: !state.isPasswordHidden,
        loginStatus: LoginStatus.initial,
      ));

  void enableAutoValidateMode() => emit(state.copyWith(
        isAutoValidate: true,
        loginStatus: LoginStatus.initial,
      ));

  Future<void> login(String email, String password, String deviceId) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));
    try {
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        credential.user?.displayName;
        await sessionRepository.setLoggedIn(true);
        await userAccountRepository.saveUserInDb(UserModel(
            id: credential.user?.uid,
            branchName: credential.user?.displayName ?? '',
            email: email,
            alertEmail: email,
            deviceId: deviceId));
        emit(state.copyWith(
            loginStatus: LoginStatus.success, message: "Login successfully!"));
      } else {
        emit(state.copyWith(
            loginStatus: LoginStatus.error, message: "User not found"));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(state.copyWith(
            loginStatus: LoginStatus.error,
            message: "No user found for that email"));
      } else if (e.code == 'wrong-password') {
        emit(state.copyWith(
            loginStatus: LoginStatus.error,
            message: "Wrong password provided for that user"));
      } else if (e.code == 'network-request-failed') {
        emit(state.copyWith(
            loginStatus: LoginStatus.error,
            message: "Internet connection error please try again"));
      } else if (e.code == 'invalid-credential') {
        emit(state.copyWith(
            loginStatus: LoginStatus.error,
            message: "Email or password is incorrect"));
      } else {
        emit(
            state.copyWith(loginStatus: LoginStatus.error, message: e.message));
      }
    } catch (e) {
      emit(state.copyWith(
          loginStatus: LoginStatus.error, message: e.toString()));
    }
  }

  Future<void> socialSignIn() async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      if(userCredential.user != null){
        await GoogleSignIn().signOut();
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection(Endpoints.usersTable)
            .where('email', isEqualTo: googleUser.email)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          await sessionRepository.setLoggedIn(true);
          UserModel userModel = UserModel(
              id: querySnapshot.docs.first.get('id'),
              branchName: querySnapshot.docs.first.get('branch_name'),
              email: querySnapshot.docs.first.get('email'),
              alertEmail: querySnapshot.docs.first.get('alert_email'),
              deviceId: querySnapshot.docs.first.get('device_id'));
          await userAccountRepository.saveUserInDb(userModel);
          emit(state.copyWith(
              loginStatus: LoginStatus.success,
              message: "Login successfully!"));
        }
        else{
          UserModel userModel = UserModel(
              id: userCredential.user!.uid,
              branchName: '',
              alertEmail: userCredential.user!.email.toString(),
              email: userCredential.user!.email.toString(), deviceId: '',);
          emit(state.copyWith(
              loginStatus: LoginStatus.userNotFound, userModel: userModel));
        }
      }else {
        emit(state.copyWith(
            loginStatus: LoginStatus.error,message:  'Something went wrong'));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        emit(state.copyWith(
            loginStatus: LoginStatus.error, message: "Email is not valid"));
      } else if (e.code == 'user-not-found') {
        emit(state.copyWith(
            loginStatus: LoginStatus.error, message: "User not found"));
      } else {
        emit(
            state.copyWith(loginStatus: LoginStatus.error, message: e.message));
      }
      emit(state.copyWith(
          loginStatus: LoginStatus.error, message: e.toString()));
    }
  }

  Future<void> socialSignUp(String branchName, String deviceId, UserModel userModel) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));
    try {
      String fcmToken = await sl<CloudMessagingApi>().getFcmToken() ?? '';
      userModel.fcmToken = fcmToken;
      userModel.deviceId = deviceId;
      userModel.branchName = branchName;
      await usersCollection
          .doc(userModel.id)
          .set(userModel.toMap())
          .then((value) async {
        await sessionRepository.setLoggedIn(true);
        await userAccountRepository.saveUserInDb(userModel);
        emit(state.copyWith(
            loginStatus: LoginStatus.success,
            message: "Login successfully!", userModel: userModel));
      }).catchError((error) {
        emit(state.copyWith(
            loginStatus: LoginStatus.error, message: error.toString()));
      });
    } on FirebaseAuthException catch (e) {
      emit(
          state.copyWith(loginStatus: LoginStatus.success, message: e.message));
    } catch (e) {
      emit(state.copyWith(
          loginStatus: LoginStatus.error, message: e.toString()));
    }
  }
}
