import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/config/config.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/core/di/service_locator.dart';
import 'package:xstock/modules/authentication/pages/login_page.dart';
import 'package:xstock/modules/authentication/repository/user_account_repository.dart';
import 'package:xstock/modules/common/repo/session_repository.dart';
import 'package:xstock/modules/settings/dialogs/add_account_dialog.dart';
import 'package:xstock/modules/settings/dialogs/import_from_cvs_dialog.dart';
import 'package:xstock/modules/settings/dialogs/switch_account_dialog.dart';
import 'package:xstock/modules/settings/dialogs/update_alert_email_dialog.dart';
import 'package:xstock/modules/settings/dialogs/wipe_data_dialog.dart';
import 'package:xstock/modules/settings/models/account_title_model.dart';
import 'package:xstock/modules/settings/pages/privacy_policy_page.dart';
import 'package:xstock/modules/settings/widgets/account_tile.dart';
import 'package:xstock/modules/settings/widgets/phone_varification_widget.dart';
import 'package:xstock/modules/settings/widgets/settings_tile.dart';
import 'package:xstock/modules/settings/widgets/slide_able_action.dart';
import 'package:xstock/modules/startup/auth_page.dart';
import 'package:xstock/ui/dialogs/dialogs.dart';
import 'package:xstock/ui/widgets/appbar_widget.dart';
import 'package:xstock/ui/widgets/on_click.dart';
import 'package:xstock/ui/widgets/toast_loader.dart';
import 'package:xstock/utils/display/display_utils.dart';
import 'package:xstock/utils/extensions/extended_context.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:firebase_admin/src/auth/user_record.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  UserAccountRepository userAccountRepository = sl<UserAccountRepository>();

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
                title: 'Settings',
              ),
              SizedBox(
                height: 18,
              ),
              PhoneVerificationWidget(
                title: 'Phone Vibration',
                onTap: () {},
              ),
              Slidable(
                closeOnScroll: false,
                startActionPane: ActionPane(
                  motion: const BehindMotion(),
                  children: [
                    SlidableActionTest(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.red,
                      borderRadius: BorderRadius.circular(16),
                      spacing: 12,
                      foregroundColor: Colors.white,
                      icon: 'assets/images/svg/ic_delete.svg',
                      onPressed: (BuildContext context) {
                        DisplayUtils.showToast(context, 'title');
                      },
                    )
                  ],
                ),
                child: AccountTile(
                  model: AccountTitleModel(
                      name: userAccountRepository.getUserFromDb().branch_name, email: userAccountRepository.getUserFromDb().email, id: userAccountRepository.getUserFromDb().user_id),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              OnClick(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SwitchAccountDialog();
                        }).then((value) {
                          setState(() {

                          });
                    });
                  },
                  child: Image.asset("assets/images/png/switch_button.png")),
              SizedBox(
                height: 20,
              ),
              OnClick(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddAccountDialog();
                        });
                  },
                  child:
                  Image.asset("assets/images/png/add_account_button.png")),
              SizedBox(
                height: 20,
              ),
              SettingsTile(
                title: 'Import Form CSV',
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ImportFromCvsDialog();
                      });
                },
              ),
              SettingsTile(
                title: 'Email Feedback',
                onTap: () {},
              ),
              SettingsTile(
                title: 'Privacy Policy',
                onTap: () {
                  NavRouter.pushWithAnimation(context, PrivacyPolicyPage());
                },
              ),
              SettingsTile(
                title: 'Clear all Data',
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return WipeDataDialog();
                      });
                },
              ),
              SettingsTile(
                title: 'Logout',
                onTap: ()async {
                  try {
                    bool isLogged = await Dialogs.showLogOutConfirmationDialog(context);
                    if(isLogged){
                      ToastLoader.show();
                      await FirebaseAuth.instance.signOut().then((value)async {
                        await userAccountRepository.logout();
                        ToastLoader.remove();
                        DisplayUtils.showToast(context, 'Logout successfully');
                        NavRouter.pushAndRemoveUntil(
                            context, LoginPage());
                      }).onError((error, stackTrace) {
                        ToastLoader.remove();
                        DisplayUtils.showToast(context, error.toString());
                      });
                    }
                  }catch (e) {
                    ToastLoader.remove();
                    DisplayUtils.showToast(context, e.toString());
                  }
                },
              ),
              OnClick(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                      color: AppColors.fieldColor,
                      borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Minimum Stock Alert",
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DottedLine(
                        direction: Axis.horizontal,
                        dashColor: Colors.white.withOpacity(.17),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Email : jone@deper.one",
                              style: context.textTheme.bodyMedium,
                            ),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          OnClick(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return UpdateAlertEmailDialog();
                                  });
                            },
                            child: SvgPicture.asset(
                              "assets/images/svg/ic_edit_item.svg",
                              width: 20,
                              height: 20,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
