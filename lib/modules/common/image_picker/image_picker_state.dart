part of 'image_picker_cubit.dart';

class ImagePickerState {
  final File? file;
  final bool hasImage;

  ImagePickerState({required this.file,required this.hasImage});

  factory ImagePickerState.initial() {
    return ImagePickerState(
      file: null,
      hasImage: false,
    );
  }
  ImagePickerState copyWith({
    File? file,
    bool? hasImage,
  }) {
    return ImagePickerState(
      file : file?? this.file,
      hasImage: hasImage?? this.hasImage,
    );
  }
}
