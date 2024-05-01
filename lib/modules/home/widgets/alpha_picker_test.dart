import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:xstock/constants/app_colors.dart';

/// Slider for selecting the alpha value (0-255).
class AlphaPickerTest extends StatefulWidget {
  const AlphaPickerTest({
    required this.alpha,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  final int alpha;
  final ValueChanged<int> onChanged;

  @override
  State<StatefulWidget> createState() => _AlphaPickerTestState();
}

class _AlphaPickerTestState extends State<AlphaPickerTest> {
  void valueOnChanged(double ratio) {
    widget.onChanged(ratio.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SliderPicker(

          borderRadius: BorderRadius.zero,
          border: Border.all(color: AppColors.fieldColor),
          value: widget.alpha.toDouble(),
          max: 255.0,
          onChanged: valueOnChanged,
          child: CustomPaint(
            painter: _AlphaTrackPainter(),
          ),
        )
      ],
    );
  }
}

// Track
class _AlphaTrackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double side = size.height / 2;
    final Paint paint = Paint()..color = Colors.black12;

    for (int i = 0; i * side < size.width; i++) {
      if (i % 2 == 0) {
        canvas.drawRect(Rect.fromLTWH(i * side, 0, side, side), paint);
      } else {
        canvas.drawRect(Rect.fromLTWH(i * side, side, side, side), paint);
      }
    }

    final Rect rect = Offset.zero & size;
    const Gradient gradient = LinearGradient(
      colors: <Color>[Colors.transparent, Colors.grey],
    );
    canvas.drawRect(
      rect,
      Paint()..shader = gradient.createShader(rect),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
