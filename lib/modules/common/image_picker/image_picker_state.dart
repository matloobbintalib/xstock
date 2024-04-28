part of 'image_picker_cubit.dart';

class ImagePickerState {
  final File? file;
  final File? profileImage;
  final File? identityCard;
  final List<File> files;
  final bool hasImage;

  ImagePickerState({required this.file, required this.profileImage, required this.identityCard, required this.files, required this.hasImage});

  factory ImagePickerState.initial() {
    return ImagePickerState(
      file: null,
      profileImage: null,
      identityCard: null,
      files: const [],
      hasImage: false,
    );
  }
  ImagePickerState copyWith({
    File? file,
    File? profileImage,
    File? identityCard,
    List<File>? files,
    bool? hasImage,
  }) {
    return ImagePickerState(
      file : file?? this.file,
      profileImage: profileImage?? this.profileImage,
      identityCard:identityCard?? this.identityCard,
      files: files?? this.files,
      hasImage: hasImage?? this.hasImage,
    );
  }
}
