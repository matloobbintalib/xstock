import 'package:flutter/material.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import '../../config/config.dart';
class CustomBottomSheet {
  static Future<String> authBottomSheet(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
          )),
      builder: (context) {
        return SafeArea(
          child: Container(
            padding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 6,
                    width: 34,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Log in or Sign up',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                    title: 'LOGIN',
                    onPressed: () {
                      NavRouter.pop(context);
                      // NavRouter.pushWithAnimation(context, const LoginPage());
                    }),
                const SizedBox(height: 20),
                PrimaryButton(
                    title: 'SIGN UP',
                    onPressed: () {
                      NavRouter.pop(context);
                      // NavRouter.pushWithAnimation(context, const WelcomePage());
                    }),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    ) ??
        Future.value('nothing');
  }
}