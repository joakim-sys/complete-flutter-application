import 'package:api/client.dart';
import 'package:flutter/material.dart';
import 'package:pro_one/newsblocks_ui/block_action_callback.dart';
import 'package:pro_one/newsblocks_ui/post_large.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:pro_one/newsblocks_ui/post_medium.dart';

import '../packages/app_ui/app_spacing.dart';

class PostGrid extends StatelessWidget {
  const PostGrid(
      {super.key,
      required this.gridGroupBlock,
      required this.premiumText,
      this.isLocked = false,
      this.onPressed});

  final PostGridGroupBlock gridGroupBlock;
  final String premiumText;
  final bool isLocked;
  final BlockActionCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final firstBlock = gridGroupBlock.tiles.first;
    final otherBlocks = gridGroupBlock.tiles.skip(1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (gridGroupBlock.tiles.isNotEmpty)
            PostLarge(
                block: firstBlock.toPostLargeBlock(),
                premiumText: premiumText,
                isLocked: isLocked),
          const SizedBox(height: AppSpacing.md),
          LayoutBuilder(builder: (context, constraints) {
            final maxWidth = constraints.maxWidth / 2 - (AppSpacing.md / 2);
            return Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: otherBlocks
                  .map((tile) => ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: PostMedium(
                          block: tile.toPostMediumBlock(),
                          onPressed: onPressed,
                        ),
                      ))
                  .toList(),
            );
          })
        ],
      ),
    );
  }
}
