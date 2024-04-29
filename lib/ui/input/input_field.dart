import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xstock/utils/utils.dart';

import '../../constants/app_colors.dart';
import '../../utils/validators/validators.dart';

class InputField extends StatefulWidget {
  const InputField({
    required this.controller,
    required this.label,
    required this.textInputAction,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onFieldSubmitted,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines = 1,
    this.inputFormatters = null,
    this.readOnly = false,
    this.onTap,
    this.autoFocus = false,
    super.key,
    this.onChange,
    this.borderColor,
    this.borderRadius = 16,
    this.fontSize = 14,
    this.boxConstraints = 44,
    this.fontWeight = FontWeight.w400,
    this.fillColor = const  Color(0xFF252934),
    this.hintColor = AppColors.grey1,
    this.horizontalPadding = 24,
    this.verticalPadding = 10,
  });

  final TextEditingController controller;
  final String label;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool autoFocus;
  final Function(String)? onChange;
  final Color fillColor;
  final Color? borderColor;
  final Color hintColor;
  final double borderRadius;
  final double horizontalPadding;
  final double verticalPadding;
  final double fontSize;
  final double boxConstraints;
  final FontWeight fontWeight;

  InputField.name({
    required TextEditingController controller,
    String label = 'Name',
    Function(String)? onChange,
    TextInputAction textInputAction = TextInputAction.next,
    ValueChanged<String>? onFieldSubmitted,
    Widget? suffixIcon,
  }) : this(
          controller: controller,
          label: label,
          textInputAction: textInputAction,
          keyboardType: TextInputType.name,
          validator: Validators.required,
          onFieldSubmitted: onFieldSubmitted,
          suffixIcon: suffixIcon,
          onChange: onChange,
        );

  InputField.phone(
      {required TextEditingController controller,
      String label = 'Phone',
      TextInputAction textInputAction = TextInputAction.next,
      ValueChanged<String>? onFieldSubmitted,
      List<TextInputFormatter>? inputFormatters})
      : this(
            controller: controller,
            label: label,
            textInputAction: textInputAction,
            keyboardType: TextInputType.phone,
            validator: Validators.required,
            onFieldSubmitted: onFieldSubmitted,
            inputFormatters: inputFormatters);

  InputField.email({
    required TextEditingController controller,
    String label = 'Email',
    Function(String)? onChange,
    TextInputAction textInputAction = TextInputAction.next,
    ValueChanged<String>? onFieldSubmitted,
    Widget? suffixIcon,
    Widget? prefixIcon,
  }) : this(
          controller: controller,
          label: label,
          textInputAction: textInputAction,
          keyboardType: TextInputType.emailAddress,
          validator: Validators.email,
          onFieldSubmitted: onFieldSubmitted,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          onChange: onChange,
        );

  InputField.password({
    required TextEditingController controller,
    required Widget suffixIcon,
    required bool obscureText,
    String label = 'Password',
    TextInputAction textInputAction = TextInputAction.next,
    ValueChanged<String>? onFieldSubmitted,
    Widget? prefixIcon,
  }) : this(
          controller: controller,
          label: label,
          textInputAction: textInputAction,
          keyboardType: TextInputType.visiblePassword,
          validator: Validators.password,
          onFieldSubmitted: onFieldSubmitted,
          obscureText: obscureText,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
        );

  InputField.confirmPassword({
    required TextEditingController controller,
    required TextEditingController confirmPasswordController,
    required Widget suffixIcon,
    required bool obscureText,
    required ValueChanged<String>? onFieldSubmitted,
    String label = 'Confirm Password',
    TextInputAction textInputAction = TextInputAction.done,
    Key? key,
  }) : this(
          key: key,
          controller: controller,
          label: label,
          textInputAction: textInputAction,
          keyboardType: TextInputType.visiblePassword,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Confirm Password is required';
            }
            if (value != confirmPasswordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
          onFieldSubmitted: onFieldSubmitted,
          obscureText: obscureText,
          suffixIcon: suffixIcon,
        );

  InputField.number({
    required TextEditingController controller,
    String label = 'Name',
    TextInputAction textInputAction = TextInputAction.next,
    List<TextInputFormatter>? inputFormatters,
    ValueChanged<String>? onFieldSubmitted,
    Widget? prefixIcon,
  }) : this(
            controller: controller,
            label: label,
            textInputAction: textInputAction,
            keyboardType: TextInputType.number,
            validator: Validators.required,
            onFieldSubmitted: onFieldSubmitted,
            prefixIcon: prefixIcon,
            inputFormatters: inputFormatters ??
                [
                  FilteringTextInputFormatter.digitsOnly,
                ]);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    final validator =
        widget.validator ?? Validators.getValidator(widget.keyboardType);

    return Stack(
      children: [
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: widget.obscureText,
          validator: validator,
          enabled: true,
          onTap: widget.onTap,
          autofocus: widget.autoFocus,
          readOnly: widget.readOnly,
          inputFormatters: widget.inputFormatters,
          onFieldSubmitted: widget.onFieldSubmitted,
          maxLines: widget.maxLines,
          onChanged: widget.onChange,
          style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSecondaryContainer,
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight),
          decoration: InputDecoration(
            hintText: widget.label,
            hintStyle: context.textTheme.bodyMedium?.copyWith(
                color: widget.hintColor,
                fontSize: widget.fontSize,
                fontWeight: widget.fontWeight),
            fillColor: widget.fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                  color: widget.borderColor != null
                      ? widget.borderColor!
                      :  Color(0xFF252934),
                  width: .5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                  color: widget.borderColor != null
                      ? widget.borderColor!
                      :  Color(0xFF252934),
                  width: .5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: context.colorScheme.onSecondaryContainer,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(
                color: Color(0xFFB71C1C),
                width: 1.0,
              ),
            ),
            filled: true,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
                horizontal: widget.horizontalPadding,
                vertical: widget.verticalPadding),
            prefixIcon: widget.prefixIcon,
            prefixIconConstraints: BoxConstraints(
              maxWidth: widget.boxConstraints,
              maxHeight: widget.boxConstraints,
            ),
            suffixIcon: Container(
                margin: EdgeInsets.only(right: 16), child: widget.suffixIcon),
            suffixIconConstraints: BoxConstraints(
              maxWidth: widget.boxConstraints,
              maxHeight: widget.boxConstraints,
            ),
          ),
        ),
      ],
    );
  }
}
