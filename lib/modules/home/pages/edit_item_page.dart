import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/constants/constants.dart';
import 'package:xstock/modules/authentication/models/user_model.dart';
import 'package:xstock/modules/home/cubits/group_cubit/groups_cubit.dart';
import 'package:xstock/modules/home/cubits/group_cubit/groups_state.dart';
import 'package:xstock/modules/home/dialogs/color_chooser_dialog.dart';
import 'package:xstock/modules/home/dialogs/new_group_dialog.dart';
import 'package:xstock/modules/home/models/group_model.dart';
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
  final String groupId;
  final UserModel userModel;

  const EditItemPage(
      {super.key,
      required this.itemModel,
      required this.groupId,
      required this.userModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupsCubit(),
      child: EditItemPageView(
        itemModel: itemModel,
        groupId: groupId,
        userModel: userModel,
      ),
    );
  }
}

class EditItemPageView extends StatefulWidget {
  final ItemModel itemModel;
  final String groupId;
  final UserModel userModel;

  const EditItemPageView(
      {super.key,
      required this.itemModel,
      required this.groupId,
      required this.userModel});

  @override
  State<EditItemPageView> createState() => _EditItemPageViewState();
}

class _EditItemPageViewState extends State<EditItemPageView> {
  TextEditingController itemNameController = TextEditingController();
  late Stream<QuerySnapshot> groupsStream;
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection(Endpoints.usersTable);
  late CollectionReference groupsCollection;
  late CollectionReference itemsCollection;
  CollectionReference outerItemsCollection =
      FirebaseFirestore.instance.collection(Endpoints.itemsTable);
  String groupId = '';
  List<GroupModel> groupNameItems = [];
  Color color = AppColors.lightGreen;

  void deleteItem(BuildContext context, String id) async {
    ToastLoader.show();
    await outerItemsCollection.doc(id).delete();
    return await itemsCollection.doc(id).delete().then((value) {
      ToastLoader.remove();
      DisplayUtils.flutterShowToast('Item deleted successfully');
      Navigator.pop(context);
    }).catchError((error) {
      ToastLoader.remove();
      DisplayUtils.flutterShowToast('Failed to Delete Item');
    });
  }

  Future<void> updateItem(String id, String value, String key) async {
    ToastLoader.show();
    await outerItemsCollection.doc(id).update({key: value});
    return itemsCollection.doc(id).update({key: value}).then((value) {
      ToastLoader.remove();
      DisplayUtils.flutterShowToast('Updated');
    }).catchError((error) {
      ToastLoader.remove();
      DisplayUtils.showErrorToast(context, error.message);
    });
  }

  Future<void> moveItemToOtherGroup(String id, String groupId) async {
    ToastLoader.show();
    ItemModel itemModel = ItemModel(
      userId: widget.itemModel.id.toString(),
      color: color.toString(),
      count: widget.itemModel.count,
      name: itemNameController.text.trim().toString(),
      groupId: groupId,
      expiryDate: widget.itemModel.expiryDate.toString(),
      minimumStockAlert: widget.itemModel.minimumStockAlert,
      stockImage: widget.itemModel.stockImage,
      isEnableExpiry: widget.itemModel.isEnableExpiry,
      createdAt: widget.itemModel.createdAt.toString(),
    );
    await groupsCollection
        .doc(groupId)
        .collection(Endpoints.itemsTable)
        .doc(widget.itemModel.id)
        .set(itemModel.toMap())
        .then((value) async {
      await outerItemsCollection.doc(widget.itemModel.id).delete();
      await groupsCollection
          .doc(widget.groupId)
          .collection(Endpoints.itemsTable)
          .doc(widget.itemModel.id)
          .delete()
          .then((value) {
        ToastLoader.remove();
        DisplayUtils.showToast(context, 'Group updated successfully');
      }).catchError((error) {});
    }).catchError((error) {
      ToastLoader.remove();
      DisplayUtils.showErrorToast(context, error.message);
    });
  }

  @override
  void initState() {
    super.initState();
    color = Color(int.parse(widget.itemModel.color));
    itemNameController.text = widget.itemModel.name;
    groupsCollection = usersCollection
        .doc(widget.userModel.id)
        .collection(Endpoints.groupsTable);
    itemsCollection =
        groupsCollection.doc(widget.groupId).collection(Endpoints.itemsTable);
    groupsStream = groupsCollection.snapshots();
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
                                  if (!isBlackFamily(color)) {
                                    setState(() {
                                      this.color = color;
                                      updateItem(
                                          widget.itemModel.id.toString(),
                                          color.value.toString(),
                                          Endpoints.itemColor);
                                    });
                                  } else {
                                    DisplayUtils.showSnackBar(
                                        context, 'Black colour can not select');
                                  }
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
                          keyboardType: TextInputType.text,
                          boxConstraints: 44,
                          onChange: (value) {
                            if (value.isNotEmpty) {
                              updateItem(widget.itemModel.id.toString(), value,
                                  Endpoints.itemName);
                            }
                          },
                          textInputAction: TextInputAction.done),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 40,
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
                                createdAt: a['created_at'],
                                name: a[Endpoints.groupName],
                                isSelected: widget.groupId == document.id,
                              ));
                            }).toList();
                            groupNameItems.sort(
                                (a, b) => b.createdAt.compareTo(a.createdAt));
                            context.read<GroupsCubit>().clearGroups();
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
                                                .updateGroupSelection(state
                                                    .groups[index].id
                                                    .toString());
                                            if (state.groups[index].id !=
                                                widget.itemModel.groupId) {
                                              moveItemToOtherGroup(
                                                  widget.itemModel.id
                                                      .toString(),
                                                  state.groups[index].id
                                                      .toString());
                                            }
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
                  deleteItem(context, widget.itemModel.id.toString());
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

  bool isBlackFamily(Color color, {int threshold = 50}) {
    return color.red <= threshold &&
        color.green <= threshold &&
        color.blue <= threshold;
  }
}
