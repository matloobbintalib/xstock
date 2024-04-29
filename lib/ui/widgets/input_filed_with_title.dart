import 'package:flutter/material.dart';
import 'package:xstock/constants/constants.dart';
import 'package:xstock/utils/validators/validators.dart';

class InputFieldWithTitle extends StatefulWidget {
  final String hint;
  final String floatingHint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final ValueChanged<String>? onFieldSubmitted;
  final int? maxLines;
  final int? maxLength;
  final bool readOnly;
  final Function(String)? onChange;
  final Color fillColor;
  final Color borderColor;
  final Color hintColor;
  final double borderRadius;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final double suffixMargin;
  final bool obscureText;

  const InputFieldWithTitle(
      {super.key,
      required this.hint,
      required this.floatingHint,
      required this.controller,
      this.keyboardType = TextInputType.text,
      this.suffixIcon,
      this.prefixIcon,
      this.onFieldSubmitted,
      this.maxLines,
      this.maxLength,
      this.readOnly = false,
      this.onChange,
      this.fillColor = const Color(0xFF252934),
      this.borderColor = const Color(0xFF252934),
      this.hintColor = Colors.grey,
      this.borderRadius = 20,
      this.onTap,
      this.validator,
      this.textInputAction,
      this.suffixMargin = 16,
        this.obscureText = false,
      });

  @override
  State<InputFieldWithTitle> createState() => _InputFieldWithTitleState();
}

class _InputFieldWithTitleState extends State<InputFieldWithTitle> {
  @override
  Widget build(BuildContext context) {
    final validator =
        widget.validator ?? Validators.getValidator(widget.keyboardType);
    return Container(
      height: 64,
      padding: const EdgeInsets.only(left: 16, right: 12),
      decoration: BoxDecoration(
        color: widget.fillColor,
        border: Border.all(color: widget.borderColor),
        borderRadius: BorderRadius.all(
          Radius.circular(widget.borderRadius),
        ),
      ),
      child: TextFormField(
        validator: validator,
        controller: widget.controller,
        textInputAction: widget.textInputAction,
        onChanged: widget.onChange,
        maxLines: widget.maxLines,
        obscureText: widget.obscureText,
        maxLength: widget.maxLength,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelStyle: TextStyle(fontSize: 18, color: widget.hintColor,fontWeight: FontWeight.w500,fontFamily: AssetPaths.latoFont,),
          labelText: widget.floatingHint,
          hintText:widget.hint,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelStyle:
              const TextStyle(height: .8, color: Colors.grey, fontSize: 18,fontFamily: AssetPaths.latoFont,fontWeight: FontWeight.w400),
          fillColor: widget.fillColor,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          prefixIcon: widget.prefixIcon,
          prefixIconConstraints: const BoxConstraints(maxWidth: 44, maxHeight: 44),
          suffixIcon: Container(
              margin: EdgeInsets.only(right: widget.suffixMargin),
              child: widget.suffixIcon),
          suffixIconConstraints: const BoxConstraints(maxHeight: 44, maxWidth: 58),
        ),
      ),
    );
  }
}
