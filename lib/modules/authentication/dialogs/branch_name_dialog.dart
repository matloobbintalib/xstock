import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xstock/config/config.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/core/di/service_locator.dart';
import 'package:xstock/modules/authentication/repository/user_account_repository.dart';
import 'package:xstock/ui/input/input_field.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/ui/widgets/toast_loader.dart';
import 'package:xstock/utils/display/display_utils.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

class BranchNameDialog extends StatefulWidget {
  const BranchNameDialog({super.key});

  @override
  State<BranchNameDialog> createState() => _BranchNameDialogState();
}

class _BranchNameDialogState extends State<BranchNameDialog> {
  TextEditingController branchNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                  "Branch Name",
                  style: context.textTheme.headlineMedium?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                )),
            SizedBox(
              height: 16,
            ),
            Text(
              "Input a branch name",
              style: context.textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 9,
            ),
            InputField(
                controller: branchNameController,
                label: 'Enter branch name',
                borderRadius: 10,
                fontSize: 12,
                fillColor: Colors.black,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.done),
            SizedBox(height: 16,),
            Row(
              children: [
                Expanded(
                    child: PrimaryButton(
                      onPressed: () {
                        NavRouter.pop(context,'');
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
                      if (branchNameController.text.isNotEmpty) {
                        NavRouter.pop(context, branchNameController.text.trim().toString());
                      }else{
                        DisplayUtils.flutterShowToast( 'Enter branch name');
                      }
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
