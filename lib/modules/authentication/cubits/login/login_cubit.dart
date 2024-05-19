import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:xstock/modules/authentication/models/user_model.dart';
import 'package:xstock/modules/authentication/repository/user_account_repository.dart';
import 'package:xstock/modules/common/repo/session_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.sessionRepository, this.userAccountRepository)
      : super(LoginState.initial());

  SessionRepository sessionRepository;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  UserAccountRepository userAccountRepository;

  void toggleShowPassword() => emit(state.copyWith(
        isPasswordHidden: !state.isPasswordHidden,
        loginStatus: LoginStatus.initial,
      ));

  void enableAutoValidateMode() => emit(state.copyWith(
        isAutoValidate: true,
        loginStatus: LoginStatus.initial,
      ));

  Future<void> login(String email, String password) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        if (querySnapshot.docs.first.get('email').toString().isNotEmpty) {
          UserCredential credential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);
          if (credential.user != null) {
            await sessionRepository.setLoggedIn(true);
            await userAccountRepository.saveUserInDb(UserModel(
                branch_name: credential.user!.displayName.toString(),
                email: credential.user!.email.toString(),
                user_id: querySnapshot.docs.first.get('user_id')));
            emit(state.copyWith(
                loginStatus: LoginStatus.success,
                message: "Login successfully!"));
          } else {
            emit(state.copyWith(
                loginStatus: LoginStatus.error,
                message: "Something went wrong"));
          }
        } else {
          emit(state.copyWith(
              loginStatus: LoginStatus.error, message: "User not found"));
        }
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
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if(googleUser != null) {
        await GoogleSignIn().signOut();
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: googleUser.email)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          if (querySnapshot.docs.first.get('email').toString().isNotEmpty) {
            final userData = await googleUser.authentication;
            final googleCredential = GoogleAuthProvider.credential(
                accessToken: userData.accessToken, idToken: userData.idToken);
            UserCredential credential = await FirebaseAuth.instance
                .signInWithCredential(googleCredential);
            if (credential.user != null) {
              await sessionRepository.setLoggedIn(true);
              await userAccountRepository.saveUserInDb(UserModel(
                  branch_name: credential.user!.displayName.toString(),
                  email: credential.user!.email.toString(),
                  user_id: querySnapshot.docs.first.get('user_id')));
              emit(state.copyWith(
                  loginStatus: LoginStatus.success,
                  message: "Login successfully!"));
            }else {
              emit(state.copyWith(
                  loginStatus: LoginStatus.success,
                  message: "Something went wrong"));
            }
          } else {
            emit(state.copyWith(
                loginStatus: LoginStatus.userNotFound,googleUser: googleUser));
          }
        } else {
          emit(state.copyWith(
              loginStatus: LoginStatus.userNotFound,googleUser: googleUser));
        }
      }else{
        emit(state.copyWith(
            loginStatus: LoginStatus.error, message: "User not found"));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        emit(state.copyWith(
            loginStatus: LoginStatus.error,
            message: "Email is not valid"));
      } else if (e.code == 'user-not-found') {
        emit(state.copyWith(
            loginStatus: LoginStatus.error,
            message: "User not found"));
      }else{
        emit(state.copyWith(
            loginStatus: LoginStatus.error, message: e.message));
      }
    } catch (e) {
      emit(state.copyWith(
          loginStatus: LoginStatus.error, message: e.toString()));
    }
  }

  Future<void> socialSignUp(String branchName,String userId, GoogleSignInAccount googleUser) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));
    try {
      await users.add({
        'branch_name': branchName,
        'email': googleUser.email,
        "user_id": userId
      }).then((value) async {
        final userData = await googleUser.authentication;
        final googleCredential = GoogleAuthProvider.credential(
            accessToken: userData.accessToken, idToken: userData.idToken);
        UserCredential credential = await FirebaseAuth.instance
            .signInWithCredential(googleCredential);
        if (credential.user != null) {
          await credential.user!
              .updateProfile(displayName: branchName).then((value)async {
            await sessionRepository.setLoggedIn(true);
            await userAccountRepository.saveUserInDb(UserModel(
                branch_name: branchName,
                email: credential.user!.email.toString(),
                user_id: userId));
            emit(state.copyWith(
                loginStatus: LoginStatus.success,
                message: "Login successfully!"));
          });
        }else {
          emit(state.copyWith(
              loginStatus: LoginStatus.success,
              message: "Something went wrong"));
        }
      }).catchError((error) {
        emit(state.copyWith(
            loginStatus: LoginStatus.error,message: error.toString()));
      });
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
          loginStatus: LoginStatus.success,
          message: e.message));
    } catch (e) {
      emit(state.copyWith(
          loginStatus: LoginStatus.error, message: e.toString()));
    }
  }
}
