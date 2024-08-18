import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xstock/config/config.dart';
import 'package:xstock/constants/constants.dart';
import 'package:xstock/core/di/service_locator.dart';
import 'package:xstock/modules/authentication/models/user_model.dart';
import 'package:xstock/modules/authentication/pages/login_page.dart';
import 'package:xstock/modules/authentication/repository/user_account_repository.dart';
import 'package:xstock/modules/common/repo/session_repository.dart';
import 'package:xstock/modules/home/models/group_data_model.dart';
import 'package:xstock/modules/home/models/item_model.dart';
import 'package:xstock/modules/settings/dialogs/add_account_dialog.dart';
import 'package:xstock/modules/settings/dialogs/import_from_cvs_dialog.dart';
import 'package:xstock/modules/settings/dialogs/switch_account_dialog.dart';
import 'package:xstock/modules/settings/dialogs/update_alert_email_dialog.dart';
import 'package:xstock/modules/settings/dialogs/wipe_data_dialog.dart';
import 'package:xstock/modules/settings/pages/support_screen.dart';
import 'package:xstock/modules/settings/widgets/account_tile.dart';
import 'package:xstock/modules/settings/widgets/phone_varification_widget.dart';
import 'package:xstock/modules/settings/widgets/settings_tile.dart';
import 'package:xstock/ui/dialogs/dialogs.dart';
import 'package:xstock/ui/widgets/appbar_widget.dart';
import 'package:xstock/ui/widgets/empty_widget.dart';
import 'package:xstock/ui/widgets/loading_indicator.dart';
import 'package:xstock/ui/widgets/on_click.dart';
import 'package:xstock/ui/widgets/toast_loader.dart';
import 'package:xstock/utils/display/display_utils.dart';
import 'package:xstock/utils/extensions/context_user.dart';
import 'package:xstock/utils/extensions/extended_context.dart';
import 'package:xstock/utils/urls/urls.dart';

