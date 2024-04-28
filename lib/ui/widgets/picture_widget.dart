import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'circular_cached_image.dart';
import 'on_click.dart';

class PictureWidget extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onSaveTap;
  final double width;

  final double height;
  final double radius;
  final String errorPath;
  final Color borderColor;
  final bool isEditable;
  final bool isSaveToServer;

  const PictureWidget({
    super.key,
    required this.imageUrl,
     this.onTap,
     this.onSaveTap,
    this.width = 140,
    this.height = 140,
    this.radius = 70,
    required this.errorPath,
    this.borderColor = Colors.transparent,
    this.isEditable= false,
     this.isSaveToServer= false,
  });

  @override
  Widget build(BuildContext context) {
    print(imageUrl);
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Stack(
          children: [
            imageUrl.contains('http')
                ? Hero(
              tag: imageUrl,
              child: CircularCachedImage(
                imageUrl: imageUrl,
                width: width,
                height: height,
                borderRadius: radius,
                errorPath: errorPath,
              ),
            )
                : Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(.5)),
                  borderRadius: BorderRadius.circular(radius),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: imageUrl.contains('assets/')
                          ? AssetImage(imageUrl) as ImageProvider
                          : FileImage(
                        File(imageUrl),
                      ))),
            ),
            if (isEditable)
              Positioned(
                bottom: -5,
                right: 0,
                child: OnClick(
                  onTap: onTap!,
                  child: SvgPicture.asset(
                    'assets/images/svg/ic_edit.svg',
                    height: 44,
                    width: 44,
                  ),
                ),
              ),
            if (isSaveToServer)
              Positioned(
                bottom: -5,
                right: 0,
                child: OnClick(
                  onTap: onSaveTap!,
                  child: SvgPicture.asset(
                    'assets/images/svg/ic_save_image.svg',
                    height: 44,
                    width: 44,
                  ),
                ),
              ),

          ],
        ),
      ),
    );
  }
}
