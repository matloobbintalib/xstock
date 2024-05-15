import 'package:flutter/material.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/modules/home/models/group_model.dart';
import 'package:xstock/modules/home/models/group_name_item_model.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

class GroupNameEditItemWidget extends StatelessWidget {
  final GroupModel model;

  const GroupNameEditItemWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 94,
      height: 32,
      decoration: BoxDecoration(
        color: model.isSelected
            ? AppColors.fieldColor
            : Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: Text(
          model.title,
          style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color:  Colors.white),
        ),
      ),
    );
  }
}
