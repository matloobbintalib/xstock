import 'package:flutter/material.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

import '../../constants/app_colors.dart';
import '../../utils/validators/validators.dart';

class TextFieldWithOutBorder extends StatefulWidget {
  final double vMargin;
  final double? width;
  final double hMargin;
  final double borderRadius;
  final FontWeight fontWeight;
  final double fontSize;
  final double hPadding;
  final double vPadding;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final Function(String) onChanged;
  final TextInputType? keyboardType;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final VoidCallback? onSuffixTapped;
  final Widget? suffixIcon;
  final Color fillColor;
  final Color hintColor;
  final Color textColor;
  final bool readOnly;

  final int maxLines;

  final FormFieldValidator<String>? validator;

  const TextFieldWithOutBorder({
    super.key,
    this.controller,
    required this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.textInputAction,
    this.vMargin = 0,
    this.width,
    this.hMargin = 0,
    this.borderRadius = 5.0,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.style,
    this.hintText,
    this.hintStyle,
    this.focusNode,
    this.suffixIcon,
    this.readOnly = false,
    this.maxLines = 1,
    this.onSuffixTapped,
    this.hPadding = 16,
    this.vPadding = 10,
    this.fillColor = const Color(0xFFEBEBEB),
    this.hintColor = AppColors.grey1,
    this.textColor = AppColors.black,
    this.validator,
  });

  @override
  State<TextFieldWithOutBorder> createState() => _TextFieldWithOutBorderState();
}

class _TextFieldWithOutBorderState extends State<TextFieldWithOutBorder> {
  @override
  Widget build(BuildContext context) {
    final validator =
        widget.validator ?? Validators.getValidator(widget.keyboardType);
    return Container(
      width: widget.width,
      padding: EdgeInsets.symmetric(
          vertical: widget.vMargin, horizontal: widget.hMargin),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        validator: validator,
        maxLines: widget.maxLines,
        readOnly: widget.readOnly,
        textInputAction: widget.textInputAction,
        keyboardType: widget.keyboardType,
        style: TextStyle(
            color: widget.textColor,
            fontWeight: widget.fontWeight,
            fontSize: widget.fontSize),
        onChanged: widget.onChanged,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
                color: widget.hintColor,
                fontWeight: widget.fontWeight,
                fontSize: widget.fontSize),
            fillColor: widget.fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide.none,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                  color: widget.readOnly
                      ? Colors.transparent
                      : context.colorScheme.onSecondaryContainer),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide.none,
            ),
            suffixIconConstraints:
                const BoxConstraints(maxWidth: 44, maxHeight: 44),
            contentPadding: EdgeInsets.symmetric(
                horizontal: widget.hPadding, vertical: widget.vPadding),
            suffixIcon: widget.suffixIcon),
      ),
    );
  }
}
