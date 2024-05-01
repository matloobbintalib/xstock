import 'package:flutter/material.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/utils/utils.dart';

class ImportFromCvsDialog extends StatelessWidget {
  const ImportFromCvsDialog({super.key});

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
              "Import form CSV",
              style: context.textTheme.headlineMedium?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            )),
            SizedBox(
              height: 6,
            ),
            Text(
              "Are you sure you want to export\nall the data?",
              style: context.textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 14,
            ),
            PrimaryButton(
              onPressed: () {},
              title: 'Export Template ',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              borderRadius: 10,
              titleColor: Colors.black,
              backgroundColor: context.colorScheme.primary,
              borderColor: context.colorScheme.primary,
            )
          ],
        ),
      ),
    );
  }
}
