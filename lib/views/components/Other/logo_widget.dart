import 'package:flutter/material.dart';

import '../../../controllers/Generated/Assets/assets.dart';

class LogoWidget extends StatelessWidget {
  final double width;
  final double height;

  const LogoWidget({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.logo,
      color: Theme.of(context).colorScheme.primary,
      colorBlendMode: BlendMode.srcIn,
      width: width,
      height: height,
    );
  }
}
