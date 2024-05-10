import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/config/config.dart';
import 'package:xstock/modules/home/dialogs/delete_dialog.dart';
import 'package:xstock/modules/home/models/group_model.dart';
import 'package:xstock/modules/home/pages/add_item_page.dart';
import 'package:xstock/modules/home/widgets/item_widget.dart';
import 'package:xstock/ui/widgets/on_click.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

class GroupWidget extends StatelessWidget {
  final GroupModel groupModel;
  final VoidCallback onClick;
  const GroupWidget({super.key, required this.groupModel, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                constraints: BoxConstraints(),
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize
                      .shrinkWrap, // the '2023' part
                ),
                padding: EdgeInsets.symmetric(horizontal: 0,vertical: 8),onPressed: onClick, icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RotationTransition(
                  turns: AlwaysStoppedAnimation(
                      groupModel.isExpandable ? 0 : 270 / 360),
                  child: SvgPicture.asset(
                    "assets/images/svg/ic_drop_down.svg",
                    height: 6,
                    width: 5,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Default Group",
                  style: context.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            )),
            SizedBox(
              width: 10,
            ),
            Visibility(visible: groupModel.isExpandable, child: Spacer()),
            Visibility(
                visible: !groupModel.isExpandable,
                child: Text(
                  "4 items, 28 in total",
                  style: context.textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.w300, fontSize: 10),
                )),
            Visibility(
              visible: groupModel.isExpandable,
              child: OnClick(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DeleteDialog();
                        });
                  },
                  child: SvgPicture.asset(
                      "assets/images/svg/delete_group_button.svg")),
            ),
            SizedBox(
              width: 10,
            ),
            Visibility(
              visible: groupModel.isExpandable,
              child: OnClick(
                  onTap: () {
                    /*showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddItemDialog();
                    });*/
                    NavRouter.push(context, AddItemPage());
                  },
                  child: SvgPicture.asset(
                      "assets/images/svg/add_item_button.svg")),
            ),
          ],
        ),
        Visibility(
          visible: groupModel.isExpandable,
          child: MasonryGridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              padding: EdgeInsets.symmetric(vertical: 10) +
                  EdgeInsets.only(bottom: 10),
              itemBuilder: (BuildContext context, int index) {
                return ItemWidget(
                  index: index,
                );
              }),
        )
      ],
    );
  }
}