import '../../user/cubits/user_cubit.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  UserAccountRepository userAccountRepository = sl<UserAccountRepository>();
  SessionRepository sessionRepository = sl<SessionRepository>();
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection(Endpoints.usersTable);

  @override
  Widget build(BuildContext context) {
    var user = context.watchCurrentUser;
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
                onTap: () async {},
              ),
              Slidable(
                  closeOnScroll: false,
                  useTextDirection: true,
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      CustomSlidableAction(
                          onPressed: (BuildContext ctx) async {
                            bool isLogged = await Dialogs
                                .showDeleteAccountConfirmationDialog(context);
                            if (isLogged) {
                              ToastLoader.show();
                              deleteAccountPermanently(user);
                            }
                          },
                          backgroundColor: Colors.black,
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(16)),
                            padding: EdgeInsets.all(18),
                            child: SvgPicture.asset(
                                'assets/images/svg/ic_delete.svg'),
                          ))
                    ],
                  ),
                  child: AccountTile(
                    model: UserModel(
                        branchName: user.branchName,
                        email: user.email,
                        deviceId: user.deviceId,
                        alertEmail: user.alertEmail,
                        id: user.id),
                  )),
              SizedBox(
                height: 10,
              ),
              OnClick(
                  onTap: () async {
                    String deviceId = await getDeviceUUID();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SwitchAccountDialog(
                            deviceId: deviceId,
                          );
                        }).then((value) {
                      context.read<UserCubit>().loadUser();
                      setState(() {});
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
                        return ImportFromCvsDialog(
                          userModel: user,
                        );
                      });
                },
              ),
              SettingsTile(
                title: 'Import Form CSV',
                onTap: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    String? path = result.files.first.path;
                    if (path != null) {
                      if (path.contains('.cvs')) {
                        File file = File(result.files.single.path!);
                        DisplayUtils.flutterShowToast('Uploading data...');
                        ToastLoader.show();
                        _loadCsvData(file.path).then((value) async {
                          print(value);
                          List<GroupItem> groupItems =
                              convertToGroupItems(value);
                          List<GroupDataModel> groups =
                              groupItemsByName(groupItems);
                          await uploadDataToFireStore(
                              groups, user.id.toString());
                          ToastLoader.remove();
                          DisplayUtils.flutterShowToast(
                              'Data uploaded successfully');
                        }).onError((error, stackTrace) {
                          ToastLoader.remove();
                          DisplayUtils.flutterShowToast(error.toString());
                        });
                      } else {
                        DisplayUtils.showErrorToast(
                            context, 'Invalid CSV file');
                      }
                    } else {
                      DisplayUtils.showErrorToast(context, 'Invalid CSV file');
                    }
                  } else {
                    // User canceled the picker
                  }
                },
              ),
              SettingsTile(
                title: 'Email Feedback',
                onTap: () {
                  NavRouter.push(context, SupportScreen());
                },
              ),
              SettingsTile(
                title: 'Privacy Policy',
                onTap: () {
                  Urls.showPrivacyPolicy();
                },
              ),
              SettingsTile(
                title: 'Clear all Data',
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return WipeDataDialog(
                          userModel: user,
                        );
                      });
                },
              ),
              SettingsTile(
                title: 'Logout',
                onTap: () async {
                  try {
                    bool isLogged =
                        await Dialogs.showLogOutConfirmationDialog(context);
                    if (isLogged) {
                      ToastLoader.show();
                      await FirebaseAuth.instance.signOut().then((value) async {
                        await userAccountRepository.logout();
                        ToastLoader.remove();
                        DisplayUtils.showToast(context, 'Logout successfully');
                        NavRouter.pushAndRemoveUntil(context, LoginPage());
                      }).onError((error, stackTrace) {
                        ToastLoader.remove();
                        DisplayUtils.showToast(context, error.toString());
                      });
                    }
                  } catch (e) {
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
                      StreamBuilder(
                        stream: usersCollection.doc(user.id).snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularLoadingIndicator(); // Show loading indicator while fetching data
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }
                          if (snapshot.hasData) {
                            String alertEmail = '';
                            if (snapshot.hasData) {
                              alertEmail = snapshot.data['alert_email'] ?? '';
                            }
                            return Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Email : ${alertEmail}",
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
                                          return UpdateAlertEmailDialog(
                                            userModel: user,
                                          );
                                        });
                                  },
                                  child: SvgPicture.asset(
                                    "assets/images/svg/ic_edit_item.svg",
                                    width: 20,
                                    height: 20,
                                  ),
                                )
                              ],
                            );
                          }

                          return EmptyWidget();
                        },
                      ),
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

  List<GroupItem> convertToGroupItems(List<dynamic>? data) {
    List<GroupItem> groupItems = [];
    if (data != null) {
      for (var item in data) {
        if (item is List<dynamic>) {
          String groupName = item[0] as String;
          String id = item[1] as String;
          String userId = item[2] as String;
          String groupId = item[3] as String;
          int itemColor = item[4] as int;
          int itemCount = item[5] as int;
          String itemName = item[6] as String;
          String expiryDate = item[7] as String;
          int minimumStockAlert = item[8] as int;
          String stockImage = item[9] as String;
          String isEnableExpiry = item[10] as String;
          String createdAt = item[11] as String;
          String itemCreatedAt = item[12] as String;
          GroupItem groupItem = GroupItem(
            id: id,
            groupName: groupName,
            createdAt: createdAt,
            groupId: groupId,
            userId: userId,
            itemColor: itemColor.toString(),
            itemCount: itemCount,
            expiryDate: expiryDate,
            minimumStockAlert: minimumStockAlert,
            stockImage: stockImage,
            isEnableExpiry: isEnableExpiry == 'true' ? true : false,
            itemName: itemName,
            itemCreatedAt: itemCreatedAt,
          );
          groupItems.add(groupItem);
        }
      }
    }

    return groupItems;
  }

  List<GroupDataModel> groupItemsByName(List<GroupItem> groupItems) {
    List<GroupDataModel> groups = [];
    for (int i = 0; i < groupItems.length; i++) {
      for (int j = 0; j < groupItems.length; j++) {
        if (groupItems[i].groupName == groupItems[j].groupName) {
          ItemModel itemModel = ItemModel(
              id: groupItems[j].id,
              userId: groupItems[j].userId,
              color: groupItems[j].itemColor,
              count: groupItems[j].itemCount,
              name: groupItems[j].itemName,
              groupId: groupItems[j].groupId,
              expiryDate: groupItems[j].expiryDate,
              minimumStockAlert: groupItems[j].minimumStockAlert,
              stockImage: groupItems[j].stockImage,
              isEnableExpiry: groupItems[j].isEnableExpiry,
              createdAt: groupItems[j].itemCreatedAt);
          GroupDataModel groupModel = GroupDataModel(
              groupName: groupItems[j].groupName,
              createdAt: groupItems[j].createdAt,
              items: [itemModel],
              id: groupItems[j].groupId,
              userId: groupItems[j].userId);
          groups.add(groupModel);
        }
      }
    }
    return groups;
  }

  Future<List<List<dynamic>>> _loadCsvData(String path) {
    final file = new File(path).openRead();
    return file
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();
  }

  void deleteAccountPermanently(UserModel userModel) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    if (_auth.currentUser != null) {
      await deleteGroupsAndItems(userModel.id.toString()).then((value) async {
        await usersCollection
            .doc(userModel.id.toString())
            .delete()
            .then((value) async {
          await _auth.currentUser!.delete().then((value) async {
            switchUserAccount(userModel);
          }).onError((error, stackTrace) async {
            switchUserAccount(userModel);
          });
        });
      }).catchError((error) {
        ToastLoader.remove();
        DisplayUtils.showErrorToast(context, error.message);
      });
    } else {
      ToastLoader.remove();
      DisplayUtils.showErrorToast(context, 'User not logged in');
    }
  }

  Future<void> switchUserAccount(UserModel userModel) async {
    QuerySnapshot querySnapshot = await usersCollection
        .where('device_id', isEqualTo: userModel.deviceId)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      var user = UserModel(
          id: querySnapshot.docs.first.get('id'),
          branchName: querySnapshot.docs.first.get('branch_name'),
          email: querySnapshot.docs.first.get('email'),
          alertEmail: querySnapshot.docs.first.get('alert_email'),
          deviceId: userModel.deviceId,
          fcmToken: userModel.fcmToken);
      await userAccountRepository.saveUserInDb(user).then((value) async {
        await sessionRepository.setLoggedIn(true);
        await sessionRepository.setItemVibration(false);
        ToastLoader.remove();
        DisplayUtils.showToast(context, 'User switched to remaining account');
        setState(() {});
      });
    } else {
      await userAccountRepository.logout();
      ToastLoader.remove();
      DisplayUtils.showToast(context, 'User deleted successfully');
      NavRouter.pushAndRemoveUntil(context, LoginPage());
    }
  }

  Future<void> deleteGroupsAndItems(String userId) async {
    try {
      CollectionReference groupsCollection =
          usersCollection.doc(userId).collection(Endpoints.groupsTable);
      QuerySnapshot groupSnapshot = await groupsCollection.get();

      for (QueryDocumentSnapshot groupDoc in groupSnapshot.docs) {
        String groupId = groupDoc.id;
        CollectionReference itemsCollection = usersCollection
            .doc(userId)
            .collection(Endpoints.groupsTable)
            .doc(groupId)
            .collection(Endpoints.itemsTable);

        QuerySnapshot itemSnapshot = await itemsCollection.get();
        for (QueryDocumentSnapshot itemDoc in itemSnapshot.docs) {
          await itemsCollection.doc(itemDoc.id).delete();
        }
        await groupsCollection.doc(groupId).delete();
      }
    } catch (e) {
      ToastLoader.remove();
      DisplayUtils.flutterShowToast(e.toString());
      print(e.toString());
    }
  }

  Future<void> uploadDataToFireStore(
      List<GroupDataModel> list, String userId) async {
    list.forEach((element) async {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection(Endpoints.usersTable);
      DocumentReference userRef = await usersCollection.doc(userId);
      CollectionReference groupCollection =
          await userRef.collection(Endpoints.groupsTable);
      await groupCollection
          .doc(element.id)
          .set(element.toMap())
          .then((value) async {
        CollectionReference itemsCollection = await groupCollection
            .doc(element.id)
            .collection(Endpoints.itemsTable);
        element.items.forEach((item) async {
          await itemsCollection.doc(item.id).set(item.toMap());
        });
      });
    });
  }

  Future<String> getDeviceUUID() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // UUID for Android
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      if (iosInfo.identifierForVendor != null) {
        return iosInfo.identifierForVendor.toString(); // UUID for iOS
      } else {
        return '';
      }
    } else {
      return '';
    }
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class GroupItem {
  final String groupId;
  final String userId;
  final String id;
  final String groupName;
  final String createdAt;
  final String itemCreatedAt;
  final String itemColor;
  final int itemCount;
  final String itemName;
  final String expiryDate;
  final int minimumStockAlert;
  final String stockImage;
  final bool isEnableExpiry;

  GroupItem({
    required this.groupId,
    required this.userId,
    required this.id,
    required this.groupName,
    required this.createdAt,
    required this.itemCreatedAt,
    required this.itemColor,
    required this.itemCount,
    required this.itemName,
    required this.expiryDate,
    required this.minimumStockAlert,
    required this.stockImage,
    required this.isEnableExpiry,
  });

  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'user_id': userId,
      'id': id,
      'group_name': groupName,
      'created_at': createdAt,
      'item_created_at': itemCreatedAt,
      'color': itemColor,
      'count': itemCount,
      'name': itemName,
      'minimum_stock_alert': minimumStockAlert,
      'is_enable_expiry': isEnableExpiry,
      'stock_image': stockImage,
      'expiry_date': expiryDate,
    };
  }
}
