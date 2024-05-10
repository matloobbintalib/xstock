import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:xstock/config/config.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/constants/asset_paths.dart';
import 'package:xstock/core/di/service_locator.dart';
import 'package:xstock/modules/authentication/cubits/signup/signup_cubit.dart';
import 'package:xstock/modules/authentication/cubits/signup/signup_state.dart';
import 'package:xstock/modules/authentication/pages/login_page.dart';
import 'package:xstock/modules/authentication/widgets/password_suffix_widget.dart';
import 'package:xstock/modules/common/repo/session_repository.dart';
import 'package:xstock/modules/home/pages/home_page.dart';
import 'package:xstock/ui/widgets/appbar_widget.dart';
import 'package:xstock/ui/widgets/input_filed_with_title.dart';
import 'package:xstock/ui/widgets/on_click.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/ui/widgets/toast_loader.dart';
import 'package:xstock/utils/display/display_utils.dart';
import 'package:xstock/utils/extensions/extended_context.dart';
import 'package:xstock/utils/validators/email_validator.dart';
import 'package:xstock/utils/validators/validators.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController branchNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  SessionRepository sessionRepository = sl<SessionRepository>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) async {
            if (state.signupStatus == SignupStatus.loading) {
              ToastLoader.show();
            } else if (state.signupStatus == SignupStatus.success) {
              ToastLoader.remove();
            } else if (state.signupStatus == SignupStatus.error) {
              ToastLoader.remove();
              context.showSnackBar(state.message);
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
                    SizedBox(
                      height: 10,
                    ),
                    AppbarWidget(
                      title: 'Sign Up',
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    InputFieldWithTitle(
                      floatingHint: 'Branch Name',
                      hint: 'i-e jone deper',
                      maxLines: 1,
                      keyboardType: TextInputType.name,
                      controller: branchNameController,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    InputFieldWithTitle(
                      floatingHint: 'Email',
                      hint: 'abc@gmail.com',
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
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
                      suffixIcon: PasswordSuffixIcon(
                        isPasswordVisible: !state.isPasswordHidden,
                        onTap: () {
                          context.read<SignupCubit>().toggleShowPassword();
                        },
                      ),
                      obscureText: state.isPasswordHidden,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    PrimaryButton(
                      onPressed: _signUp,
                      title: 'Register',
                      titleColor: Colors.black,
                      width: 200,
                      height: 56,
                      borderRadius: 28,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    PrefixIconButton(
                      onPressed: () {
                        signInWithGoogle();
                      },
                      title: 'Sign in with Google',
                      prefixIconPath: 'assets/images/svg/ic_google.svg',
                      prefixIconSize: 30,
                      borderRadius: 20,
                      height: 64,
                      fontSize: 14,
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
                      height: 70,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: context.textTheme.bodyMedium,
                        ),
                        IconButton(
                          onPressed: () {
                            NavRouter.pushReplacement(context, LoginPage());
                          },
                          icon: Text(
                            'Sign In',
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
      ),
    );
  }

  void _signUp() async {
    if(branchNameController.text.trim().isNotEmpty){
      if(emailController.text.trim().isNotEmpty){
        if(EmailValidator.validate(emailController.text.trim().toString())){
          if (passwordController.text.trim().isNotEmpty) {
            if(passwordController.text.trim().length > 7){
              try {
                ToastLoader.show();
                UserCredential credential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                    email: emailController.text.trim().toString(),
                    password: passwordController.text.trim().toString());
                if (credential.user != null) {
                  await credential.user!.updateProfile(
                      displayName: branchNameController.text.trim().toString()).then((value) async{
                    await sessionRepository.setLoggedIn(true);
                    ToastLoader.remove();
                    DisplayUtils.showToast(context, "Register successfully!");
                    NavRouter.pushAndRemoveUntilWithAnimation(context, HomePage(),
                        type: PageTransitionType.size, hasAlignment: true);
                  });
                }else{
                  ToastLoader.remove();
                  context.showSnackBar("Something went wrong");
                }
              }
              on FirebaseAuthException catch (e) {
                ToastLoader.remove();
                if (e.code == 'week-password') {
                  context.showSnackBar("The password provided is to week");
                } else if (e.code == 'email-already-in-use') {
                  context.showSnackBar("Account already exists for that email");
                }
              }catch (e) {
                ToastLoader.remove();
                context.showSnackBar(e.toString());
              }
            }else{
              DisplayUtils.showToast(context, "Password must be at least 8 characters long");
            }
          }else{
            DisplayUtils.showToast(context, "Enter your password");
          }
        }
        else{
          DisplayUtils.showToast(context, "Enter a valid email address");
        }
      }else{
        DisplayUtils.showToast(context, "Enter your email address");
      }
    }else{
      DisplayUtils.showToast(context, "Enter your branch name");
    }
  }

  void signInWithGoogle() async {
    try {
      ToastLoader.show();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print(googleUser);
      if(googleUser != null) {
        await GoogleSignIn().signOut();
        final userData = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
            accessToken: userData.accessToken, idToken: userData.idToken);
        await FirebaseAuth.instance.signInWithCredential(credential).then((value)async {
          await sessionRepository.setLoggedIn(true);
          ToastLoader.remove();
          DisplayUtils.showToast(context, "Login successfully!");
          NavRouter.pushAndRemoveUntilWithAnimation(context, HomePage(),
              type: PageTransitionType.size, hasAlignment: true);
        });
      }else{
        ToastLoader.remove();
      }
    } catch (e) {
      ToastLoader.remove();
      if (e is PlatformException) {
        context.showSnackBar('PlatformException : ${e.message}');
      } else {
        context.showSnackBar('Exception : $e');
      }
    }
  }
}
