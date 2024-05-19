import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/config/routes/nav_router.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/modules/home/dialogs/stock_image_dialog.svg.dart';
import 'package:xstock/modules/home/dialogs/upload_picture_dialog.dart';
import 'package:xstock/modules/home/models/item_detail_model.dart';
import 'package:xstock/modules/home/models/item_model.dart';
import 'package:xstock/modules/home/pages/edit_item_page.dart';
import 'package:xstock/ui/input/input_field.dart';
import 'package:xstock/ui/widgets/on_click.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/ui/widgets/remember_me_widget.dart';
import 'package:xstock/ui/widgets/toast_loader.dart';
import 'package:xstock/utils/custom_date_time_picker.dart';
import 'package:xstock/utils/display/display_utils.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

class ItemDetailDialog extends StatefulWidget {
  final ItemModel itemModel;
  final String groupDocId;

  const ItemDetailDialog(
      {super.key, required this.itemModel, required this.groupDocId});

  @override
  State<ItemDetailDialog> createState() => _ItemDetailDialogState();
}

class _ItemDetailDialogState extends State<ItemDetailDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController inputCountController = new TextEditingController();
  TextEditingController minimumAlertCountController =
      new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  CollectionReference itemDetails =
      FirebaseFirestore.instance.collection('item_details');
  CollectionReference items = FirebaseFirestore.instance.collection('items');
  int _selectedTabIndex = 0;
  bool isEnableExpiry = false;
  int itemCount = 0;

  final _tabs = [
    Tab(text: 'Add Quantity'),
    Tab(text: 'Reduce Quantity'),
  ];

  @override
  void initState() {
    super.initState();
    itemCount = widget.itemModel.itemCount;
    inputCountController.text = widget.itemModel.itemCount.toString();
    _tabController = TabController(length: 2, vsync: this);
    getItemById(widget.itemModel.id);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void addItemDetails() async {
    ToastLoader.show();
    updateItemCount(itemCount, widget.itemModel.id);
    DocumentReference docRef = itemDetails.doc(widget.itemModel.id);
    await docRef.set({
      'group_id': widget.itemModel.groupId,
      'item_id': widget.itemModel.id,
      'color_code': widget.itemModel.itemColor,
      "item_name": widget.itemModel.itemName,
      "item_count": itemCount,
      "is_enable_expiry": isEnableExpiry,
      "current_date":
          changeDateTimeFormat(DateTime.now(), 'MM/dd/yyyy  hh:ss a'),
      "expiry_date":
          isEnableExpiry ? dateController.text.trim().toString() : '',
      "minimum_stock_alert": minimumAlertCountController.text.toString(),
      "stock_image": '',
    }).then((value) {
      ToastLoader.remove();
      DisplayUtils.showToast(context, 'Item details added successfully');
      NavRouter.pop(context);
    }).onError((error, stackTrace) {
      ToastLoader.remove();
      DisplayUtils.flutterShowToast( error.toString());
    });
  }

  void getItemById(String documentId) async {
    try {
      ToastLoader.show();
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('item_details')
          .doc(documentId)
          .get();
      if (docSnapshot.exists) {
        String jsonString = json.encode(docSnapshot.data());
        print(jsonString);
        Map<String, dynamic> jsonMap = json.decode(jsonString);
        Item item = Item.fromJson(jsonMap);
        minimumAlertCountController.text = item.minimumStockAlert.toString();
        dateController.text = item.expiryDate.toString();
        isEnableExpiry = item.isEnableExpiry;
        ToastLoader.remove();
      } else {
        ToastLoader.remove();
      }
    } catch (e) {
      ToastLoader.remove();
      DisplayUtils.flutterShowToast('Error getting document: $e');
    }
  }

  Future<void> updateItemCount(int count, String id) {
    return items
        .doc(id)
        .update({'item_count': count})
        .then((value) {})
        .catchError((error) {
          DisplayUtils.flutterShowToast( error.message);
        });
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
    return Dialog(
      backgroundColor: AppColors.fieldColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.fieldColor)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: parseColor(widget.itemModel.itemColor)),
              padding: EdgeInsets.only(left: 20, right: 16) +
                  EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Text(
                    itemCount.toString(),
                    style: context.textTheme.headlineMedium
                        ?.copyWith(color: Colors.black),
                  ),
                  Expanded(
                      child: Text(
                    widget.itemModel.itemName,
                    textAlign: TextAlign.center,
                    style: context.textTheme.headlineMedium?.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  )),
                  OnClick(
                      onTap: () {
                        NavRouter.pop(context);
                        NavRouter.pushWithAnimation(
                            context,
                            EditItemPage(
                              itemModel: widget.itemModel,
                              groupDocId: widget.groupDocId,
                            ));
                      },
                      child: SvgPicture.asset(
                          "assets/images/svg/ic_edit_item.svg"))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 16),
              child: Column(
                children: [
                  Text(
                    changeDateTimeFormat(DateTime.now(), 'MM/dd/yyyy  hh:ss a'),
                    style:
                        context.textTheme.headlineSmall?.copyWith(fontSize: 12),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Container(
                    height: kToolbarHeight - 8.0,
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TabBar(
                      indicatorColor: Colors.transparent,
                      indicatorWeight: 0,
                      dividerColor: Colors.transparent,
                      controller: _tabController,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: context.colorScheme.primary),
                      labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                      unselectedLabelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                      unselectedLabelColor: Colors.white,
                      tabs: _tabs,
                      onTap: (index) {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                      indicatorSize: TabBarIndicatorSize.tab,
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  InputField(
                      controller: inputCountController,
                      label: 'Input Count',
                      verticalPadding: 18,
                      readOnly: true,
                      borderRadius: 10,
                      borderColor: Colors.black,
                      fillColor: Colors.black,
                      keyboardType: TextInputType.number,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 12),
                        child: OnClick(
                          onTap: () {
                            if (_selectedTabIndex == 0) {
                              itemCount++;
                              setState(() {
                                inputCountController.text =
                                    itemCount.toString();
                              });
                            } else if (_selectedTabIndex == 1) {
                              if (itemCount > 0) {
                                itemCount--;
                                setState(() {
                                  inputCountController.text =
                                      itemCount.toString();
                                });
                              }
                            }
                          },
                          child: SvgPicture.asset(_selectedTabIndex == 0
                              ? "assets/images/svg/ic_add_item.svg"
                              : 'assets/images/svg/ic_minus.svg'),
                        ),
                      ),
                      textInputAction: TextInputAction.done),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        "Minimum Stock Alert",
                        style: context.textTheme.bodyMedium,
                      )),
                      OnClick(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StockImageDialog(itemModel: widget.itemModel,);
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: SvgPicture.asset(
                              "assets/images/svg/ic_take_picture.svg"),
                        ),
                      )
                    ],
                  ),
                  InputField(
                      controller: minimumAlertCountController,
                      label: 'i-e : 01',
                      verticalPadding: 18,
                      borderRadius: 10,
                      borderColor: Colors.black,
                      fillColor: Colors.black,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done),
                  SizedBox(
                    height: 14,
                  ),
                  RememberMeWidget(
                    isSelected: isEnableExpiry,
                    title: "Enable Expiry Date Alerts(Optional)",
                    titleColor: Colors.white,
                    checkBoxSize: 20,
                    onTab: (value) {
                      setState(() {
                        isEnableExpiry = value;
                      });
                    },
                    checkColor: AppColors.fieldColor,
                    fontSize: 14,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  InputField(
                      controller: dateController,
                      label: 'Select Date',
                      onTap: () async {
                        String date =
                            await CustomDateTimePicker.selectDate(context);
                        dateController.text = date;
                      },
                      verticalPadding: 18,
                      readOnly: true,
                      borderRadius: 10,
                      borderColor: Colors.black,
                      fillColor: Colors.black,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Disclaimer! Expiry Date Alerts give notifications 2 day before expiry.",
                    style: context.textTheme.bodySmall?.copyWith(fontSize: 10),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: PrimaryButton(
                        onPressed: () {
                          NavRouter.pop(context);
                        },
                        title: 'Cancel',
                        height: 50,
                        borderRadius: 10,
                        backgroundColor: Colors.black,
                        borderColor: Colors.black,
                      )),
                      SizedBox(
                        width: 22,
                      ),
                      Expanded(
                        child: PrimaryButton(
                          onPressed: () {
                            if (minimumAlertCountController.text
                                .trim()
                                .isNotEmpty) {
                              if (isEnableExpiry) {
                                if (dateController.text.trim().isEmpty) {
                                  DisplayUtils.flutterShowToast("Select expiry date");
                                } else {
                                  addItemDetails();
                                }
                              } else {
                                addItemDetails();
                              }
                            } else {
                              DisplayUtils.flutterShowToast("Enter minimum stock alert count");
                            }
                          },
                          title: 'Confirm',
                          height: 50,
                          borderRadius: 10,
                          backgroundColor: context.colorScheme.secondary,
                          borderColor: context.colorScheme.secondary,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Item {
  final int itemCount;
  final String currentDate;
  final String itemId;
  final String groupId;
  final int minimumStockAlert;
  final String stockImage;
  final String expiryDate;
  final String itemName;
  final String colorCode;
  final bool isEnableExpiry;

  Item({
    required this.itemCount,
    required this.currentDate,
    required this.itemId,
    required this.groupId,
    required this.minimumStockAlert,
    required this.stockImage,
    required this.expiryDate,
    required this.itemName,
    required this.colorCode,
    required this.isEnableExpiry,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemCount: json['item_count'],
      currentDate: json['current_date'],
      itemId: json['item_id'],
      groupId: json['group_id'],
      minimumStockAlert: int.parse(json['minimum_stock_alert']),
      stockImage: json['stock_image'],
      expiryDate: json['expiry_date'],
      itemName: json['item_name'],
      colorCode: json['color_code'],
      isEnableExpiry: json['is_enable_expiry'],
    );
  }
}
