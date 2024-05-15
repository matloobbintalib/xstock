import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:xstock/config/routes/nav_router.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/core/di/service_locator.dart';
import 'package:xstock/modules/authentication/cubits/signup/signup_cubit.dart';
import 'package:xstock/modules/authentication/cubits/signup/signup_state.dart';
import 'package:xstock/modules/authentication/repository/user_account_repository.dart';
import 'package:xstock/modules/authentication/widgets/password_suffix_widget.dart';
import 'package:xstock/modules/home/pages/home_page.dart';
import 'package:xstock/ui/widgets/input_filed_with_title.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/ui/widgets/toast_loader.dart';
import 'package:xstock/utils/display/display_utils.dart';
import 'package:xstock/utils/utils.dart';
import 'package:xstock/utils/validators/validators.dart';

import '../../../ui/widgets/loading_indicator.dart';

class AddAccountDialog extends StatefulWidget {
  const AddAccountDialog({super.key});

  @override
  State<AddAccountDialog> createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<AddAccountDialog> {
  TextEditingController branchNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  UserAccountRepository userAccountRepository = sl<UserAccountRepository>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(sl()),
      child: Dialog(
        backgroundColor: AppColors.fieldColor,
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.fieldColor)),
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) async {
            if (state.signupStatus == SignupStatus.loading) {
              ToastLoader.show();
            } else if (state.signupStatus == SignupStatus.success) {
              ToastLoader.remove();
              DisplayUtils.showToast(context, state.message);
              NavRouter.pop(context);
            } else if (state.signupStatus == SignupStatus.error) {
              ToastLoader.remove();
              DisplayUtils.showErrorToast(context, state.message);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 23, vertical: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child: Text(
                      "Add Account",
                      style: context.textTheme.headlineMedium?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )),
                    SizedBox(
                      height: 30,
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
                      suffixMargin: 0,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    InputFieldWithTitle(
                      floatingHint: 'Password',
                      hint: '************',
                      suffixMargin: 0,
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
                      onPressed: () async {
                        if (Validators.isNotEmpty(
                            context,
                            "Branch Name",
                            branchNameController.text
                                .trim()
                                .toString())) {
                          if (Validators.isValidEmail(context,
                              emailController.text.trim().toString())) {
                            if (Validators.isValidPassword(
                                context,
                                passwordController.text
                                    .trim()
                                    .toString())) {
                              context.read<SignupCubit>().signup(
                                  branchNameController.text
                                      .trim()
                                      .toString(),
                                  emailController.text.trim().toString(),
                                  passwordController.text
                                      .trim()
                                      .toString(),
                                  userAccountRepository.getUserFromDb().user_id);
                            }
                          }
                        }
                      },
                      title: 'Done',
                      titleColor: Colors.black,
                      width: 200,
                      height: 56,
                      borderRadius: 28,
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

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }
}
