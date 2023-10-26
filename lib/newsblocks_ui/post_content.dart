import 'package:flutter/material.dart';
import 'package:pro_one/newsblocks_ui/post_content_category.dart';
import 'package:pro_one/newsblocks_ui/post_content_premium_category.dart';
import 'package:pro_one/newsblocks_ui/post_footer.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';

import '../packages/app_ui/app_spacing.dart';

class PostContent extends StatelessWidget {
  const PostContent(
      {super.key,
      required this.title,
      this.publishedAt,
      this.categoryName,
      this.description,
      this.author,
      this.onShare,
      this.isPremium = false,
      this.isContentOverlaid = false,
      this.isVideoContent = false,
      this.premiumText = ''});

  final String title;
  final DateTime? publishedAt;
  final String? categoryName;
  final String? description;
  final String? author;
  final VoidCallback? onShare;
  final bool isPremium;
  final bool isContentOverlaid;
  final bool isVideoContent;
  final String premiumText;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final category = categoryName;
    final hasCategory = category != null && category.isNotEmpty;

    return Padding(
      padding: isContentOverlaid
          ? const EdgeInsets.symmetric(horizontal: AppSpacing.lg)
          : EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              const SizedBox(height: AppSpacing.lg),
              if (hasCategory)
                PostContentCategory(
                    categoryName: categoryName!,
                    isContentOverlaid: isContentOverlaid,
                    isVideoContent: isVideoContent),
              if (isPremium) ...[
                if (hasCategory) const SizedBox(width: AppSpacing.sm),
                PostContentPremiumCategory(
                    premiumText: premiumText, isVideoContent: isVideoContent)
              ]
            ],
          ),
          Text(title,
              style: textTheme.displaySmall?.copyWith(
                  color: isContentOverlaid || isVideoContent
                      ? AppColors.highEmphasisPrimary
                      : AppColors.highEmphasisSurface),
              maxLines: 3,
              overflow: TextOverflow.ellipsis),
          if (publishedAt != null || author != null || onShare != null) ...[
            const SizedBox(height: AppSpacing.md),
            PostFooter(
                publishedAt: publishedAt,
                author: author,
                onShare: onShare,
                isContentOverlaid: isContentOverlaid)
          ]
        ],
      ),
    );
  }
}
