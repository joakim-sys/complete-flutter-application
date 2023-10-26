import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class InlineImage extends StatelessWidget {
  const InlineImage({
    super.key,
    required this.imageUrl,
    this.progressIndicatorBuilder,
  });

  static const _aspectRatio = 3 / 2;
  final String imageUrl;
  final ProgressIndicatorBuilder? progressIndicatorBuilder;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _aspectRatio,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        progressIndicatorBuilder: progressIndicatorBuilder,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
