import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/ui/input/input_field.dart';
import 'package:xstock/ui/widgets/appbar_widget.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/ui/widgets/toast_loader.dart';
import 'package:xstock/utils/display/display_utils.dart';
import 'package:xstock/utils/extensions/extended_context.dart';
import 'package:xstock/utils/validators/email_validator.dart';
import 'package:xstock/utils/validators/validators.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 36, vertical: 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10,),
              AppbarWidget(title: 'Forgot\nPassword',),
              SizedBox(
                height: 70,
              ),
              SvgPicture.asset("assets/images/svg/ic_forgot_password.svg"),
              SizedBox(height: 40,),
              Text("Forgot your Password?",style: context.textTheme.headlineMedium?.copyWith(fontSize: 22),),
              SizedBox(height: 6,),
              Text("Please Enter the Emil Associated with\nyour Account. We'll mail you a link to\nReset your Password.",style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w300),textAlign: TextAlign.center,),
              SizedBox(height: 80,),
              Align(
                alignment: Alignment.centerLeft,
                  child: Text('Email Address',style: context.textTheme.bodySmall,)),
              SizedBox(height: 8,),
              InputField(keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  maxLines: 1,
                  verticalPadding: 22,
                  fontSize: 14,
                  validator: Validators.email, label: 'abc@gmail.com', textInputAction: TextInputAction.done),
              SizedBox(height: 30,),
              PrimaryButton(
                onPressed: _forgotPassword,
                title: 'Send',
                titleColor: Colors.white,
                borderColor: context.colorScheme.secondary,
                backgroundColor: context.colorScheme.secondary,
                width: 200,
                height: 56,
                borderRadius: 28,
              ),
              SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _forgotPassword() async {
    if (emailController.text.trim().isNotEmpty) {
      if (EmailValidator.validate(emailController.text.trim().toString())) {
        ToastLoader.show();
        await FirebaseAuth.instance.sendPasswordResetEmail(
            email: emailController.text.trim().toString()).then((value) {
              ToastLoader.remove();
              emailController.text = '';
          DisplayUtils.showToast(context, "Reset link has been sent to your email, please check your email");
        }).onError((error, stackTrace) {
          ToastLoader.remove();
          DisplayUtils.showErrorToast(context, error.toString());
        });
      } else {
        DisplayUtils.showErrorToast(context, "Enter a valid email address");
      }
    } else {
      DisplayUtils.showErrorToast(context, "Enter your email address");
    }
  }
}
