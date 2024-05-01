import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:xstock/modules/settings/dialogs/import_from_cvs_dialog.dart';
import 'package:xstock/modules/settings/dialogs/switch_account_dialog.dart';
import 'package:xstock/modules/settings/models/account_title_model.dart';
import 'package:xstock/modules/settings/widgets/account_tile.dart';
import 'package:xstock/modules/settings/widgets/phone_varification_widget.dart';
import 'package:xstock/modules/settings/widgets/settings_tile.dart';
import 'package:xstock/modules/settings/widgets/slide_able_action.dart';
import 'package:xstock/ui/widgets/appbar_widget.dart';
import 'package:xstock/ui/widgets/on_click.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
                      onPressed: (BuildContext context) {},
                    )
                  ],
                ),
                child: AccountTile(
                  model: AccountTitleModel(
                      name: "jone deper", email: "jone@deper.one", id: 1),
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
                        });
                  },
                  child: Image.asset("assets/images/png/switch_button.png")),
              SizedBox(
                height: 20,
              ),
              OnClick(
                  onTap: () {},
                  child:
                      Image.asset("assets/images/png/add_account_button.png")),
              SizedBox(
                height: 20,
              ),
              SettingsTile(title: 'Import Form CSV', onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ImportFromCvsDialog();
                    });
              },),
              SettingsTile(title: 'Email Feedback', onTap: () {  },),
              SettingsTile(title: 'Privacy Policy', onTap: () {  },),
              SettingsTile(title: 'Clear all Data', onTap: () {  },),
            ],
          ),
        ),
      ),
    );
  }
}
