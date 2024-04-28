
import 'package:flutter/material.dart';

class UploadPictureDialogWidget extends StatelessWidget {
  const UploadPictureDialogWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      surfaceTintColor: Colors.transparent,
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 150,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 32,
                    ),
                    const Text(
                      'Choose',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context, 'camera');
                              },
                              tooltip: 'Camera',
                              icon: const Icon(Icons.camera,size: 40,),
                            ),
                            const Text('Camera'),
                          ],
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context, 'gallery');
                              },
                              tooltip: 'Gallery',
                              icon: const Icon(Icons.photo,size: 40,),
                            ),
                            const Text('Gallery'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: -70,
                  left: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 44,
                    child: Image.asset('assets/images/png/ic_upload_image.png'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
