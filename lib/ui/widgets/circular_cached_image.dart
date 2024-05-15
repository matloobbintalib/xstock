import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'loading_indicator.dart';

class CircularCachedImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final String errorPath;
  final double borderRadius;
  final Color borderColor;

  const CircularCachedImage({super.key, 
    required this.imageUrl,
    this.width = 280,
    this.height = 280,
    this.fit = BoxFit.cover,
    required this.errorPath , this.borderRadius = 12,this.borderColor = Colors.transparent
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => const Center(child: CircularLoadingIndicator(),),
        imageBuilder: (context, imageProvider) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider, fit: BoxFit.cover,),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor,width: 1),
            color: Colors.white
          ),
        ),
        errorWidget: (context, url, error) =>  ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(color: borderColor,width: 1)
            ),
            child: Image.asset(errorPath, fit: BoxFit.cover,),
          ),
        ),
        fit: fit,
      ),
    );
  }
}
