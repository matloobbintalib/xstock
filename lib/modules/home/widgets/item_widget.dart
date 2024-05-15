import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/modules/home/models/item_model.dart';
import 'package:xstock/utils/display/display_utils.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

class ItemWidget extends StatefulWidget {
  final ItemModel itemModel;
  final int index;

  const ItemWidget({super.key, required this.index, required this.itemModel});

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  CollectionReference items = FirebaseFirestore.instance.collection('items');

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

  Future<void> updateItemCount(int count, String id) {
    return items
        .doc(id)
        .update({'item_count': count})
        .then((value) {})
        .catchError((error) {
          DisplayUtils.showErrorToast(context, error.message);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: parseColor(widget.itemModel.itemColor)),
      padding: EdgeInsets.only(left: 10, top: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 12),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  widget.itemModel.itemName,
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
                  onPressed: () {
                    int value = widget.itemModel.itemCount;
                    if(value > 1) {
                      value--;
                      updateItemCount(value, widget.itemModel.id);
                    }
                  },
                  icon: SvgPicture.asset("assets/images/svg/ic_minus.svg")),
              Expanded(
                  child: Text(
                widget.itemModel.itemCount.toString(),
                style: context.textTheme.headlineLarge
                    ?.copyWith(color: Colors.black, fontSize: 32),
                textAlign: TextAlign.center,
              )),
              IconButton(
                  onPressed: () {
                    int value = widget.itemModel.itemCount;
                    value++;
                    updateItemCount(value, widget.itemModel.id);
                  },
                  icon: SvgPicture.asset("assets/images/svg/ic_plus.svg")),
            ],
          )
        ],
      ),
    );
  }
}
