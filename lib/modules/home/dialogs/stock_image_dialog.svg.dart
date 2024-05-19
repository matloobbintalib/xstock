import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/config/routes/nav_router.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/constants/asset_paths.dart';
import 'package:xstock/modules/common/image_picker/image_picker_cubit.dart';
import 'package:xstock/modules/home/dialogs/item_detail_dialog.dart';
import 'package:xstock/modules/home/dialogs/upload_picture_dialog.dart';
import 'package:xstock/modules/home/models/item_model.dart';
import 'package:xstock/ui/widgets/loading_indicator.dart';
import 'package:xstock/ui/widgets/on_click.dart';
import 'package:xstock/ui/widgets/picture_widget.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/ui/widgets/toast_loader.dart';
import 'package:xstock/utils/display/display_utils.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

class StockImageDialog extends StatefulWidget {
  final ItemModel itemModel;

  const StockImageDialog({super.key, required this.itemModel});

  @override
  State<StockImageDialog> createState() => _StockImageDialogState();
}

class _StockImageDialogState extends State<StockImageDialog> {
  late Stream<QuerySnapshot> itemDetailsStream;

  Future<String> fetchStockImage() async {
    DocumentReference docRef = FirebaseFirestore.instance.collection('item_details').doc(widget.itemModel.id);
    DocumentSnapshot docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      String jsonString = json.encode(docSnapshot.data());
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      Item item = Item.fromJson(jsonMap);
      return item.stockImage;
    } else {
      return '';
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
      child: BlocBuilder<ImagePickerCubit, ImagePickerState>(
        builder: (context, imagePickerState) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 17, vertical: 13),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      'Stock Image',
                      style: context.textTheme.bodySmall
                          ?.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
                    )),
                    OnClick(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return UploadPictureDialog();
                              }).then((value) async{
                            ToastLoader.show();
                            await uploadImage(context, imagePickerState.file, widget.itemModel.itemName).then((value) {
                              if(value.isNotEmpty){
                                updatePicture(context, value, widget.itemModel.id).then((value){
                                  ToastLoader.remove();
                                  DisplayUtils.flutterShowToast( 'Image Uploaded Successfully');
                                }).onError((error, stackTrace) {
                                  DisplayUtils.flutterShowToast(error.toString());
                                  ToastLoader.remove();
                                });
                              }
                            }).onError((error, stackTrace) {
                              DisplayUtils.flutterShowToast(error.toString());
                              ToastLoader.remove();
                            });
                          });
                        },
                        child: SvgPicture.asset(
                            "assets/images/svg/change_image_button.svg"))
                  ],
                ),
                SizedBox(height: 20),
                StreamBuilder(stream: FirebaseFirestore.instance.collection(
                    'item_details').doc(widget.itemModel.id).snapshots(), builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularLoadingIndicator(); // Show loading indicator while fetching data
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  String imageUrl = '';
                  if(snapshot.hasData){
                    imageUrl = snapshot.data!['stock_image'];
                  }
                  return PictureWidget(
                    imageUrl:imageUrl.isNotEmpty ? imageUrl: imagePickerState.hasImage
                        ? imagePickerState.file!.path
                        : 'assets/images/png/dummy_image.png',
                    errorPath: 'assets/images/png/dummy_image.png',
                    width: double.infinity,
                    height: 350,
                    radius: 18,
                  );
                }),
                SizedBox(
                  height: 14,
                ),
                PrimaryButton(
                  onPressed: () {
                    NavRouter.pop(context);
                  },
                  title: 'Cancel',
                  height: 54,
                  borderRadius: 10,
                  hMargin: 6,
                  backgroundColor: Colors.black,
                  borderColor: Colors.black,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<String> uploadImage(
      BuildContext context, File? file, String itemName) async {
    File? pickedFile = file;
    if (pickedFile != null) {
      final path = 'files/${itemName}';
      File file = File(pickedFile.path);
      final ref = FirebaseStorage.instance.ref().child(path);
      var uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});
      var urlDownload = await snapshot.ref.getDownloadURL();
      return urlDownload;
    }else{
      return '';
    }
  }

  Future<void> updatePicture(
      BuildContext context, String stock_image_url, String id) {
    CollectionReference itemsList =
        FirebaseFirestore.instance.collection('item_details');
    return itemsList
        .doc(id)
        .update({'stock_image': stock_image_url})
        .then((value) {})
        .catchError((error) {
          DisplayUtils.flutterShowToast( error.message);
        });
  }
}
