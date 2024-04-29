import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/config/config.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/constants/asset_paths.dart';
import 'package:xstock/modules/authentication/pages/login_page.dart';
import 'package:xstock/ui/input/input_field.dart';
import 'package:xstock/ui/widgets/input_filed_with_title.dart';
import 'package:xstock/ui/widgets/on_click.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/utils/extensions/extended_context.dart';
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
                      child: Text("Forgot\nPassword",textAlign:TextAlign.center,style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600,fontSize: 36),))
                ],
              ),
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
                onPressed: () {},
                title: 'Send',
                titleColor: Colors.white,
                borderColor: context.colorScheme.secondary,
                backgroundColor: context.colorScheme.secondary,
                width: 200,
                height: 56,
                borderRadius: 28,
              ),
              SizedBox(height:40,)
            ],
          ),
        ),
      ),
    );
  }
}
