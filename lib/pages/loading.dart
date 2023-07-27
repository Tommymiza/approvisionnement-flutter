import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LottieBuilder.asset(
        "assets/blue-loading.json",
        width: 150,
        height: 150,
        frameRate: FrameRate(60),
      ),
    );
  }
}
