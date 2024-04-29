import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/config/config.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/constants/asset_paths.dart';
import 'package:xstock/modules/authentication/cubits/signup/signup_cubit.dart';
import 'package:xstock/modules/authentication/cubits/signup/signup_state.dart';
import 'package:xstock/modules/authentication/pages/login_page.dart';
import 'package:xstock/modules/authentication/widgets/password_suffix_widget.dart';
import 'package:xstock/ui/widgets/input_filed_with_title.dart';
import 'package:xstock/ui/widgets/on_click.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/ui/widgets/toast_loader.dart';
import 'package:xstock/utils/extensions/extended_context.dart';
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
              SizedBox(height: 10,),
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: OnClick(onTap: (){
                        Navigator.pop(context);
                      }, child: SvgPicture.asset("assets/images/svg/ic_back.svg"))),
                  Align(
                    alignment: Alignment.center,
                      child: Text("Sign Up",textAlign:TextAlign.center,style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600,fontSize: 36),))
                ],
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
                validator: Validators.required,
              ),
              SizedBox(
                height: 24,
              ),InputFieldWithTitle(
                floatingHint: 'Email',
                hint: 'abc@gmail.com',
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                validator: Validators.email,
              ),
              SizedBox(
                height: 24,
              ),
              InputFieldWithTitle(
                floatingHint: 'Password',
                hint: '************',
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                validator: Validators.password,
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
                onPressed: () {},
                title: 'Register',
                titleColor: Colors.black,
                width: 200,
                height: 56,
                borderRadius: 28,
              ),
              SizedBox(
                height: 40,
              ),
              Platform.isAndroid
                  ? PrefixIconButton(
                onPressed: () {},
                title: 'Sign in with Google',
                prefixIconPath: 'assets/images/svg/ic_google.svg',
                prefixIconSize: 30,
                borderRadius: 20,
                height: 64,
                fontSize: 14,
                titleColor: Colors.white,
                backgroundColor: AppColors.fieldColor,
                borderColor: AppColors.fieldColor,
              )
                  : PrefixIconButton(
                onPressed: () {},
                title: 'Sign in with Apple',
                prefixIconPath: 'assets/images/svg/ic_google.svg',
                borderRadius: 20,
                prefixIconSize: 30,
                height: 64,
                fontSize: 14,
                titleColor: Colors.white,
                backgroundColor: AppColors.fieldColor,
                borderColor: AppColors.fieldColor,
              ),
              SizedBox(height: 70,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?',style: context.textTheme.bodyMedium,),
                  IconButton(onPressed: (){
                    NavRouter.pushReplacement(context, LoginPage());
                  }, icon: Text('Sign In',style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.primary),),)
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
