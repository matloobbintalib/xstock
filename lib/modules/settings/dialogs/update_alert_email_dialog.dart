import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xstock/config/routes/nav_router.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/modules/authentication/cubits/signup/signup_cubit.dart';
import 'package:xstock/modules/authentication/cubits/signup/signup_state.dart';
import 'package:xstock/modules/authentication/widgets/password_suffix_widget.dart';
import 'package:xstock/modules/home/pages/home_page.dart';
import 'package:xstock/ui/widgets/input_filed_with_title.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/ui/widgets/toast_loader.dart';
import 'package:xstock/utils/utils.dart';
import 'package:xstock/utils/validators/validators.dart';

class UpdateAlertEmailDialog extends StatefulWidget {
  const UpdateAlertEmailDialog({super.key});

  @override
  State<UpdateAlertEmailDialog> createState() => _UpdateAlertEmailDialogState();
}

class _UpdateAlertEmailDialogState extends State<UpdateAlertEmailDialog> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.fieldColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.fieldColor)),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 23,vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: Text(
                    "Alert Email",
                    style: context.textTheme.headlineMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  )),
              SizedBox(
                height: 30,
              ),
              InputFieldWithTitle(
                floatingHint: 'Email',
                hint: 'abc@gmail.com',
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
              ),
              SizedBox(
                height: 30,
              ),
              PrimaryButton(
                onPressed: () {
                  NavRouter.pop(context);
                },
                title: 'Done',
                titleColor: Colors.black,
                width: 200,
                height: 56,
                borderRadius: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
