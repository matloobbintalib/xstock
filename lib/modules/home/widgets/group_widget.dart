import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/config/config.dart';
import 'package:xstock/modules/home/dialogs/delete_dialog.dart';
import 'package:xstock/modules/home/dialogs/item_detail_dialog.dart';
import 'package:xstock/modules/home/models/group_model.dart';
import 'package:xstock/modules/home/models/item_model.dart';
import 'package:xstock/modules/home/pages/add_item_page.dart';
import 'package:xstock/modules/home/widgets/item_widget.dart';
import 'package:xstock/ui/widgets/loading_indicator.dart';
import 'package:xstock/ui/widgets/on_click.dart';
import 'package:xstock/utils/display/display_utils.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

class GroupWidget extends StatefulWidget {
  final GroupModel groupModel;
  final VoidCallback onClick;

  const GroupWidget(
      {super.key, required this.groupModel, required this.onClick});

  @override
  State<GroupWidget> createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  List<ItemModel> items = [];
  Stream<QuerySnapshot> itemsStream =
      FirebaseFirestore.instance.collection('items').snapshots();
  int itemsCount = 0;
  int totalItems = 0;

  Future<void> deleteGroup(id) {
    CollectionReference groups =
    FirebaseFirestore.instance.collection('groups');
    return groups.doc(id).delete().then((value) {
      DisplayUtils.showToast(context, 'Group deleted successfully');
    }).catchError((error) {
      DisplayUtils.showErrorToast(context, 'Failed to Delete Group');
    });
  }

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
                      widget.groupModel.title,
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
                            onConfirmDelete: () async{
                              await deleteGroup(widget.groupModel.id);
                              NavRouter.pop(context);
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
                    NavRouter.push(
                        context,
                        AddItemPage(
                          groupId: widget.groupModel.id,
                        ));
                  },
                  child: SvgPicture.asset(
                      "assets/images/svg/add_item_button.svg")),
            ),
          ],
        ),
        Visibility(
          visible: widget.groupModel.isExpandable,
          child: StreamBuilder<QuerySnapshot>(
              stream: itemsStream,
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
                          itemColor: a['color_code'],
                          itemCount: a['item_count'] as int,
                          itemName: a['item_name'],
                          groupId: a['group_id']),
                    );
                    var count = a['item_count'] as int;
                    itemsCount = itemsCount + count;
                  }
                }).toList();
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
                                );
                              });
                        },
                        child: ItemWidget(
                          itemModel: items[index],
                          index: index,
                        ),
                      );
                    });
              }),
        )
      ],
    );
  }
}
