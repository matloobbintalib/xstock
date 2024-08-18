import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:xstock/ui/input/input_field.dart';
import 'package:xstock/ui/widgets/appbar_widget.dart';
import 'package:xstock/ui/widgets/custom_appbar.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/utils/display/display_utils.dart';
import 'package:xstock/utils/extensions/extended_context.dart';
import '../../../constants/app_colors.dart';
import '../../../core/di/service_locator.dart';

class SupportScreen extends StatefulWidget {
  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> attachments = [];
  bool isHTML = false;

  Future<void> sendEmail() async {
    DisplayUtils.showLoader();
    final Email email = Email(
      body: messageController.text,
      subject: "Support Email",
      recipients: ['info@kopikups.co.uk'],
      attachmentPaths: attachments,
      isHTML: false,
    );

    await FlutterEmailSender.send(email).then((value){
      DisplayUtils.removeLoader();
      messageController.clear();
      DisplayUtils.showToast(context, 'Email send successfully!');
    }).onError((error, stackTrace) {
      DisplayUtils.removeLoader();
      print("Error sending email: " + error.toString());
      DisplayUtils.showErrorToast(context, error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 24),
          child: Column(
            children: [
              AppbarWidget(
                title: '',
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    /*Center(
                      child: Text(
                        'Contact Our Team',
                        style: context.textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: 30),
                    InputField.email(
                      label: 'Email',
                      controller: emailController,
                    ),*/
                    SizedBox(height: 30,),
                    InputField(
                      label: 'Write your feedback here',
                      controller: messageController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 14, textInputAction: TextInputAction.done,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    PrimaryButton(onPressed: (){
                      if (messageController.text.isNotEmpty) {
                        sendEmail();
                      } else {
                        DisplayUtils.showErrorToast(context,
                            "Please enter message...");
                      }
                    }, title: "Send")
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
