import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xstock/config/config.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/constants/asset_paths.dart';
import 'package:xstock/modules/authentication/cubits/login/login_cubit.dart';
import 'package:xstock/modules/authentication/cubits/login/login_state.dart';
import 'package:xstock/modules/authentication/pages/forgot_password_page.dart';
import 'package:xstock/modules/authentication/widgets/password_suffix_widget.dart';
import 'package:xstock/ui/widgets/input_filed_with_title.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/ui/widgets/toast_loader.dart';
import 'package:xstock/utils/extensions/extended_context.dart';
import 'package:xstock/utils/validators/validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) async {
            if (state.loginStatus == LoginStatus.loading) {
              ToastLoader.show();
            } else if (state.loginStatus == LoginStatus.success) {
              ToastLoader.remove();
            } else if (state.loginStatus == LoginStatus.error) {
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
                    Image.asset(
                      AssetPaths.appLogo,
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
                      validator: Validators.email,
                      maxLines: 1,
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
                      validator: Validators.password,
                      suffixIcon: PasswordSuffixIcon(
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
                      onPressed: () {},
                      title: 'Sign In',
                      titleColor: Colors.black,
                      width: 200,
                      height: 56,
                      borderRadius: 28,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Platform.isAndroid
                        ? PrefixIconButton(
                      onPressed: () {},
                      title: 'Sign in with Google',
                      prefixIconPath: 'assets/images/svg/ic_google.svg',
                      borderRadius: 20,
                      height: 64,
                      fontSize: 14,
                      prefixIconSize: 30,
                      titleColor: Colors.white,
                      backgroundColor: AppColors.fieldColor,
                      borderColor: AppColors.fieldColor,
                    )
                        : PrefixIconButton(
                      onPressed: () {},
                      title: 'Sign in with Apple',
                      prefixIconPath: 'assets/images/svg/ic_google.svg',
                      borderRadius: 20,
                      height: 64,
                      fontSize: 14,
                      prefixIconSize: 30,
                      titleColor: Colors.white,
                      backgroundColor: AppColors.fieldColor,
                      borderColor: AppColors.fieldColor,
                    ),
                    SizedBox(height: 80,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Brought to you by ',
                          style: context.textTheme.bodyMedium,),
                        Text('Kopi Kups ',
                            style: context.textTheme.bodyMedium?.copyWith(
                                color: context.colorScheme.primary))
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
}
