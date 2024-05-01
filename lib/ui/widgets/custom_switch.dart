import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final double? trackHeight;
  final Color? trackActiveColor;
  final Color? trackInActiveColor;
  final double? thumbHeight;
  final Color? thumbColor;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    super.key,
    required this.onChanged,
    required this.value,
    this.trackHeight = 24,
    this.thumbHeight = 16,
    this.thumbColor = const Color(0xFFD14096),
    this.trackActiveColor = const Color(0xFF01D54D),
    this.trackInActiveColor = Colors.white,
  });

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  Animation? _circleAnimation;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 60));
    _circleAnimation = AlignmentTween(
            begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
            end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(
            parent: _animationController!, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController!.isCompleted) {
              _animationController!.reverse();
            } else {
              _animationController!.forward();
            }
            widget.value == false
                ? widget.onChanged(true)
                : widget.onChanged(false);
          },
          child: Container(
            width: 40.0,

            child: Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 40.0,
                      height: widget.trackHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        color: _circleAnimation!.value == Alignment.centerLeft
                            ? widget.trackInActiveColor
                            : widget.trackActiveColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: widget.value
                      ? ((Directionality.of(context) == TextDirection.rtl)
                          ? Alignment.centerLeft
                          : Alignment.centerRight)
                      : ((Directionality.of(context) == TextDirection.rtl)
                          ? Alignment.centerRight
                          : Alignment.centerLeft),
                  child: Container(
                    margin: EdgeInsets.all(3),
                    width: widget.thumbHeight,
                    height: widget.thumbHeight,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.value ? Colors.white:Colors.grey  ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
