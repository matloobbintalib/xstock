import 'package:flutter/material.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      backgroundColor: context.colorScheme.background,
      surfaceTintColor: context.colorScheme.background,
      title: Text(title,style: context.textTheme.headlineLarge?.copyWith(color: Colors.black),),
      content: Text(message,style: context.textTheme.bodyLarge?.copyWith(color: Colors.black,fontWeight: FontWeight.w500)),
      actions: [
        PrimaryButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          width: 100,
          title: 'NO',
          height: 40,
          borderRadius: 6,
          backgroundColor: Colors.black,
          borderColor: Colors.black,
        ),
        PrimaryButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          title: 'YES',
          width: 100,
          height: 40,
          borderRadius: 10,
          backgroundColor: context.colorScheme.primary,
          borderColor: context.colorScheme.primary,
        )
      ],
    );
  }
}
