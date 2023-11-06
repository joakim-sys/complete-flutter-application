import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:pro_one/newsblocks_ui/inline_image.dart';
import 'package:pro_one/newsblocks_ui/post_content.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';

class ArticleIntroduction extends StatelessWidget {
  const ArticleIntroduction(
      {super.key, required this.block, required this.premiumText});

  final ArticleIntroductionBlock block;
  final String premiumText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (block.imageUrl != null) InlineImage(imageUrl: block.imageUrl!),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: PostContent(
            title: block.title,
            categoryName: block.category.name,
            author: block.author,
            publishedAt: block.publishedAt,
            premiumText: premiumText,
            isPremium: block.isPremium,
          ),
        ),
        const Divider(),
        const SizedBox(height: AppSpacing.lg)
      ],
    );
  }
}
