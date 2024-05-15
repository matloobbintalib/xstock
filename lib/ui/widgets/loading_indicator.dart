import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CircularLoadingIndicator extends StatelessWidget {
  const CircularLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 50,
        width: 50,
        child: const LoadingIndicator(
          indicatorType: Indicator.lineSpinFadeLoader, /// Required, The loading type of the widget
          colors: const [Color(0xFF908f91),Color(0xFFa1a0a3),Color(0xFFaaa9ac),Color(0xFFb6b5b8),Color(0xFFc5c5c7),Color(0xFFcfcecf),Color(0xFFdadadb),Color(0xFFdcdcdd),Color(0xFFdcdcdd),Color(0xFFf8f7f8)],                    /// Optional, The stroke of the line, only applicable to widget which contains line
          backgroundColor: Colors.transparent,/// Optional, the stroke backgroundColor
        ),
      ),
    );
  }
}
