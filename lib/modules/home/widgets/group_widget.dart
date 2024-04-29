import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/modules/home/dialogs/add_item_dialog.dart';
import 'package:xstock/modules/home/dialogs/delete_dialog.dart';
import 'package:xstock/modules/home/widgets/item_widget.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

class GroupWidget extends StatelessWidget {
  const GroupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                "Default Group",
                style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
              )),
              SizedBox(
                width: 10,
              ),
              PrefixIconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DeleteDialog();
                      });
                },
                title: 'Delete',
                fontSize: 10,
                prefixIconPath: 'assets/images/svg/ic_delete.svg',
                width: 72,
                height: 30,
                titleGap: 6,
                borderRadius: 8,
                hPadding: 0,
                prefixIconSize: 16,
                titleColor: Colors.white,
                backgroundColor: AppColors.red,
                borderColor: AppColors.red,
              ),
              SizedBox(
                width: 10,
              ),
              PrefixIconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddItemDialog();
                      });
                },
                title: 'Add item',
                fontSize: 10,
                borderRadius: 8,
                titleGap: 6,
                hPadding: 0,
                mainAxisAlignment: MainAxisAlignment.center,
                height: 30,
                titleColor: Colors.white,
                prefixIconPath: 'assets/images/svg/ic_add_item.svg',
                width: 78,
                prefixIconSize: 16,
                backgroundColor: AppColors.addItemColor,
                borderColor: AppColors.addItemColor,
              ),
            ],
          ),
        ),
        Container(
          height: 260,
          child: MasonryGridView.count(
            crossAxisCount: 2,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            padding: EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (BuildContext context, int index) {
              return ItemWidget();
            }),),
      ],
    );
  }
}
