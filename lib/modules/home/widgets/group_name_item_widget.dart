import 'package:flutter/material.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/modules/home/models/group_model.dart';
import 'package:xstock/modules/home/models/group_name_item_model.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

class GroupNameItemWidget extends StatelessWidget {
  final GroupModel model;

  const GroupNameItemWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      width: 94,
      height: 36,
      decoration: BoxDecoration(
        color: model.isSelected
            ? context.colorScheme.primary
            : AppColors.fieldColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: Text(
          model.title,
          style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: model.isSelected ? Colors.black : Colors.white),
        ),
      ),
    );
  }
}
