import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xstock/config/routes/nav_router.dart';
import 'package:xstock/constants/api_endpoints.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/core/di/service_locator.dart';
import 'package:xstock/modules/authentication/models/user_model.dart';
import 'package:xstock/modules/authentication/repository/user_account_repository.dart';
import 'package:xstock/modules/home/models/group_data_model.dart';
import 'package:xstock/modules/home/models/item_data_model.dart';
import 'package:xstock/modules/home/models/item_model.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/ui/widgets/toast_loader.dart';
import 'package:xstock/utils/display/display_utils.dart';
import 'package:xstock/utils/utils.dart';
import 'dart:io';

class ExportDialog extends StatefulWidget {
  final UserModel userModel;

  const ExportDialog({super.key, required this.userModel});

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  String filePath = '';
  List<GroupDataModel> groupsDataList = [];
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection(Endpoints.usersTable);
  late CollectionReference groupsCollection;
  late CollectionReference itemsCollection;
  bool shareAsFile = false;

  @override
  void initState() {
    super.initState();
    groupsCollection = fireStore.collection(Endpoints.groupsTable);
    itemsCollection = fireStore.collection(Endpoints.itemsTable);
  }

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
              onPressed: () {
                shareAsFile = false;
                _requestStoragePermission();
              },
              title: 'Send via email',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              borderRadius: 10,
              titleColor: Colors.white,
              backgroundColor: Colors.black,
              borderColor: Colors.black,
            ),
            SizedBox(
              height: 12,
            ),
            PrimaryButton(
              onPressed: () async {
                shareAsFile = true;
                _requestStoragePermission();
              },
              title: 'Save as file',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              borderRadius: 10,
              titleColor: Colors.white,
              backgroundColor: Colors.black,
              borderColor: Colors.black,
            ),
            SizedBox(
              height: 12,
            ),
            PrimaryButton(
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
    for (var group in groupsDataList) {
      String groupName = group.groupName;
      String createdAt = group.createdAt;
      List<ItemModel> items = group.items;
      for (var item in items) {
        List<dynamic> row = [];
        row.add(groupName); // Add groupName to each row
        // Add item details to row
        row.addAll([
          item.id,
          item.userId,
          item.groupId,
          item.color,
          item.count,
          item.name,
          item.expiryDate,
          item.minimumStockAlert,
          item.stockImage,
          item.isEnableExpiry,
          createdAt,
          item.createdAt,
        ]);
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
      if(shareAsFile){
        ToastLoader.remove();
        DisplayUtils.flutterShowToast('File exported successfully!');
      }else{
        sendEmail();
      }
    }).onError((error, stackTrace) {
      ToastLoader.remove();
      print(error.toString());
      DisplayUtils.flutterShowToast(error.toString());
    });
  }

  Future<void> sendEmail() async {
    final Email email = Email(
      body: '',
      subject: "",
      recipients: ['hassamjr7@gmail.com'],
      attachmentPaths: [filePath],
      isHTML: false,
    );
    await FlutterEmailSender.send(email).then((value){
      DisplayUtils.removeLoader();
      DisplayUtils.showToast(context, 'Email send successfully!');
    }).onError((error, stackTrace) {
      DisplayUtils.removeLoader();
      print("Error sending email: " + error.toString());
      DisplayUtils.showErrorToast(context, error.toString());
    });
  }
  Future<void> _requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      if (await Permission.storage.request().isGranted) {
        exportDataToCsvFile();
      } else if (await Permission.manageExternalStorage.request().isGranted) {
        exportDataToCsvFile();
      } else if (status.isPermanentlyDenied) {
        openAppSettings();
      }
    } else {
      exportDataToCsvFile();
    }
  }

  Future<void> requestStoragePermission() async {
    if (await Permission.storage.isGranted) {
      // The permission is already granted
      print('Storage permission already granted');
    } else {
      // Request the permission
      var status = await Permission.storage.request();
      if (status.isGranted) {
        print('Storage permission granted');
      } else if (status.isDenied) {
        print('Storage permission denied');
      } else if (status.isPermanentlyDenied) {
        // Open app settings if the permission is permanently denied
        openAppSettings();
      }
    }
  }

  void exportDataToCsvFile() async {
    groupsDataList.clear();
    ToastLoader.show();
    CollectionReference groupsCollection = usersCollection
        .doc(widget.userModel.id)
        .collection(Endpoints.groupsTable);
    QuerySnapshot groupSnapshot = await groupsCollection.get();
    for (QueryDocumentSnapshot groupDoc in groupSnapshot.docs) {
      String groupId = groupDoc.id;
      String groupName = groupDoc[Endpoints.groupName];
      String createdAt = groupDoc['created_at'];
      CollectionReference itemsCollection = usersCollection
          .doc(widget.userModel.id)
          .collection(Endpoints.groupsTable)
          .doc(groupId)
          .collection(Endpoints.itemsTable);

      QuerySnapshot itemSnapshot = await itemsCollection.get();
      List<ItemModel> itemsData = [];
      itemsData.clear();
      for (QueryDocumentSnapshot itemDoc in itemSnapshot.docs) {
        ItemModel itemModel = ItemModel(
          id: itemDoc['id'],
          userId: itemDoc[Endpoints.userId],
          color: itemDoc[Endpoints.itemColor],
          count: itemDoc[Endpoints.itemCount],
          name: itemDoc[Endpoints.itemName],
          groupId: itemDoc['group_id'],
          expiryDate: itemDoc[Endpoints.expiryDate],
          minimumStockAlert: itemDoc[Endpoints.minimumStockAlert],
          stockImage: itemDoc[Endpoints.stockImage],
          isEnableExpiry: itemDoc[Endpoints.isEnableExpiry],
          createdAt: itemDoc['created_at'],
        );
        itemsData.add(itemModel);
      }
      groupsDataList.add(GroupDataModel(
          groupName: groupName,
          createdAt: createdAt,
          items: itemsData,
          id: groupId,
          userId: widget.userModel.id.toString()));
    }
    if (groupsDataList.isNotEmpty) {
      exportCSV();
    } else {
      ToastLoader.remove();
      DisplayUtils.flutterShowToast(
          'Please add the groups and groups item to export the data');
    }
  }
}
