import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vibration/vibration.dart';
import 'package:xstock/constants/api_endpoints.dart';
import 'package:xstock/constants/constants.dart';
import 'package:xstock/core/di/service_locator.dart';
import 'package:xstock/modules/authentication/models/user_model.dart';
import 'package:xstock/modules/common/repo/session_repository.dart';
import 'package:xstock/modules/home/models/item_model.dart';
import 'package:xstock/utils/display/display_utils.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

class ItemWidget extends StatefulWidget {
  final ItemModel itemModel;
  final UserModel userModel;
  final String groupId;
  final int index;

  const ItemWidget(
      {super.key,
      required this.index,
      required this.itemModel,
      required this.userModel,
      required this.groupId});

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection(Endpoints.usersTable);
  late CollectionReference groupsCollection;
  late CollectionReference itemsCollection;
  SessionRepository sessionRepository = sl<SessionRepository>();
  CollectionReference outerItemsCollection =
      FirebaseFirestore.instance.collection(Endpoints.itemsTable);

  void initializeItemsCollection() async {
    DocumentReference userRef = usersCollection.doc(widget.userModel.id);
    groupsCollection = userRef.collection(Endpoints.groupsTable);
    itemsCollection =
        groupsCollection.doc(widget.groupId).collection(Endpoints.itemsTable);
  }

  Future<void> updateItemCount(int count, String id) {
    return itemsCollection
        .doc(id)
        .update({Endpoints.itemCount: count}).then((value) async {
      outerItemsCollection.doc(id).update({Endpoints.itemCount: count});
    }).catchError((error) {
      DisplayUtils.showErrorToast(context, error.message);
    });
  }

  @override
  void initState() {
    super.initState();
    initializeItemsCollection();
  }

  @override
  Widget build(BuildContext context) {
    var code = int.parse(widget.itemModel.color);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Color(code)),
      padding: EdgeInsets.only(left: 10, top: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 12),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  widget.itemModel.name,
                  style: context.textTheme.headlineSmall
                      ?.copyWith(color: Colors.black, fontSize: 16),
                )),
                SvgPicture.asset("assets/images/svg/ic_item.svg")
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () async {
                    int value = widget.itemModel.count;
                    if (value > 0) {
                      value--;
                      updateItemCount(value, widget.itemModel.id.toString());
                      bool isEnable = sessionRepository.isEnableItemVibration();
                      if (isEnable) {
                        if (await Vibration.hasVibrator() == true) {
                          Vibration.vibrate();
                        }
                      }
                    }
                  },
                  icon: SvgPicture.asset("assets/images/svg/ic_minus.svg")),
              Expanded(
                  child: Text(
                widget.itemModel.count.toString(),
                style: context.textTheme.headlineLarge
                    ?.copyWith(color: Colors.black, fontSize: 32),
                textAlign: TextAlign.center,
              )),
              IconButton(
                  onPressed: () async {
                    int value = widget.itemModel.count;
                    value++;
                    updateItemCount(value, widget.itemModel.id.toString());
                    bool isEnable = sessionRepository.isEnableItemVibration();
                    if (isEnable) {
                      if (await Vibration.hasVibrator() == true) {
                        Vibration.vibrate();
                      }
                    }
                  },
                  icon: SvgPicture.asset("assets/images/svg/ic_plus.svg")),
            ],
          )
        ],
      ),
    );
  }
}
