import 'package:flutter/material.dart';

class StepProgressView extends StatefulWidget {
  final double width;
  final int curStep;
  final Color activeColor;

  const StepProgressView(
      {super.key,
      required this.width,
      required this.curStep,
      required this.activeColor});

  @override
  State<StepProgressView> createState() => _StepProgressViewState();
}

class _StepProgressViewState extends State<StepProgressView> {
  List<String> titles = ['', '', '', ''];
  final Color inactiveColor = Color(0xFFD9D9D9);

  final double lineWidth = 5.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.width,
        child: Row(
          children: _iconViews(),
        ));
  }

  List<Widget> _iconViews() {
    var list = <Widget>[];
    titles.asMap().forEach((i, icon) {
      var lineColor =
          widget.curStep > i + 1 ? widget.activeColor : inactiveColor;
      var iconColor = (i == 0 || widget.curStep > i + 1)
          ? widget.activeColor
          : inactiveColor;

      list.add(
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: iconColor,
          ),
        ),
      );

      //line between icons
      if (i != titles.length - 1) {
        list.add(Expanded(
            child: Container(
          height: lineWidth,
          color: lineColor,
        )));
      }
    });

    return list;
  }
}
