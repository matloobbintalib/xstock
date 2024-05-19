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

  void pickImage(ImageSource source) async {
    final file = await _imagePickerRepo.pickImage(source);
    if (file == null) {
      emit(state.copyWith(file:null,hasImage: false));
    } else {
      emit(state.copyWith(file:file,hasImage: true));
    }
  }

  void clear() {
    emit(ImagePickerState.initial());
  }
}
