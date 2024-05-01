import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/modules/home/dialogs/color_chooser_dialog.dart';
import 'package:xstock/modules/home/dialogs/new_group_dialog.dart';
import 'package:xstock/modules/home/models/group_name_item_model.dart';
import 'package:xstock/modules/home/widgets/group_name_eidt_item_widget.dart';
import 'package:xstock/ui/input/input_field.dart';
import 'package:xstock/ui/widgets/appbar_widget.dart';
import 'package:xstock/ui/widgets/on_click.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

class EditItemPage extends StatefulWidget {
  const EditItemPage({super.key});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
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
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppbarWidget(
                title: 'Edit Item',
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
                    OnClick(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ColorChooserDialog(
                                color: color,
                                onChangeColor: (Color color) {
                                  setState(() {
                                    this.color = color;
                                  });
                                },
                              );
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
                height: 30,
              ),
              Container(
                height: 32,
                child: Row(
                  children: [
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
                            SvgPicture.asset(
                                "assets/images/svg/ic_add_item.svg"),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              "New Group",
                              style: context.textTheme.bodyMedium,
                            )
                          ],
                        )),
                    Expanded(
                      child: ListView.builder(
                          padding: EdgeInsets.only(left: 4),
                          itemCount: groupNameItems.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return OnClick(
                                onTap: () {
                                  groupNameItems.forEach((element) {
                                    if (element.id ==
                                        groupNameItems[index].id) {
                                      element.isSelected = !element.isSelected;
                                    } else {
                                      element.isSelected = false;
                                    }
                                  });
                                  setState(() {});
                                },
                                child: GroupNameEditItemWidget(
                                    model: groupNameItems[index]));
                          }),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Comment... ",
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff212121), width: 2),
                        ),
                        fillColor: Colors.black,
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.white),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff212121), width: 2),
                        ))),
              ),
              SizedBox(
                height: 26,
              ),
              PrimaryButton(
                onPressed: () {},
                title: 'Delete',
                borderRadius: 10,
                backgroundColor: AppColors.red,
                borderColor: AppColors.red,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              )
            ],
          ),
        ),
      ),
    );
  }
}
