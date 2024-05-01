import 'package:flutter/material.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/ui/widgets/on_click.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const SettingsTile({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OnClick(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(color: AppColors.fieldColor,borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.all(20),
        child: Text(
          title,
          style: context.textTheme.bodyMedium,
        ),
      ),
    );
  }
}
