import 'package:flutter/material.dart';
import 'package:pro_one/newsblocks_ui/inline_image.dart';
import 'package:pro_one/newsblocks_ui/post_footer.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';

import '../packages/app_ui/app_spacing.dart';

class PostMediumDescriptionLayout extends StatelessWidget {
  const PostMediumDescriptionLayout(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.publishedAt,
      this.description,
      this.author,
      this.onShare});

  final String title;
  final String? description;
  final DateTime publishedAt;
  final String? author;
  final VoidCallback? onShare;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: textTheme.titleLarge
                      ?.copyWith(color: AppColors.highEmphasisSurface),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: InlineImage(imageUrl: imageUrl))
            ],
          ),
          Text(
            description ?? '',
            style: textTheme.bodyMedium
                ?.copyWith(color: AppColors.highEmphasisSurface),
          ),
          const SizedBox(height: AppSpacing.md),
          PostFooter(publishedAt: publishedAt, author: author, onShare: onShare)
        ],
      ),
    );
  }
}
