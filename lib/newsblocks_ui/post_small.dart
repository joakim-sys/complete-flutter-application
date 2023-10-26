import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:pro_one/newsblocks_ui/post_footer.dart';

import '../packages/app_ui/app_colors.dart';
import '../packages/app_ui/app_spacing.dart';
import 'block_action_callback.dart';

class PostSmall extends StatelessWidget {
  const PostSmall({required this.block, this.onPressed, super.key});

  static const _imageSize = 80.0;

  final PostSmallBlock block;

  final BlockActionCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final imageUrl = block.imageUrl;

    return GestureDetector(
      onTap: () {
        if (block.hasNavigationAction) onPressed?.call(block.action!);
      },
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.lg),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: _imageSize,
                  height: _imageSize,
                  fit: BoxFit.cover,
                ),
              ),
            Flexible(
              child: PostSmallContent(
                title: block.title,
                publishedAt: block.publishedAt,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@visibleForTesting
class PostSmallContent extends StatelessWidget {
  const PostSmallContent({
    required this.title,
    required this.publishedAt,
    super.key,
  });

  final String title;
  final DateTime publishedAt;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.highEmphasisSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        PostFooter(
          publishedAt: publishedAt,
        ),
      ],
    );
  }
}
