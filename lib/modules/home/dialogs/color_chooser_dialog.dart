import 'package:flutter/material.dart';
import 'package:xstock/config/routes/nav_router.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/modules/home/widgets/color_picker_test.dart';
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
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Choose Color",style: context.textTheme.headlineMedium?.copyWith(fontSize: 24,fontWeight: FontWeight.w700,color: Colors.white),),
            SizedBox(height: 10,),
            ColorPickerTes(
              color:widget.color,
              onChanged: (value){
                changedColor = value;
              },
              initialPicker: Picker.wheel,
            ),
            SizedBox(height: 30,),
            Row(
              children: [
                Expanded(child: PrimaryButton(onPressed: (){
                  NavRouter.pop(context);
                },title: 'Cancel',height: 50,borderRadius: 10,backgroundColor: Colors.black,borderColor: Colors.black,)),
                SizedBox(width: 20,),
                Expanded(child: PrimaryButton(onPressed: (){
                  widget.onChangeColor(changedColor);
                  NavRouter.pop(context);
                },title: 'Okay',height: 50,borderRadius: 10,backgroundColor: context.colorScheme.secondary,borderColor: context.colorScheme.secondary,),),
              ],
            )
          ],
        ),
      ),
    );
  }
}
