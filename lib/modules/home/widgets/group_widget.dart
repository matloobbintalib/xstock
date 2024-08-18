import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/constants/api_endpoints.dart';
import 'package:xstock/modules/authentication/models/user_model.dart';
import 'package:xstock/modules/home/cubits/send_notification/send_notification_cubit.dart';
import 'package:xstock/modules/home/dialogs/delete_dialog.dart';
import 'package:xstock/modules/home/dialogs/item_detail_dialog.dart';
import 'package:xstock/modules/home/models/group_model.dart';
import 'package:xstock/modules/home/models/item_model.dart';
import 'package:xstock/modules/home/models/notification_input.dart';
import 'package:xstock/modules/home/widgets/item_widget.dart';
import 'package:xstock/ui/widgets/loading_indicator.dart';
import 'package:xstock/ui/widgets/on_click.dart';
import 'package:xstock/ui/widgets/toast_loader.dart';
import 'package:xstock/utils/display/display_utils.dart';
import 'package:xstock/utils/extensions/context_user.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

class GroupWidget extends StatefulWidget {
  final GroupModel groupModel;
  final VoidCallback onClick;
  final UserModel userModel;
  final Function(String groupId) onAddItem;

  const GroupWidget(
      {super.key,
      required this.groupModel,
      required this.onClick,
      required this.onAddItem,
      required this.userModel});

  @override
  State<GroupWidget> createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  List<ItemModel> items = [];
  Stream<QuerySnapshot>? itemsStream;
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection(Endpoints.usersTable);
  late CollectionReference groupsCollection;
  late CollectionReference itemsCollection;
  int itemsCount = 0;
  int totalItems = 0;
  CollectionReference outerItemsCollection =
      FirebaseFirestore.instance.collection(Endpoints.itemsTable);

  Future<void> deleteGroup(BuildContext context, id) async {
    ToastLoader.show();
    DocumentReference userRef = await usersCollection.doc(widget.userModel.id);
    groupsCollection = await userRef.collection(Endpoints.groupsTable);
    await groupsCollection.doc(id).delete().then((value) async {
      ToastLoader.remove();
      DisplayUtils.flutterShowToast('Group deleted successfully');
    }).catchError((error) {
      ToastLoader.remove();
      DisplayUtils.flutterShowToast('Failed to Delete Group');
    });
  }

  @override
  void initState() {
    super.initState();
    initializeItemsStream();
  }

  void initializeItemsStream() {
    DocumentReference userRef = usersCollection.doc(widget.userModel.id);
    groupsCollection = userRef.collection(Endpoints.groupsTable);
    itemsCollection = groupsCollection
        .doc(widget.groupModel.id)
        .collection(Endpoints.itemsTable);
    itemsStream = itemsCollection.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    var user = context.watchCurrentUser;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                constraints: BoxConstraints(),
                style: const ButtonStyle(
                  tapTargetSize:
                      MaterialTapTargetSize.shrinkWrap, // the '2023' part
                ),
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                onPressed: widget.onClick,
                icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RotationTransition(
                      turns: AlwaysStoppedAnimation(
                          widget.groupModel.isExpandable ? 0 : 270 / 360),
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
                      widget.groupModel.name,
                      style: context.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                )),
            SizedBox(
              width: 10,
            ),
            Visibility(
                visible: widget.groupModel.isExpandable, child: Spacer()),
            Visibility(
                visible: !widget.groupModel.isExpandable,
                child: Text(
                  "${totalItems} items, ${itemsCount} in total",
                  style: context.textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.w300, fontSize: 10),
                )),
            Visibility(
              visible: widget.groupModel.isExpandable,
              child: OnClick(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DeleteDialog(
                            title: 'group',
                            onConfirmDelete: () {
                              deleteGroup(context, widget.groupModel.id);
                            },
                          );
                        });
                  },
                  child: SvgPicture.asset(
                      "assets/images/svg/delete_group_button.svg")),
            ),
            SizedBox(
              width: 10,
            ),
            Visibility(
              visible: widget.groupModel.isExpandable,
              child: OnClick(
                  onTap: () {
                    widget.onAddItem(widget.groupModel.id);
                  },
                  child: SvgPicture.asset(
                      "assets/images/svg/add_item_button.svg")),
            ),
          ],
        ),
        Visibility(
          visible: widget.groupModel.isExpandable,
          child: StreamBuilder<QuerySnapshot>(
              stream: usersCollection
                  .doc(widget.userModel.id)
                  .collection(Endpoints.groupsTable)
                  .doc(widget.groupModel.id)
                  .collection(Endpoints.itemsTable)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularLoadingIndicator(),
                  );
                }
                if (snapshot.data!.docs.length == 3) {
                  context.read<NotificationCubit>().sendEmailNotification(
                      NotificationInput(
                        name: user.branchName,
                        message:
                            'Your group ${widget.groupModel.name} have remaining 3 items in the stock',
                      ),
                      user.email);
                }
                items.clear();
                itemsCount = 0;
                totalItems = 0;
                snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map a = document.data() as Map<String, dynamic>;
                  if (a['group_id'].toString() ==
                      widget.groupModel.id.toString()) {
                    items.add(
                      ItemModel(
                        id: document.id,
                        color: a[Endpoints.itemColor],
                        count: a[Endpoints.itemCount] as int,
                        name: a[Endpoints.itemName],
                        groupId: a['group_id'],
                        minimumStockAlert: a[Endpoints.minimumStockAlert],
                        stockImage: a[Endpoints.stockImage],
                        expiryDate: a[Endpoints.expiryDate],
                        isEnableExpiry: a[Endpoints.isEnableExpiry],
                        userId: a[Endpoints.userId],
                        createdAt: a['created_at'],
                      ),
                    );
                    var count = a[Endpoints.itemCount] as int;
                    itemsCount = itemsCount + count;
                  }
                }).toList();
                items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                totalItems = items.length;
                return MasonryGridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    padding: EdgeInsets.symmetric(vertical: 10) +
                        EdgeInsets.only(bottom: 10),
                    itemBuilder: (BuildContext context, int index) {
                      return OnClick(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ItemDetailDialog(
                                  itemModel: items[index],
                                  groupDocId: widget.groupModel.id,
                                  userModel: user,
                                );
                              });
                        },
                        child: ItemWidget(
                          itemModel: items[index],
                          index: index,
                          userModel: user,
                          groupId: widget.groupModel.id,
                        ),
                      );
                    });
              }),
        )
      ],
    );
  }
}
