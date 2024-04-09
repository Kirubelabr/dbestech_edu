import 'package:dbestech_edu/core/res/media_res.dart';
import 'package:dbestech_edu/core/widgets/gardient_background.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PageUnderConstruction extends StatelessWidget {
  const PageUnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        image: MediaRes.onBoardingBackground,
        child: Lottie.asset(MediaRes.pageUnderConstruction),
      ),
    );
  }
}
