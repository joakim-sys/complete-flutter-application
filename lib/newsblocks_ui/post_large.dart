import 'package:api/client.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:pro_one/newsblocks_ui/inline_image.dart';
import 'package:pro_one/newsblocks_ui/lock_icon.dart';
import 'package:pro_one/newsblocks_ui/overlaid_image.dart';
import 'package:pro_one/newsblocks_ui/post_content.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';
import 'block_action_callback.dart';

class PostLarge extends StatelessWidget {
  const PostLarge(
      {super.key,
      required this.block,
      required this.premiumText,
      required this.isLocked,
      this.onPressed});

  final PostLargeBlock block;
  final String premiumText;
  final bool isLocked;
  final BlockActionCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          block.hasNavigationAction ? onPressed?.call(block.action!) : null,
      child: PostLargeContainer(
        isContentOverlaid: block.isContentOverlaid,
        children: [
          PostLargeImage(
              imageUrl: block.imageUrl!,
              isContentOverlaid: block.isContentOverlaid,
              isLocked: isLocked),
          PostContent(
            title: block.title,
            author: block.author,
            categoryName: block.category.name,
            publishedAt: block.publishedAt,
            isPremium: block.isPremium,
            premiumText: premiumText,
            isContentOverlaid: block.isContentOverlaid,
          )
        ],
      ),
    );
  }
}

class PostLargeContainer extends StatelessWidget {
  const PostLargeContainer(
      {super.key, required this.children, required this.isContentOverlaid});

  final List<Widget> children;
  final bool isContentOverlaid;

  @override
  Widget build(BuildContext context) {
    return isContentOverlaid
        ? Stack(
            alignment: Alignment.bottomLeft,
            children: children,
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              children: children,
            ),
          );
  }
}

class PostLargeImage extends StatelessWidget {
  const PostLargeImage(
      {super.key,
      required this.imageUrl,
      required this.isContentOverlaid,
      required this.isLocked});

  final String imageUrl;
  final bool isContentOverlaid;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isContentOverlaid)
          OverlaidImage(
            imageUrl: imageUrl,
            gradientColor: AppColors.black.withOpacity(0.7),
          )
        else
          InlineImage(imageUrl: imageUrl),
        if (isLocked) const LockIcon()
      ],
    );
  }
}
