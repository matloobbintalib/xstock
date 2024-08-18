import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xstock/config/config.dart';
import 'package:xstock/constants/api_endpoints.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/core/di/service_locator.dart';
import 'package:xstock/modules/authentication/models/user_model.dart';
import 'package:xstock/modules/authentication/repository/user_account_repository.dart';
import 'package:xstock/modules/home/models/group_model.dart';
import 'package:xstock/ui/input/input_field.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/ui/widgets/toast_loader.dart';
import 'package:xstock/utils/custom_date_time_picker.dart';
import 'package:xstock/utils/display/display_utils.dart';
import 'package:xstock/utils/extensions/context_user.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

class NewGroupDialog extends StatefulWidget {
  const NewGroupDialog({super.key});

  @override
  State<NewGroupDialog> createState() => _NewGroupDialogState();
}

class _NewGroupDialogState extends State<NewGroupDialog> {
  TextEditingController nameController = TextEditingController();
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection(Endpoints.usersTable);
  UserAccountRepository userAccountRepository = sl<UserAccountRepository>();

  void addGroup(String userId) async {
    ToastLoader.show();
    DocumentReference userRef = usersCollection.doc(userId);
    CollectionReference groupsCollection =
        userRef.collection(Endpoints.groupsTable);
    String randomString = generateRandomString(10);
    DateTime now = DateTime.now();
    Timestamp timestamp = Timestamp.fromDate(now);
    String groupRef = '${randomString}${timestamp.millisecondsSinceEpoch}';
    GroupModel groupModel = GroupModel(
        id: groupRef,
        userId: userId.toString(),
        name: nameController.text.trim().toString(),
        createdAt: changeDateTimeFormat(DateTime.now(), 'dd/MM/yyyy HH:mm:ss'));
    await groupsCollection.doc(groupRef).set(groupModel.toMap()).then((value) {
      ToastLoader.remove();
      DisplayUtils.showToast(context, 'Group added successfully');
      NavRouter.pop(context);
    }).onError((error, stackTrace) {
      ToastLoader.remove();
      DisplayUtils.flutterShowToast(error.toString());
    });
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    var user = context.watchCurrentUser;
    return Dialog(
      backgroundColor: AppColors.fieldColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.fieldColor)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Text(
              "New Group",
              style: context.textTheme.headlineMedium?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            )),
            SizedBox(
              height: 16,
            ),
            Text(
              "Input a group name",
              style: context.textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 9,
            ),
            InputField(
                controller: nameController,
                label: 'Enter group name',
                borderRadius: 10,
                fontSize: 12,
                fillColor: Colors.black,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.done),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                    child: PrimaryButton(
                  onPressed: () {
                    NavRouter.pop(context);
                  },
                  title: 'Cancel',
                  height: 50,
                  borderRadius: 10,
                  backgroundColor: Colors.black,
                  borderColor: Colors.black,
                )),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: PrimaryButton(
                    onPressed: () {
                      addGroup(user.id.toString());
                    },
                    title: 'Okay',
                    height: 50,
                    borderRadius: 10,
                    backgroundColor: context.colorScheme.secondary,
                    borderColor: context.colorScheme.secondary,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
