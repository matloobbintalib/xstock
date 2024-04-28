import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class CustomDropDown extends StatefulWidget {
  final String hint;
  final List<String> items;
  final bool disable;
  final Color borderColor;
  final Color hintColor;
  final Color fillColor;
  final Color iconColor;
  final bool isOutline;
  final String? suffixIconPath;
  final double allPadding;
  final double verticalPadding;
  final double horizontalPadding;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double? width;
  final double borderRadius;
  final Function(String value)? onSelect;

  const CustomDropDown(
      {super.key,
      required this.hint,
      required this.items,
      this.hintColor = Colors.black,
      this.suffixIconPath,
      this.disable = false,
      this.borderColor = const Color(0xFFD9D9D9),
      this.fontSize = 14,
      this.onSelect,
      this.isOutline = true,
      this.allPadding = 10,
      this.fontWeight = FontWeight.w400,
      this.horizontalPadding = 24,
      this.verticalPadding = 10,
      this.width,
      this.fillColor = const Color(0xFFB6B6B6),
      this.iconColor = const Color(0xFFB6B6B6),
      this.borderRadius = 10});

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
        child: DropdownButtonFormField(
          isExpanded: true,
          isDense: true,
          icon: SvgPicture.asset(
            'assets/images/svg/ic_drop_down.svg',
            height: 6,
            width: 6,
            color: widget.iconColor,
          ),
          style: TextStyle(
              color: widget.hintColor,
              fontWeight: widget.fontWeight,
              fontSize: widget.fontSize
          ),
          hint: Text(
            widget.hint,
            style: TextStyle(
                color: widget.hintColor,
                fontWeight: widget.fontWeight,
                fontSize: widget.fontSize
            ),
            overflow: TextOverflow.ellipsis,
          ),
          decoration: InputDecoration(
              enabled: true,
              filled: true,
              fillColor: widget.fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(color: widget.borderColor, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide:
                    BorderSide(color: widget.borderColor, width: .5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide:
                    BorderSide(color: widget.borderColor, width: .5),
              ),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: widget.horizontalPadding,
                  vertical: widget.verticalPadding)),
          dropdownColor: const Color(0xffF4F4F4),
          value: dropdownValue,
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
          onChanged: (String? newValue) {
            if (widget.onSelect != null) {
              widget.onSelect!(newValue!);
            }
            setState(() {
              dropdownValue = newValue!;
            });
          },
          menuMaxHeight: 550,
          items: widget.items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                overflow: TextOverflow.ellipsis,
                value,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  color: Colors.black,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
