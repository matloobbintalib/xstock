import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/modules/home/dialogs/color_chooser_dialog.dart';
import 'package:xstock/modules/home/dialogs/new_group_dialog.dart';
import 'package:xstock/modules/home/models/group_name_item_model.dart';
import 'package:xstock/modules/home/widgets/color_picker_test.dart';
import 'package:xstock/modules/home/widgets/group_name_item_widget.dart';
import 'package:xstock/ui/input/input_field.dart';
import 'package:xstock/ui/widgets/appbar_widget.dart';
import 'package:xstock/ui/widgets/on_click.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  TextEditingController inputCountController = TextEditingController();
  List<GroupNameItemModel> groupNameItems = [
    GroupNameItemModel(id: 1, title: 'Group 1', isSelected: true),
    GroupNameItemModel(id: 2, title: 'Group 2'),
    GroupNameItemModel(id: 3, title: 'Group 3'),
    GroupNameItemModel(id: 4, title: 'Group 4'),
    GroupNameItemModel(id: 5, title: 'Group 5'),
    GroupNameItemModel(id: 6, title: 'Group 6'),
  ];

  Color color = AppColors.lightGreen;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppbarWidget(
                    title: 'New Item',
                  ),
                  SizedBox(
                    height: 33,
                  ),
                  Container(
                    height: 60,
                    padding: EdgeInsets.all(9),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.fieldColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OnClick(onTap: (){
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ColorChooserDialog(color: color, onChangeColor: (Color color) {
                                  setState(() {
                                    this.color = color;
                                  });
                                },);
                              });
                        },
                          child: Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 14,
                        ),
                        Expanded(
                          child: InputField(
                              controller: inputCountController,
                              label: 'Item name: Amount of stock',
                              borderRadius: 20,
                              horizontalPadding: 0,
                              borderColor: AppColors.fieldColor,
                              fillColor: AppColors.fieldColor,
                              keyboardType: TextInputType.number,
                              boxConstraints: 44,
                              textInputAction: TextInputAction.done),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return NewGroupDialog();
                            });
                      },
                      icon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset("assets/images/svg/ic_add_item.svg"),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "New Group",
                            style: context.textTheme.bodyMedium,
                          )
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Dash(
                      dashColor: Colors.white,
                      dashThickness: .1,
                      length: 280,
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    "Existing Groups Listed Below ",
                    style: context.textTheme.bodyMedium,
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.fieldColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: ListView.builder(
                        itemCount: groupNameItems.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return OnClick(
                              onTap: () {
                                groupNameItems.forEach((element) {
                                  if (element.id == groupNameItems[index].id) {
                                    element.isSelected = !element.isSelected;
                                  } else {
                                    element.isSelected = false;
                                  }
                                });
                                setState(() {});
                              },
                              child: GroupNameItemWidget(
                                  model: groupNameItems[index]));
                        }),
                  ),
                ],
              )),

              Center(
                child: PrimaryButton(
                  onPressed: () {},
                  title: 'Done',
                  height: 56,
                  width: 195,
                  backgroundColor: context.colorScheme.secondary,
                  borderColor: context.colorScheme.secondary,
                  borderRadius: 28,
                ),
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}
