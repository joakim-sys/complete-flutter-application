import 'package:flutter/material.dart';
import 'package:pro_one/newsblocks_ui/overlaid_image.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';

import '../packages/app_ui/app_colors.dart';

class PostMediumOverlaidLayout extends StatelessWidget {
  const PostMediumOverlaidLayout(
      {super.key, required this.title, required this.imageUrl});

  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        OverlaidImage(
            imageUrl: imageUrl,
            gradientColor: AppColors.black.withOpacity(0.7)),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Text(
            title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleSmall
                ?.copyWith(color: AppColors.highEmphasisPrimary),
          ),
        )
      ],
    );
  }
}
