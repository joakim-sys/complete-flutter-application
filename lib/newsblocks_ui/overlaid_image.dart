import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';

class OverlaidImage extends StatelessWidget {
  const OverlaidImage(
      {super.key, required this.imageUrl, required this.gradientColor});

  static const aspectRatio = 3 / 2;
  final String imageUrl;
  final Color gradientColor;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              AppColors.transparent,
              gradientColor.withOpacity(0.7),
            ])),
            child: const SizedBox.expand(),
          )
        ],
      ),
    );
  }
}
