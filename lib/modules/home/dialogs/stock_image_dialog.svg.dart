import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/config/routes/nav_router.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/modules/home/dialogs/upload_picture_dialog.dart';
import 'package:xstock/ui/widgets/on_click.dart';
import 'package:xstock/ui/widgets/picture_widget.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

class StockImageDialog extends StatelessWidget {
  const StockImageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.fieldColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.fieldColor)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 13),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  'Stock Image',
                  style: context.textTheme.bodySmall
                      ?.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
                )),
                OnClick(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return UploadPictureDialog();
                          });
                    },
                    child: SvgPicture.asset(
                        "assets/images/svg/change_image_button.svg"))
              ],
            ),
            SizedBox(height: 20),
            PictureWidget(
              imageUrl: "assets/images/png/dummy_image.png",
              errorPath: "assets/images/png/dummy_image.png",
              width: double.infinity,
              height: 350,
              radius: 18,
            ),
            SizedBox(
              height: 14,
            ),
            PrimaryButton(
              onPressed: () {
                NavRouter.pop(context);
              },
              title: 'Cancel',
              height: 54,
              borderRadius: 10,
              hMargin: 6,
              backgroundColor: Colors.black,
              borderColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
