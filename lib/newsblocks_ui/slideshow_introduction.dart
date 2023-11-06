import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:pro_one/newsblocks_ui/block_action_callback.dart';
import 'package:pro_one/newsblocks_ui/post_large.dart';
import 'package:pro_one/newsblocks_ui/slideshow_category.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';

class SlideshowIntroduction extends StatelessWidget {
  const SlideshowIntroduction(
      {super.key,
      required this.block,
      required this.slideshowText,
      this.onPressed});

  final SlideshowIntroductionBlock block;
  final BlockActionCallback? onPressed;
  final String slideshowText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final action = block.action;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: GestureDetector(
        onTap: () {
          if (action != null) onPressed?.call(action);
        },
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            PostLargeImage(
                imageUrl: block.coverImageUrl,
                isContentOverlaid: true,
                isLocked: false),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SlideshowCategory(slideshowText: slideshowText),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    block.title,
                    style: theme.displayMedium
                        ?.copyWith(color: AppColors.highEmphasisPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
