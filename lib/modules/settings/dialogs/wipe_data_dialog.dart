import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xstock/config/routes/nav_router.dart';
import 'package:xstock/constants/api_endpoints.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/core/di/service_locator.dart';
import 'package:xstock/modules/authentication/models/user_model.dart';
import 'package:xstock/modules/authentication/repository/user_account_repository.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/ui/widgets/toast_loader.dart';
import 'package:xstock/utils/display/display_utils.dart';
import 'package:xstock/utils/utils.dart';

class WipeDataDialog extends StatefulWidget {
  final UserModel userModel;

  const WipeDataDialog({super.key, required this.userModel});

  @override
  State<WipeDataDialog> createState() => _WipeDataDialogState();
}

class _WipeDataDialogState extends State<WipeDataDialog> {
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection(Endpoints.usersTable);

  Future<void> deleteGroupsAndItemsByEmail() async {
    try {
      ToastLoader.show();
      CollectionReference groupsCollection = usersCollection
          .doc(widget.userModel.id)
          .collection(Endpoints.groupsTable);
      QuerySnapshot groupSnapshot = await groupsCollection.get();

      for (QueryDocumentSnapshot groupDoc in groupSnapshot.docs) {
        String groupId = groupDoc.id;
        CollectionReference itemsCollection = usersCollection
            .doc(widget.userModel.id)
            .collection(Endpoints.groupsTable)
            .doc(groupId)
            .collection(Endpoints.itemsTable);

        QuerySnapshot itemSnapshot = await itemsCollection.get();
        for (QueryDocumentSnapshot itemDoc in itemSnapshot.docs) {
          await itemsCollection.doc(itemDoc.id).delete();
        }

        await groupsCollection.doc(groupId).delete();
      }
      ToastLoader.remove();
      DisplayUtils.flutterShowToast("Data successfully deleted");
      Navigator.pop(context);
    } catch (e) {
      ToastLoader.remove();
      DisplayUtils.flutterShowToast(e.toString());
      print(e.toString());
    }
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
            EdgeInsets.only(top: 19, bottom: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: Text(
              "Are you sure to wipe out all data?",
              style: context.textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
            )),
            SizedBox(
              height: 16,
            ),
            PrimaryButton(
              onPressed: () async {
                await deleteGroupsAndItemsByEmail();
                ToastLoader.remove();
              },
              title: 'Yes',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              borderRadius: 10,
              titleColor: Colors.black,
              backgroundColor: context.colorScheme.primary,
              borderColor: context.colorScheme.primary,
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
}
