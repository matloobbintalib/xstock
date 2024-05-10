import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/ui/widgets/on_click.dart';
import 'package:xstock/utils/utils.dart';

class AppbarWidget extends StatelessWidget {
  final String title;
  final double fontSize;
  const AppbarWidget({super.key, required this.title, this.fontSize = 32});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: OnClick(
                onTap: () {
                  Navigator.pop(context);
                },
                child:
                SvgPicture.asset("assets/images/svg/ic_back.svg"))),
        Align(
            alignment: Alignment.center,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: context.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w600, fontSize: fontSize),
            ))
      ],
    );
  }
}
