import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';

class AppLogo extends StatelessWidget {
  const AppLogo._({required AssetGenImage logo, super.key}) : _logo = logo;

  AppLogo.dark({Key? key}) : this._(key: key, logo: Assets.images.logoDark);
  AppLogo.light({Key? key}) : this._(key: key, logo: Assets.images.logoLight);
  final AssetGenImage _logo;

  @override
  Widget build(BuildContext context) {
    return _logo.image(
      fit: BoxFit.contain,
      width: 172,
      height: 24,
    );
  }
}
