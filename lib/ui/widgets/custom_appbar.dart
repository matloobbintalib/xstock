import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

import '../../config/routes/nav_router.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool backArrow;
  final Color? titleColor;

  const CustomAppbar({
    super.key,
    this.title,
    this.showBackButton = true,
    this.bottom,
    this.actions,
    this.backArrow = true,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFFF9E5F1),
      title: Text(
        title.toString(),
        style: context.textTheme.bodyLarge?.copyWith(
            color:
                titleColor != null ? titleColor : context.colorScheme.primary,
            fontWeight: FontWeight.w600),
      ),
      automaticallyImplyLeading: false,
      leading: backArrow == true
          ? Navigator.of(context).canPop()
              ? IconButton(
                  onPressed: () {
                    NavRouter.pop(context);
                  },
                  style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                  ),
                  icon: SvgPicture.asset(
                    'assets/images/svg/ic_back.svg',
                    height: 24,
                    width: 24,
                  ),
                )
              : null
          : null,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
