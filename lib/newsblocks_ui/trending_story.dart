import 'package:api/client.dart';
import 'package:flutter/material.dart';
import 'package:pro_one/newsblocks_ui/post_small.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';

class TrendingStory extends StatelessWidget {
  const TrendingStory({super.key, required this.title, required this.block});

  final TrendingStoryBlock block;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.lg),
          child: Text(
            title,
            style:
                theme.textTheme.labelSmall?.apply(color: AppColors.secondary),
          ),
        ),
        PostSmall(block: block.content)
      ],
    );
  }
}
