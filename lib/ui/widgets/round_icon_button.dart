import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RoundIconButton extends StatelessWidget {
  final String? svgIcon;
  final IconData? icon;
  final VoidCallback onTap;
  const RoundIconButton(
      {super.key, this.svgIcon, this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(icon!=null?13:16),
        decoration: const BoxDecoration(
          color: Color(0xFFE5E5E5),
          shape: BoxShape.circle,
        ),
        child: svgIcon != null
            ? SvgPicture.asset(
                svgIcon!,
                width: 20,
                height: 20,
              )
            : Icon(icon),
      ),
    );
  }
}
