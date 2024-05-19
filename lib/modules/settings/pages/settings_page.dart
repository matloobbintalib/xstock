import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:file_picker/file_picker.dart';
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
import 'package:xstock/modules/home/models/group_data_model.dart';
import 'package:xstock/modules/home/models/item_data_model.dart';
import 'package:xstock/modules/settings/dialogs/add_account_dialog.dart';
import 'package:xstock/modules/settings/dialogs/import_from_cvs_dialog.dart';
import 'package:xstock/modules/settings/dialogs/switch_account_dialog.dart';
import 'package:xstock/modules/settings/dialogs/update_alert_email_dialog.dart';
import 'package:xstock/modules/settings/dialogs/wipe_data_dialog.dart';
import 'package:xstock/modules/settings/models/account_title_model.dart';
import 'package:xstock/modules/settings/pages/load_and_view_csv_page.dart';
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
import 'dart:io';
import 'package:csv/csv.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  UserAccountRepository userAccountRepository = sl<UserAccountRepository>();
  CollectionReference groups = FirebaseFirestore.instance.collection('groups');
  CollectionReference items = FirebaseFirestore.instance.collection('items');


  List<Map<String, dynamic>> convertToMap1(List<GroupItem> groupItems) {
    return groupItems.map((item) {
      return {
        "name": item.name,
        "type": item.type,
        "color": item.color,
        "count": item.count,
      };
    }).toList();
  }


  Future<List<List<dynamic>>> _loadCsvData(String path)  {
    final file = new File(path).openRead();
    return  file
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();
  }

  List<GroupDataModel> convertToObjects(Map<String, List<Map<String, dynamic>>> groupedData) {
    List<GroupDataModel> groups = [];
    groupedData.forEach((groupName, itemList) {
      List<ItemDataModel> items = itemList.map((item) {
        return ItemDataModel(
          itemName: item['type'],
          itemColor: item['color'],
          itemCount: item['count'],
        );
      }).toList();
      groups.add(GroupDataModel(groupName: groupName, items: items));
    });

    return groups;
  }

  Future<void> uploadDataToFireStore(List<GroupDataModel> list) async{
    list.forEach((element) async{
      await groups.add({
        'group_name': element.groupName,
        'is_extendable': true,
        "user_id": userAccountRepository.getUserFromDb().user_id
      }).then((value) {
        element.items.forEach((item)async {
          await items.add({
            'group_id': value.id,
            'color_code': item.itemColor,
            "item_name": item.itemName,
            "item_count": item.itemCount
          });
        });
      }).onError((error, stackTrace){
        ToastLoader.remove();
        DisplayUtils.showToast(context, error.toString());
      });
    });
  }

  Map<String, List<Map<String, dynamic>>> groupItemsByValue(
      List<Map<String, dynamic>> items, String key) {
    Map<String, List<Map<String, dynamic>>> groupedData = {};

    for (var item in items) {
      String value = item[key].toString();

      if (groupedData.containsKey(value)) {
        groupedData[value]!.add(item);
      } else {
        groupedData[value] = [item];
      }
    }

    return groupedData;
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
                title: 'Export As CSV',
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ImportFromCvsDialog();
                      });
                },
              ),
              SettingsTile(
                title: 'Import Form CSV',
                onTap: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles();
                  if (result != null) {
                    String? path = result.files.first.path;
                    if(path != null) {
                      if(path.contains('.cvs')){
                        File file = File(result.files.single.path!);
                        DisplayUtils.flutterShowToast('Uploading data...');
                        ToastLoader.show();
                        _loadCsvData(file.path).then((value) async {
                          List<GroupItem> groupItems = convertToGroupItems(value);
                          List<Map<String, dynamic>> items = convertToMap1(groupItems);
                          List<GroupDataModel> list = convertToObjects(groupItemsByValue(items, 'name'));
                          await uploadDataToFireStore(list);
                          ToastLoader.remove();
                          DisplayUtils.flutterShowToast('Data uploaded successfully');
                        }).onError((error, stackTrace) {
                          ToastLoader.remove();
                          DisplayUtils.flutterShowToast(error.toString());
                        });
                      }else{
                        DisplayUtils.showErrorToast(context, 'Invalid CSV file');
                      }
                    }else{
                      DisplayUtils.showErrorToast(context, 'Invalid CSV file');
                    }
                  } else {
                    // User canceled the picker
                  }
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
