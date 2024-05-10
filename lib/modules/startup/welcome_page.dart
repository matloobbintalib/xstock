import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/config/config.dart';
import 'package:xstock/modules/authentication/pages/login_page.dart';
import 'package:xstock/modules/authentication/pages/signup_page.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // For Android (dark icons)
      statusBarBrightness: Brightness.light,
    ));
    return Scaffold(

      body: Stack(
        children: [
          Image.asset(
            "assets/images/png/welcome_background.png",
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 230),
                    child: Image.asset("assets/images/png/welcome_text.png",width: 270,height: 237,)),
                SizedBox(height: 30),
               Text('Access your data everywhere and share them with others',style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w200),),
                SizedBox(height: 20,),
                PrimaryButton(
                  onPressed: () {
                    NavRouter.push(context, SignUpPage());
                  },
                  title: 'Get Started',
                  titleColor: context.colorScheme.secondary,
                  backgroundColor:context.colorScheme.primary,
                  borderColor: context.colorScheme.primary,
                  width: 200,
                  height: 56,
                  borderRadius: 28,
                ),
                SizedBox(height: 20,),
                PrimaryButton(
                  onPressed: () {
                    NavRouter.push(context, LoginPage());
                  },
                  title: 'Sign In',
                  titleColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  width: 140,
                  borderColor: context.colorScheme.background,
                  height: 56,
                  borderRadius: 28,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
