import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xstock/config/routes/nav_router.dart';
import 'package:xstock/constants/api_endpoints.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/constants/asset_paths.dart';
import 'package:xstock/constants/constants.dart';
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

import '../../authentication/models/user_model.dart';

class StockImageDialog extends StatefulWidget {
  final ItemModel itemModel;
  final UserModel userModel;

  const StockImageDialog(
      {super.key, required this.itemModel, required this.userModel});

  @override
  State<StockImageDialog> createState() => _StockImageDialogState();
}

class _StockImageDialogState extends State<StockImageDialog> {
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection(Endpoints.usersTable);
  bool hasImage = false;
  final StreamController<String> _eventController = StreamController<String>();

  @override
  void initState() {
    super.initState();
    context.read<ImagePickerCubit>().clear();
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
                                return UploadPictureDialog(
                                  onGallerySelect: () {
                                    context
                                        .read<ImagePickerCubit>()
                                        .pickImage(ImageSource.gallery);
                                  },
                                  onCameraSelect: () {
                                    context
                                        .read<ImagePickerCubit>()
                                        .pickImage(ImageSource.camera);
                                  },
                                );
                              });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Color(0xFF00D8FA),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                  'assets/images/svg/ic_stock_image_camera.svg'),
                              SizedBox(width: 5),
                              StreamBuilder<String>(
                                stream: _eventController.stream,
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> snapshot) {
                                  if (snapshot.hasData && snapshot.data.toString().isNotEmpty) {
                                    return Text('Change photo',
                                        style: context.textTheme.bodySmall
                                            ?.copyWith(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black));
                                  } else {
                                    return Text('Add photo',
                                        style: context.textTheme.bodySmall
                                            ?.copyWith(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black));
                                  }
                                },
                              )
                            ],
                          ),
                        ))
                  ],
                ),
                SizedBox(height: 20),
                StreamBuilder<QuerySnapshot>(
                    stream: usersCollection
                        .doc(widget.userModel.id)
                        .collection(Endpoints.groupsTable)
                        .doc(widget.itemModel.groupId)
                        .collection(Endpoints.itemsTable)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularLoadingIndicator(); // Show loading indicator while fetching data
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      String imageUrl = '';
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isNotEmpty) {
                          snapshot.data!.docs.forEach((element) {
                            if (element['id'] == widget.itemModel.id) {
                              imageUrl = element['stock_image'];
                            }
                          });
                        }
                      }
                      if (imagePickerState.hasImage || imageUrl.isNotEmpty) {
                        _eventController.sink.add('image added');
                        return PictureWidget(
                          imageUrl: imagePickerState.hasImage
                              ? imagePickerState.file!.path
                              : imageUrl.isNotEmpty
                                  ? imageUrl
                                  : 'assets/images/png/placeholder.png',
                          errorPath: 'assets/images/png/placeholder.png',
                          width: double.infinity,
                          height: 350,
                          radius: 18,
                        );
                      } else {
                        _eventController.sink.add('');
                        return Container(
                            height: 350,
                            width: double.infinity,
                            color: AppColors.fieldColor,
                            child: Center(
                                child: Text(
                              'No stock image',
                            )));
                      }
                    }),
                SizedBox(
                  height: 14,
                ),
                imagePickerState.hasImage
                    ? PrimaryButton(
                        onPressed: () async {
                          ToastLoader.show();
                          String imageUrl = await uploadImage(
                              context,
                              imagePickerState.file,
                              '${widget.itemModel.name}_${DateTime.now().millisecondsSinceEpoch}');
                          if (imageUrl.isNotEmpty) {
                            await updatePicture(context, imageUrl)
                                .then((value) {
                              ToastLoader.remove();
                              DisplayUtils.flutterShowToast(
                                  'Image Uploaded Successfully');
                            }).onError((error, stackTrace) {
                              DisplayUtils.flutterShowToast(error.toString());
                              ToastLoader.remove();
                            });
                          } else {
                            DisplayUtils.flutterShowToast(
                                'Something went wrong');
                            ToastLoader.remove();
                          }
                        },
                        title: 'Upload Image',
                        height: 54,
                        borderRadius: 10,
                        hMargin: 6,
                        backgroundColor: Colors.black,
                        borderColor: Colors.black,
                      )
                    : PrimaryButton(
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
    try {
      File? pickedFile = file;
      if (pickedFile != null) {
        final path = 'files/${itemName}';
        File file = File(pickedFile.path);
        final ref = FirebaseStorage.instance.ref().child(path);
        var uploadTask = ref.putFile(file);
        final snapshot = await uploadTask.whenComplete(() {});
        var urlDownload = await snapshot.ref.getDownloadURL();
        return urlDownload;
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  Future<void> updatePicture(
    BuildContext context,
    String stock_image_url,
  ) async {
    DocumentReference userRef = await usersCollection.doc(widget.userModel.id);
    CollectionReference groupsCollection =
        await userRef.collection(Endpoints.groupsTable);
    CollectionReference itemsCollection = await groupsCollection
        .doc(widget.itemModel.groupId)
        .collection(Endpoints.itemsTable);
    return itemsCollection
        .doc(widget.itemModel.id)
        .update({Endpoints.stockImage: stock_image_url}).then((value) {
      ToastLoader.remove();
      DisplayUtils.flutterShowToast("Uploaded successfully");
      NavRouter.pop(context);
    }).catchError((error) {
      ToastLoader.remove();
      print("Error : ${error.message}");
      DisplayUtils.flutterShowToast(error.message);
    });
  }
}
