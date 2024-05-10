import 'package:flutter/material.dart';
import 'package:xstock/config/routes/nav_router.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/utils/utils.dart';

class ExportDialog extends StatelessWidget {
  const ExportDialog({super.key});

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
            SizedBox(height: 12,),PrimaryButton(
              onPressed: () {},
              title: 'Save as file',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              borderRadius: 10,
              titleColor: Colors.white,
              backgroundColor: Colors.black,
              borderColor: Colors.black,
            ),
            SizedBox(height: 12,),PrimaryButton(
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
