import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/config/routes/nav_router.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/core/di/service_locator.dart';
import 'package:xstock/modules/authentication/repository/user_account_repository.dart';
import 'package:xstock/modules/home/cubits/group_cubit/groups_cubit.dart';
import 'package:xstock/modules/home/cubits/group_cubit/groups_state.dart';
import 'package:xstock/modules/home/dialogs/color_chooser_dialog.dart';
import 'package:xstock/modules/home/dialogs/delete_dialog.dart';
import 'package:xstock/modules/home/dialogs/new_group_dialog.dart';
import 'package:xstock/modules/home/models/group_model.dart';
import 'package:xstock/modules/home/models/group_name_item_model.dart';
import 'package:xstock/modules/home/models/item_model.dart';
import 'package:xstock/modules/home/widgets/group_name_eidt_item_widget.dart';
import 'package:xstock/ui/input/input_field.dart';
import 'package:xstock/ui/widgets/appbar_widget.dart';
import 'package:xstock/ui/widgets/loading_indicator.dart';
import 'package:xstock/ui/widgets/on_click.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/ui/widgets/toast_loader.dart';
import 'package:xstock/utils/display/display_utils.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

class EditItemPage extends StatelessWidget {
  final ItemModel itemModel;
  final String groupDocId;

  const EditItemPage(
      {super.key, required this.itemModel, required this.groupDocId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupsCubit(),
      child: EditItemPageView(
        itemModel: itemModel,
        groupDocId: groupDocId,
      ),
    );
  }
}

class EditItemPageView extends StatefulWidget {
  final ItemModel itemModel;
  final String groupDocId;

  const EditItemPageView(
      {super.key, required this.itemModel, required this.groupDocId});

  @override
  State<EditItemPageView> createState() => _EditItemPageViewState();
}

class _EditItemPageViewState extends State<EditItemPageView> {
  TextEditingController itemNameController = TextEditingController();
  UserAccountRepository userAccountRepository = sl<UserAccountRepository>();
  late Stream<QuerySnapshot> groupsStream;
  CollectionReference items = FirebaseFirestore.instance.collection('items');
  String groupId = '';
  Color color = AppColors.lightGreen;
  List<GroupModel> groupNameItems = [];

  void addItem(String colorCode) async {
    ToastLoader.show();
    await items.add({
      'group_id': groupId,
      'color_code': colorCode,
      "item_name": itemNameController.text.trim().toString(),
      "item_count": 0
    }).then((value) {
      ToastLoader.remove();
      DisplayUtils.showToast(context, 'Item added successfully');
      NavRouter.pop(context);
    }).onError((error, stackTrace) {
      ToastLoader.remove();
      DisplayUtils.showToast(context, error.toString());
    });
  }

  Future<void> updateItemName(String name, String id) {
    CollectionReference itemsList =
        FirebaseFirestore.instance.collection('items');
    return itemsList
        .doc(id)
        .update({'item_name': name})
        .then((value) {})
        .catchError((error) {
          DisplayUtils.showErrorToast(context, error.message);
        });
  }

  Future<void> updateItemGroup(String id, String groupId) {
    CollectionReference itemsList =
        FirebaseFirestore.instance.collection('items');
    return itemsList
        .doc(id)
        .update({'group_id': groupId})
        .then((value) {})
        .catchError((error) {
          DisplayUtils.showErrorToast(context, error.message);
        });
  }

  Future<void> deleteItem(String id) {
    CollectionReference itemsList =
        FirebaseFirestore.instance.collection('items');
    ToastLoader.show();
    return itemsList.doc(id).delete().then((value) {
      ToastLoader.remove();
      DisplayUtils.showToast(context, 'Item deleted successfully');
      NavRouter.pop(context);
    }).catchError((error) {
      ToastLoader.remove();
      DisplayUtils.showErrorToast(context, 'Failed to Delete Item');
    });
  }

  Future<void> updateItemColor(String id, String color) {
    CollectionReference itemsList =
        FirebaseFirestore.instance.collection('items');
    return itemsList
        .doc(id)
        .update({'color_code': color})
        .then((value) {})
        .catchError((error) {
          DisplayUtils.showErrorToast(context, error.message);
        });
  }

  @override
  void initState() {
    super.initState();
    color = parseColor(widget.itemModel.itemColor);
    itemNameController.text = widget.itemModel.itemName;
    groupsStream = FirebaseFirestore.instance
        .collection('groups')
        .where('user_id',
            isEqualTo: userAccountRepository.getUserFromDb().user_id)
        .snapshots();
  }

  Color parseColor(String colorString) {
    // Extract hexadecimal color value using regular expression
    RegExp regex = RegExp(r"0x([\da-fA-F]+)");
    String? hex = regex.stringMatch(colorString);

    if (hex != null) {
      // Remove "0x" prefix
      hex = hex.replaceAll("0x", "");

      // Parse hexadecimal value to integer
      int colorValue = int.parse(hex, radix: 16);

      // Construct Color object using parsed value
      return Color(colorValue);
    } else {
      // Return a default color in case of invalid input
      return Colors.transparent;
    }
  }

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
                                    updateItemColor(
                                        widget.itemModel.id, color.toString());
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
                          controller: itemNameController,
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
                      child: StreamBuilder<QuerySnapshot>(
                          stream: groupsStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(snapshot.error.toString()),
                              );
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularLoadingIndicator(),
                              );
                            }
                            groupNameItems.clear();
                            snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map a = document.data() as Map<String, dynamic>;
                              groupNameItems.add(GroupModel(
                                  id: document.id,
                                  userId: a['user_id'],
                                  title: a['group_name'],
                                  isSelected: widget.groupDocId == document.id,
                                  isExpandable: a['is_extendable']));
                            }).toList();
                            context
                                .read<GroupsCubit>()
                                .initialList(groupNameItems);
                            return BlocBuilder<GroupsCubit, GroupsState>(
                              builder: (context, state) {
                                return ListView.builder(
                                    itemCount: state.groups.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return OnClick(
                                          onTap: () {
                                            context
                                                .read<GroupsCubit>()
                                                .updateGroupSelection(
                                                    state.groups[index].id);
                                            updateItemGroup(widget.itemModel.id,
                                                state.groups[index].id);
                                          },
                                          child: GroupNameEditItemWidget(
                                              model: state.groups[index]));
                                    });
                              },
                            );
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
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DeleteDialog(
                          title: 'item',
                          onConfirmDelete: () async {
                            await deleteItem(widget.itemModel.id);
                          },
                        );
                      });
                },
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
