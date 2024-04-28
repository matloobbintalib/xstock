import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xstock/modules/common/repo/image_picker_repo.dart';

part 'image_picker_state.dart';

class ImagePickerCubit extends Cubit<ImagePickerState> {
  ImagePickerCubit(this._imagePickerRepo)
      : super( ImagePickerState.initial());

  final ImagePickerRepo _imagePickerRepo;
  List<File> pickedFiles = [];

  void pickProfileImage(ImageSource source) async {
    final file = await _imagePickerRepo.pickImage(source);
    if (file == null) {
      emit(state.copyWith(profileImage: null));
    } else {
      emit(state.copyWith(profileImage: file));
    }
  }

  void pickIdentityCard(ImageSource source) async {
    final file = await _imagePickerRepo.pickImage(source);
    if (file == null) {
      emit(state.copyWith(identityCard: null));
    } else {
      emit(state.copyWith(identityCard: file));
    }
  }

  void pickImage(ImageSource source) async {
    final file = await _imagePickerRepo.pickImage(source);
    if (file == null) {
      emit(state.copyWith(files: []));
    } else {
      var compressedFile = await compressImage(file.path);
      if (compressedFile != null) {
        pickedFiles.add(compressedFile);
      }
      emit(state.copyWith(files: pickedFiles));
    }
  }

  void pickFiles() async {
    final files = await _imagePickerRepo.pickFiles();
    pickedFiles.addAll(files);
    emit(state.copyWith(files: pickedFiles));
  }

  void clear() {
    pickedFiles.clear();
    emit(ImagePickerState.initial());
  }

  void removeImage(String path) {
    pickedFiles.removeWhere((element) => element.path == path);
    emit(state.copyWith(files: pickedFiles));
  }

  Future<File?> compressImage(String imagePath) async {
    try {
      // Compress the image
      XFile? compressedImage = await FlutterImageCompress.compressAndGetFile(
        imagePath,
        imagePath.endsWith('.png')
            ? imagePath.replaceAll('.png', '_compressed.jpg')
            : imagePath.replaceAll('.jpg', '_compressed.jpg'),
        minWidth: 1024,
        minHeight: 1024,
        quality: 85,
      );
      if (compressedImage != null) {
        return File(compressedImage.path);
      }
      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
