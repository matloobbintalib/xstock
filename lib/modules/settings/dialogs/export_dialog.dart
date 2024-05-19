import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xstock/config/routes/nav_router.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/core/di/service_locator.dart';
import 'package:xstock/modules/authentication/repository/user_account_repository.dart';
import 'package:xstock/modules/home/models/group_data_model.dart';
import 'package:xstock/modules/home/models/item_data_model.dart';
import 'package:xstock/modules/settings/pages/load_and_view_csv_page.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/ui/widgets/toast_loader.dart';
import 'package:xstock/utils/display/display_utils.dart';
import 'package:xstock/utils/utils.dart';
import 'dart:io';


class ExportDialog extends StatefulWidget {
  const ExportDialog({super.key});

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  String filePath = '';
  List<GroupDataModel> groupsDataList = [];
  UserAccountRepository userAccountRepository = sl<UserAccountRepository>();


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.fieldColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.fieldColor)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 23) +
            EdgeInsets.only(top: 17, bottom: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: Text(
                  "Export",
                  style: context.textTheme.headlineMedium?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                )),
            SizedBox(
              height: 15,
            ),
            PrimaryButton(
              onPressed: () {},
              title: 'Send via email',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              borderRadius: 10,
              titleColor: Colors.white,
              backgroundColor: Colors.black,
              borderColor: Colors.black,
            ),
            SizedBox(height: 12,), PrimaryButton(
              onPressed: () async{
                /*Map<Permission, PermissionStatus> status = await [Permission.storage].request();
                if(status[Permission.storage]!.isGranted){
                  exportDataToCsvFile();
                }*/
                var isGranted = await _checkAndRequestStoragePermissions();
                if(isGranted){
                  exportDataToCsvFile();
                }
              },
              title: 'Save as file',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              borderRadius: 10,
              titleColor: Colors.white,
              backgroundColor: Colors.black,
              borderColor: Colors.black,
            ),
            SizedBox(height: 12,), PrimaryButton(
              onPressed: () {
                NavRouter.pop(context);
              },
              title: 'Cancel',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              borderRadius: 10,
              titleColor: Colors.white,
              backgroundColor: Colors.black,
              borderColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  static Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    Directory _directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      _directory = Directory("/storage/emulated/0/Download");
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }

    final exPath = _directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  void exportCSV() async {
    List<List<dynamic>> rows = [];
    for(var group in groupsDataList){
      String groupName = group.toJson()['groupName'];
      List<dynamic> items = group.toJson()['items'];
      for (var item in items) {
        List<dynamic> row = [];
        row.add(groupName); // Add groupName to each row

        // Extract item_name, color_code, item_count
        String itemName = item['item_name'];
        String colorCode = item['color_code'];
        int itemCount = item['item_count'];

        // Add item details to row
        row.addAll([itemName, colorCode, itemCount]);
        // Add row to rows list
        rows.add(row);
      }
    }
    print(rows);
    String csv = const ListToCsvConverter().convert(rows);
    final path = await _localPath;
    filePath = '${path}/xstock_${DateTime.now().millisecondsSinceEpoch}.cvs';
    print(filePath);
    File file = File(filePath);
    await file.writeAsString(csv).then((value) {
      ToastLoader.remove();
      DisplayUtils.flutterShowToast('File exported successfully!');
    }).onError((error, stackTrace) {
      ToastLoader.remove();
      print(error.toString());
      DisplayUtils.flutterShowToast(error.toString());
    });
  }

  Future<bool> _checkAndRequestStoragePermissions() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (status.isDenied) {
        await Permission.storage.request();
        status = await Permission.storage.status;
      }
      return status.isGranted;
    } else {
      // On iOS, you cannot directly access the Downloads folder.
      // You may prompt the user to choose the location via a file picker.
      // Handle the iOS case based on your app's requirements.
      return false;
    }
  }

  void exportDataToCsvFile() async {
    groupsDataList.clear();
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    CollectionReference groups = fireStore.collection('groups');
    CollectionReference items = fireStore.collection('items');
    ToastLoader.show();
    await groups.get().then((querySnapshot) async {
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        if(doc['user_id'].toString() == userAccountRepository.getUserFromDb().user_id.toString()){
          String groupName = doc['group_name'];
          String groupId = doc.id;
          await items.where('group_id', isEqualTo: groupId).get().then((userSnapshot) async {
            List<ItemDataModel> itemsData = [];
            itemsData.clear();
            for (QueryDocumentSnapshot userDoc in userSnapshot.docs) {
              ItemDataModel itemDataModel = ItemDataModel(
                  itemColor: userDoc['color_code'],
                  itemCount: userDoc['item_count'],
                  itemName: userDoc['item_name']);
              itemsData.add(itemDataModel);
            }
            groupsDataList.add(GroupDataModel(groupName: groupName, items: itemsData));
          });
        }
      }
    }).onError((error, stackTrace) {
      ToastLoader.remove();
      DisplayUtils.flutterShowToast(error.toString());
    });

    if(groupsDataList.isNotEmpty){
      exportCSV();
    }else{
      ToastLoader.remove();
      DisplayUtils.flutterShowToast( 'Please add the groups and groups item to export the data');
    }
  }
}
