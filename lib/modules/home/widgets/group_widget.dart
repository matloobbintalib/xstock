import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/config/config.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/modules/home/dialogs/item_detail_dialog.dart';
import 'package:xstock/modules/home/dialogs/delete_dialog.dart';
import 'package:xstock/modules/home/pages/add_item_page.dart';
import 'package:xstock/modules/home/widgets/item_widget.dart';
import 'package:xstock/ui/widgets/on_click.dart';
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/images/svg/ic_drop_down.svg",height: 6,width: 5,),
              SizedBox(width: 8,),
              Expanded(
                  child: Text(
                "Default Group",
                style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
              )),
              SizedBox(
                width: 10,
              ),
              OnClick(onTap: (){
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DeleteDialog();
                    });
              }, child: SvgPicture.asset("assets/images/svg/delete_group_button.svg")),
              SizedBox(width: 10,),
              OnClick(onTap: (){
                /*showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddItemDialog();
                    });*/
                NavRouter.push(context, AddItemPage());
              }, child: SvgPicture.asset("assets/images/svg/add_item_button.svg")),
            ],
          ),
        ),
        MasonryGridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 6,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          padding: EdgeInsets.symmetric(vertical: 10)+EdgeInsets.only(bottom: 10),
          itemBuilder: (BuildContext context, int index) {
            return ItemWidget();
          }),
      ],
    );
  }
}
