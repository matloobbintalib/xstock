import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/modules/settings/models/account_title_model.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

class AccountTile extends StatelessWidget {
  final AccountTitleModel model;
  final Color? backgroundColor;
  final Color titleColor;

  const AccountTile(
      {super.key,
      required this.model,
      this.backgroundColor = AppColors.fieldColor,
      this.titleColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 62,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Branch Name",
                  style: context.textTheme.bodySmall?.copyWith(
                      color: titleColor.withOpacity(.75),
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  model.name,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                      color: titleColor),
                  maxLines: 1,
                )
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: DottedLine(
              direction: Axis.vertical,
              dashColor: Colors.white.withOpacity(.17),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Email",
                style: context.textTheme.bodySmall?.copyWith(
                    color: titleColor.withOpacity(.75),
                    fontWeight: FontWeight.w500),
              ),
              Text(
                model.email,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                    color: titleColor),
                maxLines: 1,
              )
            ],
          ))
        ],
      ),
    );
  }
}
