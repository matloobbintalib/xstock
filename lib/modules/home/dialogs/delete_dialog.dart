import 'package:flutter/material.dart';
import 'package:xstock/config/config.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Delete",
              style: context.textTheme.headlineMedium?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: context.colorScheme.primary),
            ),
            Text(
              "Are you sure you want to\ndelete this?",
              style: context.textTheme.bodySmall
                  ?.copyWith(fontSize: 16, fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 6,
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
                    onPressed: () {},
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
