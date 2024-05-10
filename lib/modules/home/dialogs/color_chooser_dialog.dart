import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:xstock/config/routes/nav_router.dart';
import 'package:xstock/constants/app_colors.dart';

// import 'package:xstock/modules/home/widgets/color_picker_test.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

class ColorChooserDialog extends StatefulWidget {
  final Color color ;

  final Function(Color color) onChangeColor;

  const ColorChooserDialog({super.key, required this.color, required this.onChangeColor});

  @override
  State<ColorChooserDialog> createState() => _ColorChooserDialogState();
}

class _ColorChooserDialogState extends State<ColorChooserDialog> {
  late Color changedColor;

  @override
  void initState() {
    super.initState();
    changedColor = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.fieldColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.fieldColor)
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Choose Color",
              style: context.textTheme.headlineMedium?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            SizedBox(
              height: 20,
            ),
            ColorPicker(
              wheelHasBorder: false,
              borderRadius: 0,
              spacing: 0,
              color: widget.color,
              selectedColorIcon: Icons.check,
              shadesSpacing: 8,
                columnSpacing: 17,
                wheelSquarePadding: 10,
                wheelSquareBorderRadius: 0,
                onColorChanged: (color) {
                  changedColor = color;
                },
                pickersEnabled: const <ColorPickerType, bool>{
                  ColorPickerType.both: false,
                  ColorPickerType.primary: false,
                  ColorPickerType.accent: false,
                  ColorPickerType.bw: false,
                  ColorPickerType.custom: false,
                  ColorPickerType.wheel: true,
                }),
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
                  width: 20,
                ),
                Expanded(
                  child: PrimaryButton(
                    onPressed: () {
                      widget.onChangeColor(changedColor);
                      NavRouter.pop(context);
                    },
                    title: 'Okay',
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
      ),
    );
  }
}
