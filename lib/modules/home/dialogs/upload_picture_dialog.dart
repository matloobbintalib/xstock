import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/config/config.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/ui/widgets/on_click.dart';

class UploadPictureDialog extends StatelessWidget {
  const UploadPictureDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.fieldColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.fieldColor)),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            child: IconButton(
                onPressed: () {
                  NavRouter.pop(context);
                },
                icon: SvgPicture.asset("assets/images/svg/ic_cross.svg")),
          ),
          Container(
            padding: EdgeInsets.all(36),
            child: Row(
              children: [
                Expanded(
                    child: OnClick(
                        onTap: () {},
                        child: SvgPicture.asset(
                            "assets/images/svg/ic_camera.svg"))),
                SizedBox(
                  width: 24,
                ),
                Expanded(
                    child: OnClick(
                        onTap: () {},
                        child: SvgPicture.asset(
                            "assets/images/svg/ic_gallery.svg")))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
