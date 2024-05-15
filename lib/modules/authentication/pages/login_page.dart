import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:xstock/config/config.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/constants/asset_paths.dart';
import 'package:xstock/core/di/service_locator.dart';
import 'package:xstock/modules/authentication/cubits/login/login_cubit.dart';
import 'package:xstock/modules/authentication/cubits/login/login_state.dart';
import 'package:xstock/modules/authentication/pages/forgot_password_page.dart';
import 'package:xstock/modules/authentication/pages/signup_page.dart';
import 'package:xstock/modules/authentication/widgets/password_suffix_widget.dart';
import 'package:xstock/modules/common/repo/session_repository.dart';
import 'package:xstock/modules/home/pages/home_page.dart';
import 'package:xstock/modules/subscription/pages/subscription_page.dart';
import 'package:xstock/ui/widgets/input_filed_with_title.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/ui/widgets/toast_loader.dart';
import 'package:xstock/utils/display/display_utils.dart';
import 'package:xstock/utils/extensions/extended_context.dart';
import 'package:xstock/utils/validators/validators.dart';

import '../../../utils/validators/email_validator.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(sl(),sl()),
      child: LoginPageView(),
    );
  }
}

class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});

  @override
  State<LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  SessionRepository sessionRepository = sl<SessionRepository>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) async {
          if (state.loginStatus == LoginStatus.loading) {
            ToastLoader.show();
          } else if (state.loginStatus == LoginStatus.success) {
            ToastLoader.remove();
            DisplayUtils.showToast(context, state.message);
            NavRouter.pushAndRemoveUntilWithAnimation(context, HomePage(),
                type: PageTransitionType.size, hasAlignment: true);
          } else if (state.loginStatus == LoginStatus.error) {
            ToastLoader.remove();
            DisplayUtils.showErrorToast(context, state.message);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 36, vertical: 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/png/login_app_logo.png',
                    width: 184,
                    height: 128,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InputFieldWithTitle(
                    floatingHint: 'Email',
                    hint: 'abc@gmail.com',
                    controller: emailController,
                    maxLines: 1,
                    suffixMargin: 16,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  InputFieldWithTitle(
                    floatingHint: 'Password',
                    hint: '************',
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    maxLines: 1,
                    suffixMargin: 0,
                    suffixIcon: PasswordSuffixIcon(
                      iconSize: 16,
                      isPasswordVisible: !state.isPasswordHidden,
                      onTap: () {
                        context.read<LoginCubit>().toggleShowPassword();
                      },
                    ),
                    obscureText: state.isPasswordHidden,
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          onPressed: () {
                            NavRouter.push(context, ForgotPasswordPage());
                          },
                          icon: Text(
                            "Forgot Password?",
                            style: context.textTheme.bodyMedium,
                          ))),
                  SizedBox(
                    height: 24,
                  ),
                  PrimaryButton(
                    onPressed: _signIn,
                    title: 'Sign In',
                    titleColor: Colors.black,
                    width: 200,
                    height: 56,
                    borderRadius: 28,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  PrefixIconButton(
                    onPressed: () async {

                    },
                    title: 'Sign in with Google',
                    prefixIconPath: 'assets/images/svg/ic_google.svg',
                    borderRadius: 20,
                    height: 64,
                    fontSize: 14,
                    prefixIconSize: 30,
                    titleColor: Colors.white,
                    backgroundColor: AppColors.fieldColor,
                    borderColor: AppColors.fieldColor,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  PrefixIconButton(
                    onPressed: () {},
                    title: 'Sign in with Apple',
                    prefixIconPath: 'assets/images/svg/ic_apple.svg',
                    borderRadius: 20,
                    height: 64,
                    fontSize: 14,
                    prefixIconSize: 30,
                    titleColor: Colors.white,
                    backgroundColor: AppColors.fieldColor,
                    borderColor: AppColors.fieldColor,
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Brought to you by ',
                        style: context.textTheme.bodyMedium,
                      ),
                      Text('Kopi Kups ',
                          style: context.textTheme.bodyMedium
                              ?.copyWith(color: context.colorScheme.primary))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have account?",
                        style: context.textTheme.bodyMedium,
                      ),
                      IconButton(
                        onPressed: () {
                          NavRouter.pushReplacement(context, SignUpPage());
                        },
                        icon: Text(
                          'Sign Up',
                          style: context.textTheme.bodyMedium
                              ?.copyWith(color: context.colorScheme.primary),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _signIn() async {
    if(Validators.isValidEmail(context, emailController.text.trim().toString())){
      if(Validators.isValidPassword(context, passwordController.text.trim().toString())){
        context.read<LoginCubit>().login(
            emailController.text.trim().toString(),
            passwordController.text.trim().toString());
      }
    }
  }

  void signInWithGoogle() async {
    try {
      ToastLoader.show();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print(googleUser);
      if (googleUser != null) {
        await GoogleSignIn().signOut();
        final userData = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
            accessToken: userData.accessToken, idToken: userData.idToken);
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          await sessionRepository.setLoggedIn(true);
          ToastLoader.remove();
          DisplayUtils.showToast(context, "Login successfully!");
          NavRouter.pushAndRemoveUntilWithAnimation(context, HomePage(),
              type: PageTransitionType.size, hasAlignment: true);
        });
      } else {
        ToastLoader.remove();
      }
    } catch (e) {
      ToastLoader.remove();
      if (e is PlatformException) {
        DisplayUtils.showErrorToast(context,'PlatformException : ${e.message}');
      } else {
        DisplayUtils.showErrorToast(context,'Exception : $e');
      }
    }
  }
}
